# Implement a Driver

Updated: 9/29/26

Start with a working public mock, add the device logic, then connect the hardware. Use the [driver template](https://github.com/PEROVSAT/driver-template) and refer to the [AMU driver](https://github.com/PEROVSAT/amu-driver) for implemented examples.

You'll need:

- A working [PEROVSAT workspace](../../tutorials/getting-started.md).
- A Pico 2 and USB cable for the REPL sample.

## 1. Create the repository

Create a GitHub repository from `driver-template`, named `<chip>-driver` after the physical device. Add it in `perovsat-app/west.yml`.

From the workspace root, run the following, replacing `mpu6050-driver` with your repository name:

```bash
source .venv/bin/activate
west update
cd mpu6050-driver
python setup.py
```

Enter the device-model slug and devicetree vendor prefix when prompted. Commit the generated files. Run the remaining commands from the driver repository.

## 2. Run the public mock in the REPL

1. Declare your device operations and their input/output types in `include/<chip>.h`.
2. Implement those operations in `mock/<chip>.c`, returning useful canned values. Keep its `<chip>_init()` free of bus calls.
3. Add shell commands in `samples/repl/src/main.c` to call the operations and print their results. Follow the existing `status` command: use `sh_dev()` to get the device handle.

Keep the generated `samples/repl/app.overlay` for now. Build the sample:

```bash
west build -p always -b rpi_pico2/rp2350a/m33 samples/repl
```

Follow the flashing process in the [hardware tutorial](../../tutorials/running-on-hardware.md)

```bash
west flash -r uf2
```

Open the Pico's USB serial port in a serial terminal. Run `<chip> status`, then your new commands. Confirm that the driver reports ready and returns the canned values you chose.

**Checkpoint:** every operation you plan to implement can be called from the shell.

## 3. Run the device library with a mock bus

Implement the same operations in `lib/<chip>.c`, including the device's initialization logic. Put protocol constants in `lib/<chip>_regs.h`.

Include `<chip>_bus.h` and use `<chip>_transfer(dev->bus_ctx, ...)` for bus access and `<chip>_delay()` for waits. If your device needs a different transfer signature, update the header and each implementation to match.

Next, fill in `src/lib_mock_transfer.c`:

1. Implement `<chip>_transfer()` to emulate the responses the library expects.
2. Seed initial values in `<chip>_transfer_init()`, including anything read during device initialization.
3. Handle writes and state changes needed by your operations, such as a command becoming complete.

See the [AMU library mock](https://github.com/PEROVSAT/amu-driver/blob/main/src/lib_mock_transfer.c) for an example.

In `samples/repl/prj.conf`, replace the `BACKEND_PUBLIC_MOCK=y` selection with `BACKEND_LIBRARY_MOCK=y`, keeping the generated driver prefix. Rebuild and flash using the commands above, then rerun the same shell commands.

**Checkpoint:** the shell now exercises the real library through the mock bus, with the expected results.

## 4. Add unit tests

In `tests/unit/src/main.c`, enable or replace the commented example. Define test versions of `<chip>_transfer()` and `<chip>_delay()` to control responses and avoid real waits. These tests compile the library directly, so create a device object and call `<chip>_init()` yourself.

Test successful operations, invalid inputs, and transfer failures; include timeouts if the library polls for completion. The [AMU tests](https://github.com/PEROVSAT/amu-driver/blob/main/tests/unit/src/main.c) show the pattern.

```bash
west twister -T tests/unit -p qemu_cortex_m3
```

## 5. Connect the hardware

Use the working library with a real bus by filling in the Zephyr integration:

1. **Binding:** add the bus binding and needed properties to `dts/bindings/<vendor>,<chip>.yaml`.
2. **Config:** add the bus specification to the driver config in `src/<chip>_priv.h`, guarded by the hardware backend symbol. Populate it in the per-instance macro in `src/<chip>.c`, along with any devicetree settings.
3. **Kconfig:** select the bus subsystem on the hardware backend symbol in `src/Kconfig` (for example, `select I2C`).
4. **Transfer:** implement real I/O in `src/hardware_transfer.c`. The transfer context is the Zephyr device pointer; use its config to access the bus. Check bus readiness in `<chip>_transfer_init()`.
5. **Sample:** move the device node onto its bus in `samples/repl/app.overlay`, provide its address and required properties, and configure the bus pins. Preserve the device alias and USB console configuration.

Use the AMU driver's [config](https://github.com/PEROVSAT/amu-driver/blob/main/src/amu_priv.h), [registration](https://github.com/PEROVSAT/amu-driver/blob/main/src/amu.c), and [hardware transfer](https://github.com/PEROVSAT/amu-driver/blob/main/src/hardware_transfer.c) as examples.

Replace the sample's backend selection with `BACKEND_HARDWARE=y`. Connect the device, rebuild, flash, and verify the same shell operations against hardware. Zephyr calls device initialization at boot; the REPL retrieves the initialized handle through `<chip>_from_dev()`.

## 6. Integrate with the application

Follow [Wire a Driver into perovsat-app](../dbuild/add-a-device.md) to add snippets and register the logical device in DBuild.
