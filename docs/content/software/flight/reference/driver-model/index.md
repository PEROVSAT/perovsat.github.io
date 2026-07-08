# Driver Model Reference

Technical reference for what PEROVSAT out-of-tree Zephyr drivers do differently from a standard Zephyr driver module. For concepts and architecture, see [Driver Model overview](../../explanation/driver-model.md).

This reference does not cover Zephyr driver fundamentals (`struct device`, registration macros, devicetree). See the [Zephyr Device Driver Model](https://docs.zephyrproject.org/latest/kernel/drivers/index.html).

PEROVSAT-specific mechanics:

- **Quad-backend selection** — four compile-time backends (`public-mock`, `library-mock`, `simulation`, `hardware`); Kconfig `choice` + CMake `zephyr_library_sources_ifdef`; DBuild sets the active symbol per logical device
- **Layered file layout** — driver shell (`src/<chip>.c`), transfer backends (`src/*_transfer.c`), and bus-agnostic library (`lib/`)
- **Transfer injection** — library code calls an injected `transfer_fn`; the active backend implements bus I/O, register map, or socket I/O
- **Preprocessor gating** — `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)` excludes transfer and library paths when public mock is active
- **Template tokens** — `driver-template` `setup.py` substitutes `__DRIVER_SLUG__`, `__KCONFIG_SYM__`, and related tokens across the repo

The [MPU6050 driver](https://github.com/PEROVSAT/mpu6050-driver) is the reference implementation.

## Pages

- [Repository layout](repository-layout.md) — file tree, `module.yml`, CMake conditional compilation, template tokens
- [Backends](backends.md) — backend table, transfer contract, init flow, DBuild integration
- [Device library](device-library.md) — transfer function type, library API pattern, public-mock bypass
- [Kconfig and devicetree](kconfig-and-devicetree.md) — symbols, bindings, config/data structs, driver registration

## Related

- [DBuild](../dbuild/index.md) — per-device mode selection and snippet wiring
- [Driver catalog](../drivers/index.md) — mission-specific API references
