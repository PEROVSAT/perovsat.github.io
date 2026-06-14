# Custom Sensor Channels

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Zephyr's Sensor API identifies measurements by **channel** (`enum sensor_channel`). Stock channels cover common IMU and environmental readings; mission-specific values (for example per-AMU sweep indices or custom sun-sensor outputs) may need custom channel definitions.

## Typical approach

1. Extend or wrap the sensor driver API with PEROVSAT-specific channel enums or attribute keys.
2. Implement `sample_fetch` / `channel_get` (or a custom API) to populate those channels.
3. Document the channel mapping for the Payload thread and Sensor API middleware.

## Open questions

**This page needs your input.** It is unclear whether "custom channels" refers to:

- Zephyr `sensor_channel` extensions for the Sensor API
- AMU multi-channel sweep indexing
- Something else in the driver-template or payload design

Please confirm the intended scope so this guide can be expanded.

See [Add a Driver API](add-an-api.md) and the planned Sensor API middleware notes in design-and-planning.
