# Flight software architecture

PEROVSAT flight software is organized around a small set of **threads**, each responsible for a slice of onboard behavior. Threads communicate through message queues and shared state (global flags), and the whole system is gated by **operational status** (`OP_STATUS`) so power and risk can be managed as the mission progresses.

This is project-specific design documentation. It explains *our* structure and naming — the vocabulary you will see in thread design docs and in code reviews.

## Why it is structured this way

- **Separation of concerns** — sensing, filtering, communications, and health monitoring evolve on different schedules and failure domains.
- **Deterministic scheduling** — interval-driven and event-driven **wake models** keep behavior predictable on a resource-constrained RTOS.
- **Mission phases** — deploy, safe mode, and nominal operations change what the satellite is allowed to do; `OP_STATUS` encodes that centrally.

## Threads at a glance

| Thread | Role |
|--------|------|
| **System Health** | Monitors EPS, watchdogs, and overall system viability |
| **Payload** | Interfaces with the perovskite payload (AMU) and related acquisition |
| **Data Filtering and Analysis (DFA)** | Processes and stores sensor and payload data |
| **Communications** | Downlink (beacon, SBD) and uplink handling |
| **Commands** | Parses and dispatches ground commands |

Other cross-cutting concepts: **epoch** (time base), **beacon** (periodic telemetry), **`DEPLOY_COMPLETE`** and **global flags** (shared mission state).

## Deeper reading

- [Threads](threads.md) — responsibilities, ownership, and interactions between threads
- [Operational status](op-status.md) — SAFE, LOW, NOMINAL, HIGH and what each permits
- [Data flow](data-flow.md) — from sensor read to onboard storage to downlink
- [Global flags](global-flags.md) — shared state, deploy semantics, and coordination without heavy IPC
