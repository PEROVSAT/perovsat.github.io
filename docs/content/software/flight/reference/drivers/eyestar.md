# Eyestar Driver Reference
## Design
The Eyestar interface is a bit unique with the way that it does uplink and downlink. We have an NDA with Nearspace Launch, and we have decided not to risk sharing too many details at the API level. The only thing to note is that all communication is done at once, so an application calling the driver has to be prepared for both TX and RX.

## Internal Data
None

## API
`const struct device *dev` is implied at the start of all driver API methods

### Transfer Result Struct
```c
typedef enum tx_status_e {
    FAIL_MODEM,
    FAIL_NETWORK,
    SENT
} tx_status_t;


struct eyestar_transfer_result {
    bool uplinks_pending;
    size_t bytes_received;
    tx_status_t tx_status;
};
```

### `int eyestar_transfer(const uint8_t *tx_buf, size_t tx_len, uint8_t *rx_buf, struct eyestar_transfer_result *res)`
#### Description
Does a transfer session with the Eyestar to send TX (if tx_len > 0) and download RX if available
#### Parameters
`const uint8_t *tx_buf` - The packet to be transmitted
`size_t tx_len` - Length of packet to send. If `tx_len` <= 0, then no packet will be sent
`uint8_t *rx_buf` - Buffer to place the uplinked packet into. Must be at least 205 bytes
`struct eyestar_transfer_result *res` - Result of transfer operations. Struct shown above
#### Return
An integer status code
| Code | Status Category | Description |
| --- | --- | --- |
| 0 | Success | Transfer completed successfully|
| -EIO | Error | Communication Error |
| -ENODEV| Error | Could not find device |
| -1 | Error | Additional Errors TBD |

