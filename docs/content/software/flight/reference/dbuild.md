# The DBuild Command

!!! warning "Under Construction"
    This page is still under construction. Core behavior is documented but details may change.

DBuild (Device Build) is a custom [west](https://docs.zephyrproject.org/latest/develop/west/index.html) command for PerovSat flight software. It reads a per-developer device configuration, resolves each device to a Zephyr snippet, validates that the build is possible on the chosen board, and runs `west build` with the correct `-S` flags.

Application source code does not change between mock and hardware modes. Only devicetree aliases and Kconfig selections differ, and those live in snippets.

## Data flow

```text
dbuild_devices.conf  →  device_map.yml  →  snippets/*  →  west build -S ...
```

1. **`dbuild_devices.conf`** — declares which mode each logical device uses (for example `mock` or `hardware`).
2. **`dbuild/device_map.yml`** — maps each `(device, mode)` pair to a snippet name and west driver project.
3. **`snippets/`** — atomic Zephyr snippets (overlay, Kconfig, and optional board-specific overlays).
4. **West driver repos** — Zephyr modules listed in `west.yml` that provide the actual drivers.

`west dbuild` performs all resolution and validation before CMake runs, so misconfiguration fails fast with a clear error instead of a cryptic build failure.

## Configuration files

### `dbuild_devices.conf`

Located at the root of `perovsat-app`. This file is committed to the repository and edited to match your current hardware setup.

Each line is a `DEVICE=mode` assignment:

```ini
# Valid modes depend on the device; today: mock, hardware
IMU=hardware
```

Comments start with `#`. Device names are case-sensitive and must match keys in `device_map.yml`. Mode values are normalized to lowercase.

To preview what a configuration resolves to without building:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

### `dbuild/device_map.yml`

Maps logical device names to build artifacts. Each device has one entry per supported mode:

```yaml
devices:
  IMU:
    mock:
      snippet: imu-mock
      board_overlay_required: false
      west_project: imu-mock-driver
    hardware:
      snippet: imu-hw
      board_overlay_required: true
      west_project: imu-driver
```

| Field | Required | Description |
|-------|----------|-------------|
| `snippet` | Yes | Directory name under `snippets/` passed to `west build -S`. |
| `west_project` | Yes | Name of the west manifest project that provides the driver module. |
| `board_overlay_required` | No (default `false`) | When `true`, the snippet must provide a board overlay for the target board. Typically `true` for hardware modes and `false` for mock modes. |

## Snippets

Snippets are small, device-scoped Zephyr configuration bundles under `snippets/<snippet-name>/`. Each snippet typically includes:

- **`snippet.yml`** — registers the snippet with Zephyr's snippet system.
- **`.conf` file** — Kconfig fragments (for example enabling a driver or mock).
- **`.overlay` or `boards/<board>.overlay`** — devicetree changes, often setting the `imu` (or other) alias.

Mock snippets usually apply a single overlay and do not need board-specific wiring. Hardware snippets often use `boards/<board>.overlay` because pin and bus assignments differ per board.

Example mock snippet (`snippets/imu-mock/`):

```yaml
# snippet.yml
name: imu-mock
append:
  EXTRA_CONF_FILE: imu-mock.conf
  EXTRA_DTC_OVERLAY_FILE: imu-mock.overlay
```

Example hardware snippet with board support (`snippets/imu-hw/`):

```yaml
# snippet.yml
name: imu-hw
append:
  EXTRA_CONF_FILE: imu-hw.conf
boards:
  nucleo_u575zi_q/stm32u575xx:
    append:
      EXTRA_DTC_OVERLAY_FILE: boards/nucleo_u575zi_q.overlay
```

`west dbuild` matches boards by **short name** (the part before `/` or `@`). You can pass `-b nucleo_u575zi_q` even though `snippet.yml` lists the full board qualifier `nucleo_u575zi_q/stm32u575xx`.

## West integration

The command is registered in `west.yml` under the application project's `self` entry:

```yaml
self:
  path: perovsat-app
  west-commands: dbuild/west-commands.yml
```

Implementation lives in `dbuild/west_commands/dbuild.py`. After cloning or when the extension changes, run `west update` once so west discovers the command.

## Validation

Before invoking `west build`, `dbuild` checks:

- Every device in `dbuild_devices.conf` is defined in `device_map.yml`.
- Every mode referenced is valid for that device.
- Every mode entry defines `snippet` and `west_project`.
- Every resolved snippet directory exists under `snippets/`.
- Every required west project is listed in `west.yml`, cloned in the workspace, and contains `zephyr/module.yml`.
- For modes with `board_overlay_required: true`, the snippet provides `boards/<board>.overlay` and lists that board in `snippet.yml`.

If a required west project is missing (for example a private driver you do not have access to), choose a different mode in `dbuild_devices.conf` or run `west update` after gaining access.

## Command-line interface

```bash
west dbuild -b <board> [options] [-- extra west build args]
```

| Option | Description |
|--------|-------------|
| `-b`, `--board` | **Required.** Target board short name (for example `nucleo_u575zi_q`, `native_sim`). |
| `-f`, `--devices-file` | Path to device config (default: `dbuild_devices.conf`). |
| `-m`, `--device-map` | Path to device map (default: `dbuild/device_map.yml`). |
| `-d`, `--build-dir` | Build directory to create or use. |
| `-p`, `--pristine` | Pristine build policy: `auto`, `always`, or `never` (default: `always`). |
| `-n`, `--dry-run` | Print the resolved `west build` command without running it. |
| `--` | Pass additional arguments through to `west build` (for example `-DCONFIG_LOG_DEFAULT_LEVEL=4`). |

### Default pristine builds

`west dbuild` defaults to `-p always` so changes to device modes or snippets produce a clean build directory and a binary that matches `west flash`. Use `-p never` for faster incremental rebuilds when you know the device configuration is unchanged.

### Typical workflow

```bash
# Edit dbuild_devices.conf, then build
west dbuild -b nucleo_u575zi_q

# Flash using the same build directory
west flash
```

On Linux or WSL, you can build and run under `native_sim`:

```bash
west dbuild -b native_sim -t run
```

## File reference

| File | Purpose |
|------|---------|
| `dbuild_devices.conf` | Per-device mode selection (committed) |
| `dbuild/device_map.yml` | Device → mode → snippet and west project mapping |
| `dbuild/west-commands.yml` | Registers `west dbuild` with west |
| `dbuild/west_commands/dbuild.py` | Command implementation |
| `snippets/` | Atomic Zephyr snippets per device and mode |
| `west.yml` | West manifest, including driver modules and the dbuild extension |

## Related guides

- [Getting Started](../tutorials/getting-started.md) — workspace setup and first build
- [Add a device to dbuild](../how-to/add-device-to-dbuild.md) — step-by-step guide for new devices
