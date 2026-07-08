# PEROVSAT Driver Model

PEROVSAT device drivers are **out-of-tree Zephyr modules** — separate git repositories cloned into the west workspace and selected at build time through [DBuild](../reference/dbuild/index.md) snippets. Application code talks to hardware through Zephyr's `struct device` API and devicetree aliases; it does not change when you switch between mock and hardware backends.

For Zephyr's general driver concepts (`DEVICE_DT_GET`, devicetree, registration), see [Zephyr Driver Model](./zephyr/drivers.md).

## Physical devices and logical roles

Driver repositories are named after the **physical device** (for example `mpu6050-driver`), not a mission role like IMU or modem. Logical roles are mapped in `perovsat-app`:

- **Devicetree aliases** — application code uses `DT_ALIAS(imu)` regardless of which chip backs it.
- **`dbuild.yml`** — selects which backend mode is active for each logical device at build time.

This separation lets you swap hardware or run mocks without renaming repositories or rewriting application threads.

## Driver–library separation

Each driver repo splits Zephyr integration from device protocol logic:

| Layer | Location | Responsibility |
|-------|----------|----------------|
| Driver shell | `src/<chip>.c` | Zephyr registration, API implementation, `init()` |
| Device library | `lib/<chip>_lib.c` | Register maps, probing, sample fetch — no direct bus calls |
| Transfer backend | `src/*_transfer.c` | How bytes move on/off the device (I2C, register map, socket) |

The library never calls `i2c_read` directly. Instead it receives a **transfer function** at init time and uses it for every register access. The same library code runs against hardware, an in-memory register map, or a simulation socket depending on which transfer backend is compiled in.

```text
Driver API (sample_fetch, channel_get, …)
        ↓
lib/<chip>_lib.c  — register maps, probing, data parsing
        ↓
transfer_fn(ctx, reg, buf, len, read)  — provided by active backend
        ↓
hardware_transfer.c | lib_mock_transfer.c | simulation_transfer.c
```

| Concern | Location |
|---------|----------|
| Register addresses, chip IDs, protocol sequences | `lib/<chip>_lib.h`, `lib/<chip>_lib.c` |
| WHO_AM_I probe, configuration writes | `lib_init()` |
| Burst register reads, sample parsing | Library fetch/read functions |
| Zephyr Sensor API or custom driver API | `src/<chip>.c` |
| Bus I/O, register map, socket I/O | `src/*_transfer.c` |
| Devicetree-sourced config (FS range, bus spec) | `struct <chip>_config` in `src/<chip>.h` |
| Cached samples, runtime state | `struct <chip>_data` in `src/<chip>.h` |

This layout supports a few things we rely on:

- **NDA compliance** — protocol logic can live in a private library while a public mock driver ships hardcoded data with no library linked.
- **Testability** — library functions are pure protocol over an injected transfer; backends are swappable without changing register logic.
- **One repo per device** — all backends live in the same module; build flags pick which `.c` files compile.

## Quad-backend model

Every driver from `driver-template` supports four compile-time backends, selected through Kconfig and set by DBuild via `kconfig_backend` in `dbuild.yml`:

| Backend | Transfer | Library | Typical use |
|---------|----------|---------|-------------|
| `public-mock` | None | Not linked | Onboarding, CI, repos without NDA library access |
| `library-mock` | In-memory register map | Yes | Exercise protocol logic without hardware |
| `simulation` | Socket to external simulator | Yes | SITL (Basilisk integration) |
| `hardware` | Real bus (I2C, SPI, etc.) | Yes | Bench and flight hardware |

At the top level, the driver either returns **static data** from its Zephyr API (`public-mock`) or routes calls through the **library + transfer** path.

For example, an IMU library knows gyro samples live at register `0x3B`. It calls the transfer function it was given; that function might read from a static register map, send the request over a socket, or call Zephyr's `i2c_write_read_dt`. The library does not know which backend is active.

Switch backends by editing `selections` in `dbuild.yml` and rebuilding. See [DBuild overview](./dbuild.md).

## Compile-time backend gating

Driver shell source and CMake use Kconfig symbols to compile only the code paths for the selected backend. When `public-mock` is active, `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)` excludes transfer includes, library calls, and `lib/` sources entirely. CMake links only `src/<chip>.c` for public mock; transfer `.c` files and the device library compile only when their backend symbol is set.

This keeps the public-mock artifact small and avoids linking protocol code that may be unavailable under NDA. Application code does not change across backends — only the build configuration does.

## How application code uses drivers

Application threads resolve devices at compile time through devicetree aliases and call the driver's Zephyr API:

```c
const struct device *imu = DEVICE_DT_GET(DT_ALIAS(imu));

if (!device_is_ready(imu)) {
    /* handle missing device */
}

sensor_sample_fetch(imu);
sensor_channel_get(imu, SENSOR_CHAN_ACCEL_XYZ, accel);
```

The alias `imu` is set in a DBuild snippet overlay. Which chip, bus, and backend are active is entirely a build-time concern.

Not every device uses the Sensor API — mission drivers like the Eyestar modem expose a custom function table instead. The same backend and library patterns apply; only the API surface differs.

## Creating and extending drivers

New drivers start from [`driver-template`](https://github.com/PEROVSAT/driver-template). The MPU6050 driver (`mpu6050-driver`) in the workspace is the reference implementation.

- [Implement a driver](../how-to/drivers/implement-a-driver.md) — step-by-step walkthrough
- [Driver model reference](../reference/driver-model/index.md) — file layout, Kconfig, backends, and code patterns

## Related

- [DBuild](../reference/dbuild/index.md) — per-device mode selection at build time
- [PEROVSAT device drivers](./architecture/drivers.md) — catalog of mission drivers
- [Driver model reference](../reference/driver-model/index.md) — file layout, Kconfig, and backend details
