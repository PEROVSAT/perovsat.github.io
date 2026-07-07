# `west dbuild`

Build PEROVSAT flight software with per-device modes resolved from `dbuild.yml`.

## Synopsis

```bash
west dbuild -b <board> [options] [west build args] [-- cmake args]
```

`-b` / `--board` is required. Options not listed below are forwarded to `west build` (for example `-t run`, `-c`, `-o=-j8`). Arguments after `--` are passed to CMake.

## Options

| Option | Description |
|--------|-------------|
| `-b`, `--board` | **Required.** Target board short name (for example `nucleo_u575zi_q`, `qemu_cortex_m3`). |
| `--config` | Path to `dbuild.yml` (default: `dbuild.yml` in the application root). |
| `-d`, `--build-dir` | Build directory to create or use. |
| `-p`, `--pristine` | Pristine build policy: `auto`, `always`, or `never` (default: `always`). |
| `--dry-run` | Print the resolved `west build` command without running it. |

## Behavior

1. Load and validate `dbuild.yml`.
2. For each entry in `selections`, resolve the snippet name and optional `kconfig_backend` CMake argument.
3. Construct and run `west build` with:
   - One `-S <snippet>` per selected device.
   - `-p` per the `--pristine` option (default `always`).
   - After `--`: `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`, then each `-D<kconfig_backend>=y`, then any extra CMake args.

On success, DBuild prints the resolved snippets and backend Kconfig symbols before building.

## Examples

Build for a NUCLEO board:

```bash
west dbuild -b nucleo_u575zi_q
```

Build and run under QEMU (as in [Getting Started](../../tutorials/getting-started.md)):

```bash
west dbuild -b qemu_cortex_m3 -t run
```

Preview the resolved command:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

Faster incremental rebuild when device configuration is unchanged:

```bash
west dbuild -b nucleo_u575zi_q -p never
```

Pass extra CMake options:

```bash
west dbuild -b nucleo_u575zi_q -- -DCONFIG_LOG_DEFAULT_LEVEL=4
```

Typical hardware workflow:

```bash
west dbuild -b nucleo_u575zi_q
west flash
```

## Default pristine builds

`west dbuild` defaults to `-p always` so changes to `dbuild.yml` or snippets produce a clean build directory and a binary consistent with `west flash`. Use `-p never` for faster iteration when the device configuration and snippets are unchanged.

## Troubleshooting

### Unknown device in selections

**Message:** `unknown device '…' in selections (not defined under "devices" in dbuild.yml)`

The device name in `selections` does not match a key under `devices`. Device names are case-sensitive.

### Invalid mode

**Message:** `invalid mode '…' for device '…' (valid modes: …)`

The mode in `selections` is not defined under that device's `modes` block. Use one of the listed valid modes.

### Missing snippet directory

**Message:** `requires snippet '…', but … does not exist`

The `snippet` named in the mode entry has no directory under `snippets/`. Create the snippet or fix the name in `dbuild.yml`.

### West project not in manifest

**Message:** `west project '…' … is not listed in west.yml`

Add the driver project to `west.yml` or remove `west_project` if the device does not need an out-of-tree module.

### West project not cloned

**Message:** `west project '…' … is not cloned in this workspace`

Some driver repos are private. Either switch to a mode that does not require that project (for example `public-mock`), or run `west update` after gaining access. Setup may also skip repos you cannot clone — see [Getting Started](../../tutorials/getting-started.md).

### Missing `zephyr/module.yml`

**Message:** `…/zephyr/module.yml is missing`

The west project path exists but is not a valid Zephyr module. Check the driver repository layout.

### Board not supported

**Message:** `is not supported on board '…'; supported boards: …`

The selected mode has `board_overlay_required: true` but the snippet has no `boards/<board>.overlay` for the target board, or the board is not listed in `snippet.yml`. Add board support to the snippet or choose a different board or mode.

### `west` command not found

Activate the workspace Python virtual environment (created by `setup.sh`):

```bash
source ../.venv/bin/activate
```

(from `perovsat-app` inside `perovsat-workspace`).

See [Configuration](configuration.md) for the full `dbuild.yml` schema.
