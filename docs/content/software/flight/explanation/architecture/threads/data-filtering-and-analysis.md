# Data Filtering and Analysis Thread

Updated: 9/2/26

DFA processes the raw data read by [Payload](payload.md), including:

- Illumination accumulation from sun sensor data
- IV Compression using either:
    - Defined points method
    - Curve fitting method

## Power Status Behavior

| Status | Behavior |
|--------|-------------------|
| **SAFE** / **LOW** | Disabled |
| **NOMINAL** | Defined points analysis only |
| **HIGH** | Full operation |

!!! note "Subject to change"
    NREL has expressed some concerns with having only curve fit data, and more analysis on required compute power is needed

## Wake pattern

Interval: 150–500 epochs

## Dependencies

- LittleFS - Fetch raw payload, write filtered data, delete processed raw data
