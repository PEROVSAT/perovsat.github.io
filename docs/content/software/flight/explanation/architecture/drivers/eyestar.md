# Eyestar Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The Eyestar driver sits on Zephyr UART and abstracts Iridium communications for the Communications thread. It also coordinates with the EPS driver for modem power.

## Planned API surface

Rough target:

- `eyestar_send(data, len)` — queue or transmit a downlink buffer
- `eyestar_receive(buffer)` — read uplink data from a ground pass

Power on/off is expected to go through EPS rather than directly from application code.

## Implementation status

Protocol details are still being gathered. The driver repo is private under the NSL NDA.

## Open questions

- Session lifecycle, framing, and error recovery are not documented here yet.
