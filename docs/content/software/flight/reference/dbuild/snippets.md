# DBuild Snippets

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Snippets live under `perovsat-app/snippets/<name>/`. Each is a small Zephyr configuration bundle applied via `west build -S`.

## Required files

| File | Purpose |
|------|---------|
| `snippet.yml` | Registers snippet name and which conf/overlay files to append |
| `*.conf` | Kconfig fragments (enable driver symbols) |
| `*.overlay` or `boards/<board>.overlay` | Devicetree changes (aliases, device nodes) |

## Example mock snippet

```yaml
# snippet.yml
name: mpu6050-mock
append:
  EXTRA_CONF_FILE: mpu6050-mock.conf
  EXTRA_DTC_OVERLAY_FILE: mpu6050-mock.overlay
```

Mock snippets usually set a devicetree alias (for example `imu = &mpu6050_mock`) and enable `CONFIG_*_MOCK=y`.

## Example hardware snippet

Hardware snippets often list supported boards:

```yaml
name: mpu6050-hw
append:
  EXTRA_CONF_FILE: mpu6050-hw.conf
boards:
  nucleo_u575zi_q/stm32u575xx:
    append:
      EXTRA_DTC_OVERLAY_FILE: boards/nucleo_u575zi_q.overlay
```

`west dbuild` matches boards by **short name** (`nucleo_u575zi_q`).

Official Zephyr docs: [Snippets](https://docs.zephyrproject.org/latest/build/snippets/index.html).

See also [Add a device to dbuild](../../how-to/add-device-to-dbuild.md).
