# DBuild Reference

Updated: 7/10/26

DBuild resolves per-device build modes from `dbuild.yml` and invokes `west build` with the matching snippets and backend Kconfig symbols. For the *why*, see [DBuild](../../explanation/dbuild.md).

## File layout

Everything DBuild touches lives in `perovsat-app`:

```text
perovsat-app/
├── dbuild.yml
├── west.yml
├── dbuild/
│   ├── west-commands.yml
│   └── west_commands/
│       └── dbuild.py
└── snippets/
    └── <device>-<mode>/
        ├── snippet.yml
        ├── <device>-<mode>.conf
        ├── <device>-<mode>.overlay          # mock modes
        └── boards/<board>.overlay          # hardware / simulation
```

| Path | Purpose |
|------|---------|
| `dbuild.yml` | Active mode selections and the device/mode catalog |
| `west.yml` | Declares out-of-tree driver projects referenced by `west_project` |
| `dbuild/west-commands.yml` | Registers the `west dbuild` extension |
| `dbuild/west_commands/dbuild.py` | Extension implementation |
| `snippets/<name>/` | One Zephyr snippet per device mode (Kconfig + overlay) |

## Pages

- [`dbuild.yml`](configuration.md) — schema for `selections` and `devices`
- [Snippets](snippets.md) — `snippet.yml`, conf, and overlay layout
- [`west dbuild`](cli.md) — command-line options, examples, and troubleshooting

## Related

- [DBuild overview](../../explanation/dbuild.md) — why build-time selection exists
- [Add a device](../../how-to/dbuild/add-a-device.md) — register a new logical device
- [Driver model](../driver-model/index.md) — out-of-tree driver layout and backends
