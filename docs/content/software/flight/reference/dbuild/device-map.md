# `device_map.yml`

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Located at `perovsat-app/dbuild/device_map.yml`. Maps each logical device and mode to a Zephyr snippet and west driver project.

## Schema

```yaml
devices:
  IMU:
    mock:
      snippet: mpu6050-mock
      board_overlay_required: false
      west_project: mpu6050-mock-driver
    hardware:
      snippet: mpu6050-hw
      board_overlay_required: true
      west_project: mpu6050-driver
```

## Fields

| Field | Required | Description |
|-------|----------|-------------|
| `snippet` | Yes | Directory name under `snippets/` passed to `west build -S` |
| `west_project` | Yes | West manifest project name providing the driver module |
| `board_overlay_required` | No (default `false`) | When `true`, snippet must include `boards/<board>.overlay` for the target |

Every device referenced in `dbuild_devices.conf` must appear under `devices:` with a matching mode entry.

Override the map path with `west dbuild -m /path/to/device_map.yml`.

See [The DBuild Command](../dbuild.md) for validation rules.
