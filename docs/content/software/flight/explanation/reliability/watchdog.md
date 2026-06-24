# Thread Watchdog

!!! warning "Under Construction"
    This page describes a planned design and is not yet implemented. Details may change.

Every PEROVSAT application thread must periodically prove it is still making progress. System Health tracks these check-ins and flags any thread that goes silent for too long. This catches a thread that has hung, crashed, or stalled on a blocked resource — failures the MCU-wide watchdog cannot see, because the kernel itself is still running.

## Why not the Zephyr Task WDT

Zephyr's task watchdog (`task_wdt`) requires every thread to register and feed its own channel. That pushes responsibility onto each thread and means the watchdog only knows about threads that remember to sign up.

System Health already **starts** every application thread (children are defined with delay `K_FOREVER` and launched via `k_thread_start()`). Because it owns the start path, it also owns the roster — **starting a thread is the registration**. No thread has to register itself, and the monitored set can never drift from the set that was actually started.

This watchdog therefore uses plain kernel primitives — a message queue and the uptime clock — not `task_wdt`.

## How it works

A single shared message queue carries heartbeats. Each thread sends one at the top of its loop:

```c
struct health_heartbeat {
    uint8_t  thread_id;   /* index into the monitored-thread roster */
    uint32_t uptime_ms;   /* k_uptime_get_32() at send time */
};

/* In each worker loop. K_NO_WAIT so the watchdog never stalls the thread. */
health_checkin(MON_PAYLOAD);
```

A check-in is sent once per completed loop iteration, so it proves real forward progress rather than just that the thread is scheduled. It is sent with `K_NO_WAIT`: the watchdog must never block the thread it is watching.

System Health drains the queue every tick and records each thread's last-seen time.

## Detecting a stuck thread

Detection is stateless. On every tick, System Health compares the current time against each thread's last check-in:

```c
elapsed       = (uint32_t)(now - last_seen[t]);   /* wrap-safe subtraction */
missed_cycles = elapsed / epoch[t];               /* epoch[t] must be non-zero */

if (missed_cycles >= max_missed_cycles[t])
    report_fault(t);
```

| `missed_cycles` | State |
|-----------------|-------|
| 0 | Healthy — checked in this window |
| 1 | One window missed — tolerated as jitter |
| ≥ `max_missed_cycles` | Declared not working |

The comparison is always against the **current clock**, evaluated on System Health's own tick — never against the thread's next heartbeat. A dead thread sends nothing, so waiting for a next heartbeat would wait forever; only the advancing clock reveals the silence.

Because the threshold is counted in **epochs** (the thread's own expected interval) rather than in System Health loops, it stays correct no matter how often System Health polls. Comms with a 10-minute epoch and Payload with a 2-second epoch get the same tolerance semantics.

## Startup grace

When System Health starts a thread it arms `last_seen[t] = now` and marks the thread active. Two consequences:

- A thread that has not been started yet is not monitored, so it cannot raise a false fault.
- A freshly started thread gets a full window to complete its one-time init (device readiness, buffers) before its first check-in is due.

## Configuration

Each monitored thread carries its watchdog parameters in the central roster, alongside its priority and stack size:

| Field | Meaning |
|-------|---------|
| `epoch_ms` | Expected maximum interval between check-ins |
| `max_missed_cycles` | Missed windows tolerated before a fault |
| `startup_grace_ms` | Extra time allowed for the first check-in |

## Relation to the FDIR layers

This is the innermost, finest-grained [watchdog layer](perovsat-strategy.md#watchdog-layers): it isolates a single failed thread. It complements the coarser layers above it — the MCU internal watchdog resets the chip if System Health itself dies, and the EPS heartbeat power-cycles the OBC as a last resort.
