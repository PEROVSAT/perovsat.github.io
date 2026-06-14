# Zephyr Driver Model

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Zephyr represents hardware as **`struct device`** instances registered at boot from devicetree. Drivers supply config (ROM), data (RAM), and an optional API function table.

## Resolving devices in C

Common macros:

| Macro | Use |
|-------|-----|
| `DT_NODELABEL(label)` | By node label |
| `DT_ALIAS(name)` | By alias (preferred for app code) |
| `DT_CHOSEN(prop)` | Zephyr-chosen device (console, etc.) |
| `DEVICE_DT_GET(node)` | Get `const struct device *` at compile time |

Always check readiness after boot:

```c
if (!device_is_ready(dev)) {
    return -ENODEV;
}
```

## Registering an out-of-tree driver

1. Define `DT_DRV_COMPAT` matching the YAML binding compatible string.
2. Implement `init()` and optional PM callback.
3. Declare config/data structs; map devicetree properties in a per-instance init macro.
4. Register with `DEVICE_DT_INST_DEFINE` + `DT_INST_FOREACH_STATUS_OKAY`.

PEROVSAT driver repos follow this pattern via `driver-template`. See [Driver Model Components](../../reference/driver-model/components.md).

## Parent buses

Use `DT_BUS(node_id)` to reach the parent controller (for example I2C bus from a sensor node).

Official reference: [Zephyr Device Driver Model](https://docs.zephyrproject.org/latest/kernel/drivers/index.html).
