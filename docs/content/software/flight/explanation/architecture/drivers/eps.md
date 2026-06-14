# EPS Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The EPS (Electrical Power System) driver wraps Nearspace Launch's EPS over Zephyr UART. It is the primary interface for power telemetry, payload power switching, and the mission heartbeat watchdog.

## Planned API surface

- Read battery / power state (feeds `OP_STATUS` in System Health)
- Send periodic heartbeat (required to avoid EPS power-cycling the OBC)
- Control power to subsystems (Eyestar, payload devices)

## Implementation status

Detailed EPS command mapping is not yet documented publicly. The driver repo is private under the NSL NDA.

## Open questions

- Full command set, parsing format, and error handling need to be filled in once EPS documentation is available.
