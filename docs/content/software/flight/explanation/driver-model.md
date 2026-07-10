# PEROVSAT Driver Model

Updated: 7/10/26

PEROVSAT device drivers are **out-of-tree Zephyr modules** — separate git repositories cloned into the west workspace and selected at build time through [DBuild](../reference/dbuild/index.md) snippets. Application code talks to hardware through Zephyr's `struct device` API and devicetree aliases, so it can remain unchanged during backend swaps

For Zephyr's general driver concepts (`DEVICE_DT_GET`, devicetree, registration), see [Zephyr Driver Model](./zephyr/drivers.md).

## The Quad Backend

Every driver from `driver-template` supports four compile-time backends, selected by [DBuild](./dbuild.md)

| Backend | Purpose |
|---------|----------------|
| `public-mock` | Static data that doesn't require the library, so the public can use a driver for NDA hardware |
| `library-mock` | Static data accessed by the library, primarily for testing |
| `simulation` | Fetches data from [Basilisk](../../simulation/index.md) to do [SITL Testing](./testing/sitl.md) |
| `hardware` | Actual hardware device interaction |

## Driver–library separation

Each driver repo splits Zephyr integration from device protocol logic:

| Layer | Location | Responsibility |
|-------|----------|----------------|
| Driver shell | `src/<chip>.c` | Zephyr registration, API implementation, `init()` |
| Device library | `lib/<chip>_lib.c` | Core protocol and register access logic |
| Transfer backend | `src/*_transfer.c` | Defines what actually happens when the library tries to access hardware |

Libraries never call hardware interaction functions like `i2c_read` directly. Instead it receives a **transfer function**, which can proxy to any backend. The same library code runs against hardware, an in-memory register map, or a simulation socket depending on which transfer backend is compiled in.

This layout supports a few things we rely on:

- **NDA compliance** — protocol logic can live in a private library while a public mock driver ships hardcoded data with no library linked.
- **Testability** — library functions are pure protocol over an injected transfer; backends are swappable without changing register logic.

## Related

- [DBuild](../reference/dbuild/index.md) — per-device mode selection at build time
- [PEROVSAT device drivers](./architecture/drivers.md) — catalog of mission drivers
- [Driver model reference](../reference/driver-model/index.md) — file layout, Kconfig, and backend details
