# Application Threads

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT uses a fixed set of Zephyr threads. **System Health** acts as the coordinator: it reads EPS power state, maintains global flags (`DEPLOY_COMPLETE`, `OP_STATUS`), and starts child threads when conditions allow.

Threads that depend on deployment or power level are created with `K_FOREVER` delay and started later via `k_thread_start()`.

## Thread overview

| Thread | Starts when | Primary role |
|--------|-------------|--------------|
| [System Health](system-health.md) | Always (boot) | Heartbeats, global flags, thread lifecycle |
| [Payload](payload.md) | Always | Sensor reads and raw data storage |
| [Data Filtering & Analysis](data-filtering-and-analysis.md) | Deploy complete + nominal/high power | Filter payload data, wake comms |
| [Communications](communications.md) | Deploy complete | Iridium/Eyestar sessions, beacons, downlink |
| [Commands](commands.md) | Deploy complete | Process ground commands |

Wake patterns mix **intervals** (sleep for N epochs) and **events** (message queues with optional timeouts). See [Zephyr Threads](../../zephyr/threads.md) for the underlying patterns.
