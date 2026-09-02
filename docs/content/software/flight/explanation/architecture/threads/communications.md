# Communications Thread

Updated: 9/2/26

Communications handles application-level interaction with the EyestarS4 radio, including:

- Downlinking filtered payload data
- Sending beacons and telemetry
- Receiving and forwarding uplinked commands to the [Commands](commands.md) thread

## Power Status Behavior

| Status | Behavior |
|--------|-------------------|
| **SAFE** | Occasionally check for received commands (period TBD) |
| **LOW** | Send beacons and check for receieved commands (period TBD) |
| **NOMINAL** / **HIGH** | Full operation |

## Wake pattern

Interval: 500+ epochs

## Dependencies

- Eyestar driver
- LittleFS - Fetch filtered data
- Commands thread - Forwarding uplinked commands, sending completed acknowledgements
