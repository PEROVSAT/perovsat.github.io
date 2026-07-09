# DBuild Snippets

Updated: 7/9/26

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

Simple snippets like mocks only need to define a name, overlay, and conf file:

```yaml
name: mpu6050-public-mock
append:
  EXTRA_CONF_FILE: mpu6050-public-mock.conf
  EXTRA_DTC_OVERLAY_FILE: mpu6050-public-mock.overlay
```

However, snippets with per-board overlays must define them individually in a boards section:

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

## Naming convention

Snippet directory names typically follow `<device>-<mode>`. The `snippet` field in `dbuild.yml` must match the directory name.

See [Add a device to DBuild](../../how-to/dbuild/add-device.md) for the full registration workflow.
