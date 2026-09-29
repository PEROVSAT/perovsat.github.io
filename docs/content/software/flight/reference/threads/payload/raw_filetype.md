# `.raw` Filetype

Updated: 9/29/26

Binary files produced by the payload thread and read/written through `payload::PayloadReading`

## Overview

One `.raw` file holds **one sampling cycle**: optional IMU samples plus zero or more AMU IV sweeps. Which payloads are present is encoded in a **32-bit presence mask** at the start of the file; body bytes follow in a fixed order.

## Location and Naming

The payload thread writes:

```text
/lfs/payload/outbox/<boot_count>_<record_id>.raw
```

## File Layout (byte order)

All multi-byte integers and IEEE-754 floats use **native endianness** (little-endian on the flight MCU). Structures are written with `fs_write` as contiguous memory images—no extra framing, compression, or checksum at the file level.

| Offset (logical) | Size | Content |
|------------------|------|---------|
| 0 | 4 | `file_mask` (`uint32_t`) |
| 4+ | variable | Payload bodies (see below) |

### `file_mask` bits

Documented in `PayloadReading.hpp` and `payload.hpp`:

| Bit | Meaning |
|-----|---------|
| **0** | IMU block present |
| **1 + i** | AMU sweep for **payload-index** `i` present (`i` = DeviceTree AMU instance order, `0 … NUM_AMUS-1`) |

In memory, `PayloadReading` keeps AMU presence in `sweep_mask` with **bit `i`** set for index `i`. On save that is shifted:

```text
file_mask = (imu_valid ? BIT(0) : 0) | (sweep_mask << 1)
```

On load, the inverse applies: `file_has_imu = bit 0`, `file_sweep_mask = file_mask >> 1`.

**Limits:** `NUM_AMUS` is the count of `status = "okay"` AMU nodes in Devicetree. The mask reserves bit 0 for IMU, so at most **31 AMUs** (`static_assert` in `payload.hpp`). Unknown bits above `kKnownFileBits` cause `load()` to return `-EINVAL`.

### Payload body order

Bodies are written **only for set bits**, in **ascending bit order** (same loop order in `write_payloads` / `read_payloads`):

1. **If bit 0 set — IMU**
   - `gyro[3]` — `struct sensor_value` (Zephyr: `int32_t val1`, `int32_t val2` each → **8 bytes** per axis, **24 bytes** total)
   - `accel[3]` — same layout, **24 bytes**
2. **For each `i` from `0` to `NUM_AMUS-1`**
   - If bit `(1 + i)` set: one `iv_sweep_t` for AMU index `i`.

**File size** depends on which bits are set:

```text
size = 4 + (bit0 ? 48 : 0) + (count of set AMU bits) × sizeof(iv_sweep_t)
```

`sizeof(iv_sweep_t)` comes from the firmware build (see nested types below).

## `iv_sweep_t` (one AMU sweep)

From `payload.hpp` — mirrors what the AMU driver returns:

```cpp
struct iv_sweep_t {
    amu_sweep_meta_t meta;  // packed, device register layout
    amu_sweep_iv_t iv;
};
```

### `amu_sweep_meta_t` (`amu.h`, `__attribute__((packed))`)

| Field | Type |
|-------|------|
| `voc`, `isc`, `tsensor_start`, `tsensor_end`, `ff`, `eff`, `vmax`, `imax`, `pmax`, `adc` | `float` × 10 |
| `timestamp`, `crc` | `uint32_t` × 2 |

### `amu_sweep_iv_t` (`amu.h`)

| Field | Type |
|-------|------|
| `voltage[IV_POINTS]`, `current[IV_POINTS]` | `float` each |

Default `IV_POINTS` is **40** unless overridden at compile time (`amu-driver/include/amu.h`).