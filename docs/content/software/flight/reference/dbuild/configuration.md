# `dbuild.yml`

Updated: 7/9/26

Located at the root of `perovsat-app`. This single file holds both the active device mode selections and the full device catalog.

## Top-level structure

```yaml
selections:
  DEVICE1_LOGICAL_NAME: mode1
  DEVICE2_LOGICAL_NAME: mode2

devices:
  DEVICE1_LOGICAL_NAME:
    west_project: device1-driver
    modes:
      mode1:
        snippet: device1-public-mock
        kconfig_backend: CONFIG_PEROVSAT_DEVICE1_BACKEND_PUBLIC_MOCK
      # ... additional modes
  # ... additional devices
```

Both `selections` and `devices` are required. Mode strings in `selections` are normalized to lowercase when loaded.

## `selections`

Maps each logical device name to the mode used for the next build. This is the section edited day-to-day.

| Property | Description |
|----------|-------------|
| Key | Logical device name (case-sensitive; must exist under `devices`) |
| Value | Mode name (must be defined for that device under `devices.<name>.modes`) |

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

!!! warning
    This feature is untested. If you test it and it works, please remove this warning

```bash
west dbuild -b nucleo_u575zi_q --config /path/to/alternate.yml
```

Default: `dbuild.yml` in the application root.

See also [Command-line interface](cli.md) and [Snippets](snippets.md).
