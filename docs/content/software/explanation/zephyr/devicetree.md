# DeviceTree

!!! warning "Under Construction"
    This article is not written yet.

Topics to cover when this page is written:

- What DeviceTree is and why Zephyr (and Linux) use it
- Board `.dts` vs application **overlay** (`.overlay`)
- **Bindings** — how node types and properties are defined
- **Aliases** and `chosen` — naming devices for application code (e.g. `get_device(IMU)`)
- How overlays link board hardware to PEROVSAT-specific names and purposes
- Relationship to drivers (compatible strings, `status = "okay"`)
- Pointers to official Zephyr DeviceTree docs for schema and binding reference
