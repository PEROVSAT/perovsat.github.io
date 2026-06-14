# Hardware Testing

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Hardware testing runs firmware on physical boards or flight-like avionics with real buses and devices connected.

## Typical workflow

1. Set the target device to `hardware` in `dbuild_devices.conf`.
2. Ensure board overlays exist for your dev board in the relevant snippet.
3. Build and flash:

```bash
west dbuild -b nucleo_u575zi_q
west flash
```

4. Use shell logging, logic analyzer, or mission-specific checklists to verify behavior.

## Platforms

- **STM32 Nucleo-U575ZI-Q** — common PEROVSAT dev board today
- **Flight OBC** — final integration target (TBD)

macOS developers cannot use `native_sim`; flashing a board is the primary on-target option. See [Getting Started](../../tutorials/getting-started.md).

## Open questions

- Documented supported board list and lab bring-up checklists are not written yet.
