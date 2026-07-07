# DBuild Snippets

Snippets live under `perovsat-app/snippets/<name>/`. Each is a small Zephyr configuration bundle referenced from `dbuild.yml` and applied via `west build -S <name>`.

DBuild resolves one snippet per selected device and passes all of them to `west build`.

## Required files

| File | Purpose |
|------|---------|
| `snippet.yml` | Registers the snippet and which conf/overlay files to append |
| `*.conf` | Kconfig fragments (enable driver and bus options) |
| `*.overlay` or `boards/<board>.overlay` | Devicetree changes (aliases, device nodes, buses) |

Official Zephyr documentation: [Snippets](https://docs.zephyrproject.org/latest/build/snippets/index.html).

## `snippet.yml`

### Global overlay (mock and simple modes)

Modes like `public-mock` usually apply one conf file and one overlay for all boards:

```yaml
name: mpu6050-public-mock
append:
  EXTRA_CONF_FILE: mpu6050-public-mock.conf
  EXTRA_DTC_OVERLAY_FILE: mpu6050-public-mock.overlay
```

### Per-board overlays (hardware and simulation)

Modes that depend on physical wiring or a specific simulated board list supported boards under `boards:`:

```yaml
name: mpu6050-hardware
append:
  EXTRA_CONF_FILE: mpu6050-hardware.conf
boards:
  nucleo_u575zi_q/stm32u575xx:
    append:
      EXTRA_DTC_OVERLAY_FILE: boards/nucleo_u575zi_q.overlay
```

The overlay file must exist at `boards/nucleo_u575zi_q.overlay`. DBuild matches boards by **short name** — the part before `/` or `@`. Passing `-b nucleo_u575zi_q` is valid even when `snippet.yml` uses `nucleo_u575zi_q/stm32u575xx`.

Set `board_overlay_required: true` on the corresponding mode in `dbuild.yml` so DBuild enforces this at build time.

## `.conf` files

Enable the driver and any bus or emulation support the mode needs. Example from `mpu6050-public-mock.conf`:

```ini
CONFIG_PEROVSAT_MPU6050=y
CONFIG_EMUL=y
CONFIG_I2C_EMUL=y
```

The `kconfig_backend` in `dbuild.yml` selects which backend implementation is active; the snippet `.conf` enables the driver and platform pieces that backend expects.

## `.overlay` files

Devicetree overlays wire logical aliases and device nodes. A public-mock IMU might expose an emulated I2C bus and set `imu = &mpu6050`:

```dts
/ {
	aliases {
		imu = &mpu6050;
	};

	i2c_emul: i2c@100 {
		compatible = "zephyr,i2c-emul-controller";
		/* … */
		mpu6050: mpu6050@68 {
			compatible = "zephyr,mpu6050";
			reg = <0x68>;
			status = "okay";
		};
	};
};
```

Hardware overlays under `boards/` set real bus pins and addresses for each supported board.

## Naming convention

Snippet directory names typically follow `<device>-<mode>`, for example `mpu6050-public-mock`, `amu-hardware`, `nor-flash-sim`. The `snippet` field in `dbuild.yml` must match the directory name.

## Mock vs hardware vs simulation

| Mode style | Overlays | `board_overlay_required` |
|------------|----------|---------------------------|
| `public-mock`, `library-mock` | Single root `.overlay` | Usually `false` |
| `hardware` | `boards/<board>.overlay` per supported board | `true` |
| `simulation` | `boards/<board>.overlay` for the sim target (for example `mps2`) | `true` |

See [Add a device to DBuild](../../how-to/dbuild/add-device.md) for the full registration workflow.
