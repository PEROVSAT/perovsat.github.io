# AMU Driver Reference
## Design
Instead of multiple instances, the AMU driver is a single instance with internal logical device selection. This is to account for the possibility of multi-channel AMUs in the future, so that our driver model stays the exact same. All driver API functions should take a parameter for which device to do the operation on.

## API
These are the public functions to interact with the AMU devices


