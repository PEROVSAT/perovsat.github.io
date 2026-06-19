# Eyestar Driver Reference
## Design
This driver does not use the simple transmit and receive model that most radio libraries use, since doing so would make it too difficult for the application code to properly manage power usage. Instead, the driver API is designed to still expose the workings of the Iridium Short Burst Data (SBD) process.


!!! warning "On pause"
    Until we can get more information on Iridium connectivity and Eyestar details, this document is on hold


## Internal Data
- `char *tx_buf` - A ring buffer to store outgoing packets. Likely switch for a Zephyr ring buffer type
- `char *rx_buf` - A ring buffer to store downloaded command packets. Likely switch for a Zephyr ring buffer type

## API
### int init_eyestar()
#### Description
Any required hardware or communication bus initialization goes here
#### Parameters
TODO: Identify configuration parameters
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Eyestar initialized successfully |
| -EIO | Error | Communication Error |
| -ENODEV| Error | Could not find device |
| -1 | Error | Additional Errors TBD |


### int queue_packet(char *pkt, uint16_t pkt_len)
#### Description
Adds a packet to be transmitted in the next session
#### Parameters
`char *pkt` - An SRAM buffer to pass the packet into the Eyestar
`pkt_len` - Length of the packet buffer
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Packet was queued successfully |
| -1 | Error | Buffer out of space |
| -2 | Error | Additional Errors TBD |


### int init_sbd_session(void)
#### Description
Primary function for this driver, and power optimization is done here. Details are TBD with how it can be optimized, but theoretically it could control power to the Eyestar to avoid much idling power, it could track satellite availability and only run a session when available, it should handle loading its internally queued packets in,
Needs to:
- Manage power status of the Eyestar (turn on at the start of the function, turn off at the end)
- Track Iridium connectivity to minimize power usage during send
- Load internally queued packets for transmit
- Download Commands from the Iridium network and place in different internal buffer
- Set value for how many additional receive commands are waiting in the network
#### Parameters
`void` - No parameters
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| 1 | Success | TX packets sent, RX was downloaded |
| 0 | Success | TX packets sent, no RX received |
| -1 | Error | Timeout, unable to find an Iridium Satellite |


### int get_received_packet(char *buf, uint16_t buflen, uint16_t *bytes_written)
#### Description
Get the next downloaded command packet from the internal driver queue. Return value structure built so it can be looped
Also may need to initialize sessions to do more downloading, if the driver ran out of space in its ring buffer to download all waiting commands
#### Parameters
`char *buf` - Buffer to load command packet into
`uint16_t buflen` - Size of that buffer, used to ensure there is ample space to load
`uint16_t *bytes_written` - Used as a return value as the length of the packet written to `buf`
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| +x | Success | X is the amount of packets remaining to pull |
| 0 | Success | No additional packets to load |
| -1 | Error | There are no packets to pull |
| -2 | Error | Additional errors TBD |
