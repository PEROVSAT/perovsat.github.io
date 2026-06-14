# Driver Model

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT device drivers are **out-of-tree Zephyr modules** — separate git repos cloned into the west workspace and selected at build time through dbuild snippets.

## Pages

- [Components](components.md) — standard repo layout from `driver-template`
- [Testing Scaffold](testing.md) — unit, integration, and SITL harnesses

## Modes

| Mode | Repo | Build role |
|------|------|------------|
| Mock | `*-mock-driver` | Synthetic device for dev without hardware |
| Hardware | `*-driver` | Real bus transactions (may be NDA/private) |
| Emulation | Hardware repo + emul Kconfig | Same driver code, I2C emulator backend |

## Related

- [Creating a Driver](../../how-to/drivers/creation.md)
- [Zephyr Driver Model](../../explanation/zephyr/drivers.md)
