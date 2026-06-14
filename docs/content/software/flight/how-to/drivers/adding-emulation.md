# Adding Emulation

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Hardware drivers include `*_emul.c` — an I2C (or bus) emulator that lets tests and SITL feed scripted or socket-driven traffic without physical chips.

## Backends

| Kconfig backend | Used for |
|-----------------|----------|
| `*_EMUL_BACKEND_INTEGRATION` | Driver repo integration tests (canned responses) |
| `*_EMUL_BACKEND_SITL` | Socket I/O to Basilisk / external simulator |

## Integration tests

In `tests/integration/prj.conf`:

```ini
CONFIG_EMUL=y
CONFIG_I2C_EMUL=y
CONFIG_PEROVSAT_MYDEVICE_EMUL=y
CONFIG_PEROVSAT_MYDEVICE_EMUL_BACKEND_INTEGRATION=y
```

Overlay wires the emulated device under `zephyr,i2c-emul-controller`.

## Application / dbuild (SITL mode)

In `perovsat-app`, emulation uses the **hardware** west project (not mock) plus snippet Kconfig:

```ini
CONFIG_EMUL=y
CONFIG_I2C_EMUL=y
CONFIG_PEROVSAT_MYDEVICE_EMUL=y
CONFIG_PEROVSAT_MYDEVICE_EMUL_BACKEND_SITL=y
```

Fill register handling and transfer logic in `*_emul.c` for both backends. See the generated README in `driver-template` for the full dbuild contract.

## Open questions

- Documented socket protocol between SITL backend and Basilisk.
