# PEROVSAT Watchdogs

Updated: 9/2/26

See the main [reliability](index.md) document for a definition of watchdogs. This document covers the ones PEROVSAT uses

## System Health Watchdog

[System Health](../architecture/threads/system-health.md) is our Zephyr thread that handles reliability within software. It hosts a software-level watchdog that requires petting from all other active threads. Being in software, we are also enabled to create more advanced mitigation strategies.

### Example

Imagine that System Health doesn't receieve a pet from Payload in its allotted time. System Health assumes something has gone wrong in Payload and proceeds with mitigation

In mitigation, we may be able to first try using Zephyr's API to restart the thread. After that, if we still receive no pet from Payload, we may try a deeper restart, like a full software reset or power cycle

## EPS Hardware Watchdog

Nearspace Launch's Electrical Power System (EPS) has a configurable hardware watchdog on it. Given that the piece is professionally done and has flight heritige, it is reliable to use as a backup watchdog. If something goes wrong with the System Health such that it fails in a way that disables its own watchdog, then we don't pet the EPS and the whole flight software can be power cycled
