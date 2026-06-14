# AMU Driver

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The AMU (Analog Measurement Unit) driver talks to Aerospace-provided hardware over I2C. It presents multiple physical AMUs as a single logical multi-channel device so application code can sweep channels uniformly.

## Role in the mission

During payload operations in **NOMINAL** or **HIGH** power, the Payload thread sweeps AMU channels when sun exposure is sufficient, storing raw sweep data for later filtering.

## Implementation status

The hardware driver repo is private under the Aerospace NDA. A public mock driver may exist for development without hardware.

## Open questions

- Channel count, sweep timing, and calibration details are not documented here yet.
