# Radiation Events

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Radiation in LEO can affect the OBC and payload electronics. PEROVSAT focuses mitigation on effects that matter for a short ISS-orbit mission with expected shielding.

## Cumulative effects (likely negligible for us)

| Effect | Concern for PEROVSAT |
|--------|---------------------|
| **Total Ionizing Dose (TID)** | Low expected dose over mission life with shielding |
| **Displacement Damage (DD)** | Some PV degradation possible; MOS logic in the OBC is relatively insensitive |

These are monitored at the mission level but are not primary software FDIR drivers.

## Single Event Effects (SEEs)

These drive software and hardware FDIR design:

| Effect | Symptom | Mitigation direction |
|--------|---------|---------------------|
| **SET** (transient) | Glitches on signal paths | Watchdogs, reset |
| **SEU** (bit flip) | Corrupted SRAM / state | Boot from flash, ECC, variable duplication, memory scrubbing |
| **SEL** (latch-up) | Destructive high current | Hardware LCL / overcurrent protection on power rails |

## Open questions

- SD card / NOR storage FDIR details are still being defined (see design-and-planning `exploration/sd.md`).
