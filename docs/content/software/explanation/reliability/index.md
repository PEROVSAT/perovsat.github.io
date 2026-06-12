# Reliability and the space environment

Satellites in **low Earth orbit (LEO)** cannot be power-cycled from the lab bench on demand. Radiation, power glitches, and software faults must be detected, contained, and recovered onboard. PEROVSAT flight software is designed around **fault detection, isolation, and recovery (FDIR)** — not only happy-path operation.

## Why this matters for FSW

- **Radiation** can flip bits (**SEU**) or cause destructive latch-up (**SEL**); software must assume memory and state can corrupt.
- **Watchdogs** at multiple layers (EPS, hardware, software) ensure a hung system eventually resets rather than draining the battery silently.
- **Safe-mode booting** limits what runs after an unexpected reset until health checks pass.

This section explains the threat model and our design responses. Implementation procedures belong in how-to guides.

## Concepts at a glance

| Term | Meaning |
|------|---------|
| **FDIR** | Detect faults, isolate affected subsystems, recover to a known-good state |
| **SEE** | Single Event Effect — umbrella for radiation-induced hardware effects |
| **SEU** | Bit flip in memory; may corrupt data or code paths |
| **SEL** | Latch-up that can overdraw current and damage hardware |
| **Watchdog** | Timer that resets the system if software fails to check in |
| **Safe mode** | Reduced operational profile after fault or boot under uncertainty |

## Deeper reading

- [Space environment](space-environment.md) — radiation effects in plain language
- [FDIR](fdir.md) — detection, isolation, recovery, and watchdog layers
- [Safe mode](safe-mode.md) — triggers, behavior, and return to nominal ops
