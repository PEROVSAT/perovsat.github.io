# Backends

## Backend summary

| Backend | Kconfig symbol | Transfer file | Library linked | Snippet bus setup |
|---------|----------------|---------------|----------------|-------------------|
| `public-mock` | `CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK` | None | No | Emulated bus (for example I2C emul) |
| `library-mock` | `CONFIG_PEROVSAT_<CHIP>_BACKEND_LIBRARY_MOCK` | `lib_mock_transfer.c` | Yes | Emulated bus |
| `simulation` | `CONFIG_PEROVSAT_<CHIP>_BACKEND_SIMULATION` | `simulation_transfer.c` | Yes | Board-specific sim overlay |
| `hardware` | `CONFIG_PEROVSAT_<CHIP>_BACKEND_HARDWARE` | `hardware_transfer.c` | Yes | Per-board physical bus overlay |

## Init flow

### Library backends (`hardware`, `library-mock`, `simulation`)

```text
mpu6050_init()
  → mpu6050_transfer_init(dev)     # open bus, init register map, or open socket
  → mpu6050_lib_init(mpu6050_transfer, dev, …)   # probe device, apply config
```

The driver shell passes the global `mpu6050_transfer` function and a context pointer (typically `dev`) into the library. All subsequent register access goes through that callback.

### Public mock

```text
mpu6050_init()
  → return 0   # no transfer, no library
```

API functions in the driver shell return hardcoded data directly. `transfer.h`, transfer `.c` files, and `lib/` are not compiled or included.

## Transfer contract

Defined in `src/transfer.h`:

```c
int mpu6050_transfer(void *ctx, uint8_t reg, uint8_t *buf, size_t len, bool read);
int mpu6050_transfer_init(const struct device *dev);
```

| Function | Called from | Responsibility |
|----------|-------------|----------------|
| `transfer_init` | Driver `init()` | Verify bus readiness, seed register map, or open simulation socket |
| `transfer` | Device library | Perform one register read or write |

The library calls `transfer(ctx, reg, buf, len, read)` for every byte access. Implementations differ by backend:

| Backend | `transfer` behavior |
|---------|---------------------|
| `hardware` | `i2c_write_read_dt` / `i2c_write_dt` (or equivalent for SPI/UART) |
| `library-mock` | Read/write an in-memory `register_map[]` |
| `simulation` | Serialize request, send over socket, block for response (stub in MPU6050) |

See [Device library](device-library.md) for how the library uses the callback.

## DBuild integration

Two configuration layers select the backend at build time:

1. **Snippet `.conf`** — enables the driver module:

```ini
CONFIG_PEROVSAT_MPU6050=y
```

For mock modes that use Zephyr bus emulation, the snippet also enables:

```ini
CONFIG_EMUL=y
CONFIG_I2C_EMUL=y
```

2. **`dbuild.yml`** — maps the logical device mode to a backend Kconfig symbol. DBuild passes it to CMake:

```yaml
IMU:
  west_project: mpu6050-driver
  modes:
    public-mock:
      snippet: mpu6050-public-mock
      kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK
    hardware:
      snippet: mpu6050-hardware
      kconfig_backend: CONFIG_PEROVSAT_MPU6050_BACKEND_HARDWARE
      board_overlay_required: true
```

Resolved build flags look like:

```text
-DCONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK=y
```

Hardware and simulation modes require a per-board overlay in the snippet. See [DBuild snippets](../dbuild/snippets.md).

## Conditional includes in the driver shell

The driver `.c` and `.h` files use `#if !defined(CONFIG_PEROVSAT_<CHIP>_BACKEND_PUBLIC_MOCK)` to exclude transfer and library code paths when public mock is active:

```c
#if !defined(CONFIG_PEROVSAT_MPU6050_BACKEND_PUBLIC_MOCK)
#include "transfer.h"
#endif
```

Public-mock API implementations live in the `#else` branch of the same file.

See [Repository layout](repository-layout.md) for which files compile per backend.
