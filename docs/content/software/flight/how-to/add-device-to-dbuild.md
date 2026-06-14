# Add a Device to DBuild

!!! warning "Under Construction"
    This page is still under construction. Steps reflect the current IMU reference but may change.

This guide walks through adding a new logical device (for example a sun sensor or radio) to the dbuild system so developers can switch it between mock and hardware modes with a single line in `dbuild_devices.conf`.

For background on how the pieces fit together, see [The DBuild Command](../reference/dbuild.md).

## Overview

Adding a device requires four areas of work:

1. Register driver west projects in `west.yml`.
2. Create mock and hardware snippets under `snippets/`.
3. Add the device to `dbuild/device_map.yml`.
4. Add a line to `dbuild_devices.conf`.

The IMU is the reference implementation today. Use `snippets/imu-mock/`, `snippets/imu-hw/`, and the `IMU` entry in `device_map.yml` as templates.

## 1. Add west driver projects

Each mode needs a Zephyr module that implements the driver (or mock). Add one west project per mode in `west.yml`:

```yaml
- name: sun-sensor-mock-driver
  remote: origin
  revision: main

- name: sun-sensor-driver
  remote: origin
  revision: main
```

Each project must expose a valid Zephyr module at `zephyr/module.yml`. After updating the manifest, sync the workspace:

```bash
west update
```

If a driver repository is private and you lack access, other developers can still use the mock mode by setting the device to `mock` in `dbuild_devices.conf`.

## 2. Create snippets

Create one directory per mode under `snippets/`. Naming convention: `<device>-mock` and `<device>-hw` (for example `sun-z-mock`, `sun-z-hw`).

### Mock snippet

Mock snippets usually need no board-specific wiring.

**`snippets/sun-z-mock/snippet.yml`**

```yaml
name: sun-z-mock
append:
  EXTRA_CONF_FILE: sun-z-mock.conf
  EXTRA_DTC_OVERLAY_FILE: sun-z-mock.overlay
```

**`snippets/sun-z-mock/sun-z-mock.conf`** — enable the mock driver via Kconfig:

```ini
CONFIG_PEROVSAT_SUN_Z_MOCK=y
```

**`snippets/sun-z-mock/sun-z-mock.overlay`** — expose the device through a devicetree alias so application code stays unchanged:

```dts
/ {
	aliases {
		sun-z = &sun_z_mock;
	};

	sun_z_mock: sun_z_mock {
		compatible = "perovsat,sun-z-mock";
		status = "okay";
	};
};
```

Set `board_overlay_required: false` in `device_map.yml` for this mode.

### Hardware snippet

Hardware snippets enable the real driver and wire it to board pins and buses.

**`snippets/sun-z-hw/snippet.yml`**

```yaml
name: sun-z-hw
append:
  EXTRA_CONF_FILE: sun-z-hw.conf
boards:
  nucleo_u575zi_q/stm32u575xx:
    append:
      EXTRA_DTC_OVERLAY_FILE: boards/nucleo_u575zi_q.overlay
```

**`snippets/sun-z-hw/sun-z-hw.conf`**

```ini
CONFIG_SUN_Z_SENSOR=y
```

**`snippets/sun-z-hw/boards/nucleo_u575zi_q.overlay`**

```dts
/ {
	aliases {
		sun-z = &sun_z;
	};
};

&i2c1 {
	sun_z: sun_z@10 {
		compatible = "vendor,sun-z";
		reg = <0x10>;
		status = "okay";
	};
};
```

Set `board_overlay_required: true` for hardware modes. Repeat the `boards:` entry and overlay file for every supported board.

!!! tip "Board short names"
    `west dbuild -b nucleo_u575zi_q` matches on the short board name. Overlay files must be named `boards/<short-name>.overlay` (for example `nucleo_u575zi_q.overlay`), and the board must appear under `boards:` in `snippet.yml`.

## 3. Update `device_map.yml`

Add an entry under `devices:` using the same logical name you will use in `dbuild_devices.conf`:

```yaml
devices:
  SUN-Z:
    mock:
      snippet: sun-z-mock
      board_overlay_required: false
      west_project: sun-sensor-mock-driver
    hardware:
      snippet: sun-z-hw
      board_overlay_required: true
      west_project: sun-sensor-driver
```

Every mode must define both `snippet` and `west_project`. Use the exact west project names from `west.yml`.

## 4. Update `dbuild_devices.conf`

Add one line at the app root so the device is included in builds:

```ini
SUN-Z=mock
```

Use `mock` for development without hardware, or `hardware` when the physical device is connected and board overlays exist for your target.

## 5. Verify the configuration

Preview the resolved build command:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

You should see your new snippets in the `-S` list and no validation errors. Then build:

```bash
west dbuild -b nucleo_u575zi_q
```

Common validation failures:

| Error | Fix |
|-------|-----|
| Unknown device in `dbuild_devices.conf` | Add the device to `device_map.yml`. |
| Invalid mode | Use a mode defined in `device_map.yml` (for example `mock`, `hardware`). |
| Snippet directory missing | Create `snippets/<snippet-name>/` with `snippet.yml`. |
| West project not cloned | Run `west update`, or switch to a mode whose project you have access to. |
| Not supported on board | Add `boards/<board>.overlay` and register the board in `snippet.yml`. |

## Checklist

- [ ] Driver repos added to `west.yml` and cloned (`west update`)
- [ ] Mock snippet created with alias and Kconfig
- [ ] Hardware snippet created with per-board overlays
- [ ] Device added to `dbuild/device_map.yml` with correct `west_project` names
- [ ] Line added to `dbuild_devices.conf`
- [ ] `west dbuild -b <board> --dry-run` succeeds
- [ ] Full build and flash tested on target hardware (for hardware mode)
