# System Health Thread

Updated: 9/2/26

System health oversees the flight software by:

- Managing a thread watchdog
- Memory scrubbing for Single Event Upsets
- Petting EPS watchdog
- Setting power state
    - May adjust microcontroller clock speed to save power in **LOW** or **SAFE**

For more detailed on reliability strategies, see [explanation/reliability/index.md]

## Wake pattern

Interval: 1-5 epochs

## Dependencies

- EPS driver - battery info in, heartbeat out
- Ingress watchdog updates and telemetry from all threads
