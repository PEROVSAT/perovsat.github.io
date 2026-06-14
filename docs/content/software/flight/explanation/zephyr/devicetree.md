# Devicetree

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The devicetree describes hardware topology. PEROVSAT uses board `.dts` files from Zephyr plus **application overlays** and **dbuild snippets** to wire mission devices without hardcoding pins in C.

## Layers

| Layer | Source | Purpose |
|-------|--------|---------|
| SoC / board `.dtsi` / `.dts` | Zephyr tree | CPU, memory, on-board peripherals |
| Board overlay | `boards/<board>.overlay` in app or snippet | Pin/bus wiring for a specific board |
| Snippet overlay | `snippets/*/*.overlay` | Swap mock vs hardware device nodes |

## Key concepts for PEROVSAT

- **`compatible`** — binds a node to a driver (`invensense,mpu6050-mock`, etc.)
- **`reg`** — bus address (I2C) or memory range
- **`status = "okay"`** — enables a node
- **Aliases** — stable names (`imu`, `sun-z`) so application code uses `DT_ALIAS(imu)` regardless of mode
- **Phandles** — `&i2c1 { ... }` modifies an existing node from a lower layer

Mock snippets typically define a standalone node under `/`. Hardware snippets attach child nodes under a bus (`&i2c1 { sensor@addr { ... }; };`).

Official reference: [Zephyr Devicetree](https://docs.zephyrproject.org/latest/build/dts/index.html).
