# Device Library

Updated: 7/10/26

## Transfer function type

Declared in `lib/<chip>_lib.h`:

```c
typedef int (*example_transfer_fn)(void *ctx, uint8_t reg, uint8_t *buf, size_t len,
				   bool read);
```

| Parameter | Description |
|-----------|-------------|
| `ctx` | Opaque context, typically the Zephyr `struct device *` |
| `reg` | Register address or protocol offset |
| `buf` | Data buffer |
| `len` | Number of bytes |
| `read` | `true` for read, `false` for write |

Return `0` on success or a negative (`errno`)[https://docs.zephyrproject.org/latest/doxygen/html/group__system__errno.html] value on failure.

## Library API pattern

Typical functions take the transfer callback and context as their first arguments:

```c
int example_lib_init(example_transfer_fn transfer, void *ctx, …);
```

## Public-mock bypass

When `CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK` is set:

- `lib/` is not compiled or linked.
- `src/<chip>.h` omits the `#include` of `<chip>_lib.h`.
- API functions in `src/<chip>.c` return static data without calling the library.