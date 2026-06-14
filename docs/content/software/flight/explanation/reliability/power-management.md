# Power Management

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Power state drives most mission behavior. System Health reads the EPS and publishes `OP_STATUS`, which other threads consult each cycle.

## Operating statuses

| Status | Typical meaning | Software response (planned) |
|--------|-----------------|------------------------------|
| **SAFE** | Minimal power / fault recovery | Depower payload and modem; slow CPU clock |
| **LOW** | Limited battery | Sensors only; beacons; no DFA |
| **NOMINAL** | Normal operations | Full payload sweeps; filtered downlink |
| **HIGH** | Surplus power | Advanced DFA / IV analysis |

## Responsibilities by component

- **System Health** — reads EPS telemetry, sets `OP_STATUS`, adjusts clock speed, starts/stops threads
- **Payload** — powers or depowers payload devices via Zephyr PM and EPS commands
- **Communications** — keeps Eyestar off in **SAFE**; beacons in **LOW**
- **DFA** — runs only in **NOMINAL** / **HIGH**

Exact EPS thresholds that map to each status are not documented here yet.
