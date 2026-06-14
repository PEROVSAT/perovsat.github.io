# Data Filtering and Analysis Thread

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The DFA thread processes raw payload data stored by the Payload thread, keeps the best measurements, and signals Communications when filtered data is ready for downlink.

## Boot conditions

Runs only when `DEPLOY_COMPLETE` is set and `OP_STATUS` is **NOMINAL** or **HIGH**.

## Responsibilities

- Read raw payload files from LittleFS
- Filter by face exposure and quality metrics
- In **NOMINAL**: keep top fraction of sweeps; in **HIGH**: run advanced IV analysis (details TBD)
- Write filtered results back to LittleFS and delete raw inputs
- Wake the Communications thread when new filtered data is available

## Wake pattern

Interval: 150–500 epochs. Exits early if no new raw data.

## Dependencies

- LittleFS
- System Health global flags
- Communications message queue

## Open questions

- Exact filtering metrics, IV curve computation, and compression before downlink are not finalized.
