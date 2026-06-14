# Zephyr Threads

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT application threads are standard Zephyr threads created with `K_THREAD_DEFINE` or started dynamically via `k_thread_start()`.

## Interval-driven loop

```c
while (1) {
    /* work */
    k_msleep(INTERVAL_MS);
}
```

## Event-driven loop

```c
while (1) {
    if (k_msgq_get(&queue, &msg, K_FOREVER) == 0) {
        /* handle msg */
    }
}
```

## Mixed wake (timeout OR event)

```c
int ret = k_msgq_get(&queue, &msg, K_MSEC(5000));
if (ret == 0) { /* event */ }
else if (ret == -EAGAIN) { /* timeout */ }
```

## PEROVSAT-specific pattern

Child threads that should not run at boot are defined with delay `K_FOREVER`. System Health calls `k_thread_start(tid)` when global flags allow.

See [Application Threads](../architecture/threads/index.md) for mission thread roles.

Official reference: [Zephyr Threads](https://docs.zephyrproject.org/latest/kernel/services/threads/index.html).
