# Device Library

`lib/` holds bus-agnostic protocol logic. Register access uses an injected transfer callback; the library does not call Zephyr bus APIs directly. The library compiles only for `hardware`, `library-mock`, and `simulation` backends.

## Transfer function type

Declared in `lib/<chip>_lib.h`:

```c
typedef int (*mpu6050_transfer_fn)(void *ctx, uint8_t reg, uint8_t *buf, size_t len,
				   bool read);
```

| Parameter | Description |
|-----------|-------------|
| `ctx` | Opaque context, typically the Zephyr `struct device *` |
| `reg` | Register address or protocol offset |
| `buf` | Data buffer |
| `len` | Number of bytes |
| `read` | `true` for read, `false` for write |

Return `0` on success or a negative `errno` value on failure.

The global `mpu6050_transfer` in `src/*_transfer.c` matches this signature. The driver shell passes it to every library call.

## Library API pattern

Typical functions take the transfer callback and context as their first arguments:

```c
int mpu6050_lib_init(mpu6050_transfer_fn transfer, void *ctx, …);
int mpu6050_lib_sample_fetch(mpu6050_transfer_fn transfer, void *ctx, …);
```

Internal helpers wrap single-byte register access:

```c
static int mpu6050_lib_reg_read_byte(mpu6050_transfer_fn transfer, void *ctx,
				     uint8_t reg, uint8_t *val)
{
	return transfer(ctx, reg, val, 1, true);
}
```

Protocol constants (register addresses, bit masks) live in the library header. The driver shell handles Zephyr API conversion — for example turning raw int16 samples into `struct sensor_value`.

## Public-mock bypass

When `CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK` is set:

- `lib/` is not compiled or linked.
- `src/<chip>.h` omits the `#include` of `<chip>_lib.h`.
- API functions in `src/<chip>.c` return static data without calling the library.

## Library-mock register map

`lib_mock_transfer.c` maintains a static `register_map[]`. Reads and writes operate on that array. `transfer_init` seeds values the library expects during probing — for example WHO_AM_I and power-management register defaults in the MPU6050 driver:

```c
register_map[0x75] = 0x68; /* WHO_AM_I */
register_map[0x6B] = 0x40; /* PWR_MGMT1: sleep bit set */
```

The library runs its normal init and fetch path against this map, exercising protocol logic without hardware.

See [Backends](backends.md) for per-backend compilation rules and [Kconfig and devicetree](kconfig-and-devicetree.md) for config struct layout.
