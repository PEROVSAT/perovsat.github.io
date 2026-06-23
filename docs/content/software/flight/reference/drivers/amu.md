# AMU Driver Reference
## Design
The underlying library is singleton-based, but the driver resolves which device in the Zephyr DeviceTree it should access

## IV Sweep Struct
```c
struct iv_sweep {
    float tsensor_start;
    float tsensor_end;
    uint32_t time_start;
    uint32_t time_end;
    float voltage[IV_POINTS];
    float current[IV_POINTS];
};
```

## API
`const struct device *dev` is implied at the start of all driver API methods
### `int do_iv_sweep(iv_sweep *sweep)`
#### Description
Do the temperature and PV cell readings to sweep an IV curve
#### Parameters
`iv_sweep *sweep` - Memory pointer to place sweep data. Struct details are above
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Sweep measured successfully |
| -EIO | Error | Communication Error |
| -ENODEV| Error | Could not find device |
| -1 | Error | Additional Errors TBD |

