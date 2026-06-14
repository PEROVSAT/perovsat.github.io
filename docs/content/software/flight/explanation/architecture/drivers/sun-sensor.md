# Sun Sensor Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Sun sensors supply sun angle or exposure data used by the Payload thread (to gate AMU sweeps) and by DFA (for face exposure calculations).

## Expected interface

Sun sensors will likely appear as UART or custom bus devices with devicetree aliases (for example `sun-sensor-left`, `sun-sensor-right`) so application code stays board-agnostic.

## Implementation status

Specific hardware models, driver repos, and dbuild entries are not finalized in the application yet.

## Open questions

- Which sun sensor hardware is flying, how many channels/faces exist, and whether mock drivers are planned.
