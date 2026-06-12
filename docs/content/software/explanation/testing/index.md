# Testing flight software

Embedded flight software is hard to test in a browser tab. PEROVSAT uses a spectrum from **pure simulation** on a laptop to **real hardware** exercised with scripted or injected inputs. The goal is the same at every level: catch regressions before orbit, where fixes are expensive.

## The spectrum

| Approach | What runs | Typical use |
|----------|-----------|-------------|
| **SITL** | Flight stack on a host (e.g. Zephyr `native_sim`) with mock or simulated I/O | Fast iteration, logic and thread interaction |
| **HIL** | Real OBC and peripherals with simulated or replayed environment data | Driver integration, timing, hardware quirks |

SITL is not a substitute for everything HIL covers — timing, electrical behavior, and driver edge cases still need hardware. Explanation docs describe *what* each mode is; how-tos will cover *how to run* them.

## Deeper reading

- [Native simulation](../zephyr/native-sim.md) — `native_sim` and mock drivers (Zephyr-focused)
- [Hardware-in-the-loop](hil.md) — HIL setup and role in the project
