# SITL Testing

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Software-in-the-loop (SITL) tests build firmware with the hardware driver's **SITL emulator backend**, which speaks to an external simulator (Basilisk) over sockets instead of using canned ztest responses.

## Driver repos

Hardware drivers scaffold `tests/sitl/`:

- Platform: `qemu_cortex_m3`
- Marked **`build_only: true`** in CI (Basilisk is not available in automated pipelines)
- Backend: `CONFIG_*_EMUL_BACKEND_SITL`

In `perovsat-app`, emulation mode uses the same SITL backend via a dbuild snippet (hardware west project + `CONFIG_EMUL=y`).

```bash
west twister -T tests/sitl -p qemu_cortex_m3 --build-only
```

Full end-to-end SITL workflow documentation lives with the [Simulation Software](../../../simulation/index.md) repo.

## Open questions

- Standard procedure for launching Basilisk alongside QEMU locally.
