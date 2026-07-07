# DBuild Reference

DBuild is a custom [west](https://docs.zephyrproject.org/latest/develop/west/index.html) command for PEROVSAT flight software. It reads `dbuild.yml`, resolves each selected device to a Zephyr snippet and backend Kconfig symbol, validates the build configuration, and invokes `west build` with the correct flags.

Application source does not change between modes. Only devicetree aliases, Kconfig selections, and which driver modules are required differ — and those are driven by snippets and `dbuild.yml`.

## Data flow

```text
dbuild.yml (selections → devices)  →  snippets/* + backend -D flags  →  west build -S …
```

## Pages

- [Configuration](configuration.md) — `dbuild.yml` schema (`selections` and `devices`)
- [Command-line interface](cli.md) — `west dbuild` flags, examples, and troubleshooting
- [Snippets](snippets.md) — snippet directory layout and Zephyr integration

## Source files

| File | Purpose |
|------|---------|
| `dbuild.yml` | Device selections and mode catalog |
| `dbuild/west-commands.yml` | Registers `west dbuild` with west |
| `dbuild/west_commands/dbuild.py` | Command implementation |
| `snippets/` | Per-mode Zephyr snippets |
| `west.yml` | West manifest, including driver modules |

The command is registered on the application project's `self` entry in `west.yml`:

```yaml
self:
  path: perovsat-app
  west-commands: dbuild/west-commands.yml
```

After cloning or when the extension changes, run `west update` once so west discovers the command.

## Related

- [DBuild overview](../../explanation/dbuild/index.md) — conceptual background
- [Getting Started](../../tutorials/getting-started.md) — first build with `public-mock` modes
- [Add a device to DBuild](../../how-to/dbuild/add-device.md) — register a new logical device
