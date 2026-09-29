# Transfer Function API

Updated: 9/29/26

## Transfer function type

Declared in `lib/<chip>_bus.h`:

```c
int mpu6050_transfer(void *ctx, uint8_t reg, uint8_t *buf, size_t len, bool read);
```

| Parameter | Description |
|-----------|-------------|
| `ctx` | Opaque context, typically the Zephyr `struct device *` |
| `reg` | Register address or protocol offset |
| `buf` | Data buffer |
| `len` | Number of bytes |
| `read` | `true` for read, `false` for write |

Return `0` on success or a negative (`errno`)[https://docs.zephyrproject.org/latest/doxygen/html/group__system__errno.html] value on failure.
