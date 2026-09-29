# Payload Thread Reference

Updated: 9/29/26

Use this as a guide through the design of the payload thread.

## Design

The HW files interact with the DeviceTree to discover hardware. The PayloadReading class enables conversion between raw data and the .RAW filetype. Payload files are main thread loop.

## File Structure

`hw.cpp/hpp`:

- All in compile-time (macros and assertions)
- Builds an array of AMU device references
- Fetches IMU device reference
- Verifies a few things about the AMU references:
    - The AMU indexes defined in the DT start at 0
    - The AMU indexes defined in the DT are contigous (doesn't skip any numbers)
    - The AMU indexes defined in the DT have no duplicates

`PayloadReading.cpp/hpp`:

- Interacts with [.raw files](./raw_filetype.md)
- Creates a bitmask for the data actively in this read cycle
- Save to a dynamically-sized .RAW file based on active bitmask
- Load data from a .RAW file

`payload.cpp/hpp`:

- Defines a merged IV sweep type with both metadata and points
- Defines primary thread loop:
    - Check-in
    - Read IMU
    - TODO: Read sun data
    - Choose which AMUs should be swept (based on sun)
    - Turn on chosen AMUs
    - Sweep chosen AMUs
    - Turn off all AMUs
    - Save data using PayloadReading

## `PayloadReading` API

| Method | Role |
|--------|------|
| `reset()` | Clear validity flags and payload buffers |
| `add_imu(gyro, accel)` | Mark IMU valid; copy 3+3 `sensor_value`s |
| `add_sweep(sweep, index)` | Store sweep at AMU index `i`; set `sweep_mask` bit `i` |
| `save(path)` | Write `.tmp`, then `fs_rename` to `path` (atomic replace) |
| `load(path)` | Read mask, validate bits, read bodies, set `imu_valid` / `sweep_mask` |
| `get_imu` / `get_sweep` | Read back if present in the in-memory reading |

**Load errors:** open/read failures propagate Zephyr FS errno; invalid mask -> `-EINVAL`; partial read -> error and `reset()`.