# Unit Tests

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Unit tests validate driver-internal logic in isolation — parsing helpers, state machines, register math — without real hardware or buses.

## Driver repos

Each repo bootstrapped from `driver-template` includes `tests/unit/`:

- Platform: **`native_sim`** (runs on the host)
- Framework: Zephyr **ztest**
- Entry point: `tests/unit/src/main.c` (commented examples for internal helpers)

Run from a driver repo root inside the west workspace:

```bash
west twister -T tests/unit -p native_sim
```

Unit tests are the fastest feedback loop when implementing a new driver.
