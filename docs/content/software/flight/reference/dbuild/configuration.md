# `dbuild.yml`

Located at the root of `perovsat-app`. This single file holds both the active device mode selections and the full device catalog.

## Top-level structure

```yaml
selections:
  IMU: public-mock
  MODEM: public-mock
  AMU: hardware
  FLASH: simulation

devices:
  IMU:
    west_project: mpu6050-driver
    modes:
      public-mock:
        snippet: mpu6050-public-mock
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK
      # … additional modes
```

Both `selections` and `devices` are required. Mode strings in `selections` are normalized to lowercase when loaded.

## `selections`

Maps each logical device name to the mode used for the next build. This is the section edited day-to-day.

| Property | Description |
|----------|-------------|
| Key | Logical device name (case-sensitive; must exist under `devices`) |
| Value | Mode name (must be defined for that device under `devices.<name>.modes`) |

Example:

```yaml
selections:
  IMU: public-mock
  AMU: hardware
```

To preview what the current selections resolve to without building:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

## `devices`

Catalog of all logical devices and the build artifacts for each supported mode.

### Device entry

| Field | Required | Description |
|-------|----------|-------------|
| `west_project` | No | West manifest project name that provides the driver Zephyr module. Omitted for devices that need only snippets (for example FLASH). |
| `modes` | Yes | Map of mode name → mode configuration (see below). Must be non-empty. |

### Mode entry

| Field | Required | Description |
|-------|----------|-------------|
| `snippet` | Yes | Directory name under `snippets/` passed to `west build -S`. |
| `kconfig_backend` | No | Kconfig symbol set to `y` via CMake (`-D<SYMBOL>=y`). Selects the driver backend implementation. |
| `board_overlay_required` | No (default `false`) | When `true`, the snippet must provide `boards/<board>.overlay` and list that board in `snippet.yml`. Typically `true` for `hardware` and `simulation` modes. |

### Example: IMU

```yaml
  IMU:
    west_project: mpu6050-driver
    modes:
      public-mock:
        snippet: mpu6050-public-mock
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK
      library-mock:
        snippet: mpu6050-library-mock
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_LIBRARY_MOCK
      simulation:
        snippet: mpu6050-simulation
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_SIMULATION
        board_overlay_required: true
      hardware:
        snippet: mpu6050-hardware
        kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE
        board_overlay_required: true
```

### Example: device without a west project

```yaml
  FLASH:
    modes:
      simulation:
        snippet: nor-flash-sim
```

FLASH has no `west_project` and no `kconfig_backend`; only the snippet is applied.

## Validation

Before invoking `west build`, DBuild checks:

- `selections` and `devices` are present and `selections` is non-empty.
- Every device in `selections` exists under `devices`.
- Every selected mode exists for that device.
- Every mode entry defines `snippet`.
- Every resolved snippet directory exists under `snippets/`.
- If `west_project` is set: the project is listed in `west.yml`, cloned in the workspace, and contains `zephyr/module.yml`.
- If `board_overlay_required` is `true`: the snippet has `boards/<board>.overlay` and declares that board in `snippet.yml`.

Misconfiguration fails with a clear error before CMake runs.

## Overriding the config path

```bash
west dbuild -b nucleo_u575zi_q --config /path/to/alternate.yml
```

Default: `dbuild.yml` in the application root.

See also [Command-line interface](cli.md) and [Snippets](snippets.md).
