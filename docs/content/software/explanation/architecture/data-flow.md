# Data flow

!!! warning "Under Construction"
    This article is not written yet.

Topics to cover when this page is written:

- End-to-end path: **sensor / payload read → DFA → storage → downlink**
- Onboard storage (**LittleFS** or equivalent) and what gets persisted vs streamed
- Beacon contents vs on-demand or command-driven downlink
- Filtering, aggregation, and analysis responsibilities in the DFA thread
- Data formats at boundaries (driver → application → comms)
