# Communications Thread

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

Communications handles application-level interaction with the Eyestar modem (Iridium). It downlinks filtered data, sends beacons, and forwards received ground commands to the Commands thread.

## Boot conditions

Starts when `DEPLOY_COMPLETE` is set.

## Responsibilities

| Status | Behavior (planned) |
|--------|-------------------|
| **SAFE** | Ensure Eyestar is powered down |
| **LOW** | Send beacon on interval; forward RX to Commands (DFA is off, so no filtered downlink) |
| **NOMINAL** / **HIGH** | Transmit filtered DFA data; forward RX to Commands |

## Wake pattern

Event-driven when DFA signals new data, with a long interval fallback (500+ epochs) for beacons.

## Dependencies

- Eyestar driver (UART-based Iridium interface)
- EPS driver (Eyestar power control)
- LittleFS (filtered data)
- Commands thread (command forwarding and ACKs)
