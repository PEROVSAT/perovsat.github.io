# AMU Driver Reference

Updated: 11/18/2026

## Scope
This reference describes the AMU driver's public API, configuration interfaces, supported backends, AMU protocol behavior, error handling, and hardware integration requirements

----------------------------

## Overview
- AMU driver serves the idea of generalizing the code to be more useable and testable between different data.
- The driver functionalitites:
    - Detect and probe the AMU
    - Read and write sweep configuration
    - Save configuration
    - Trigger a sweep
    - Read sweep metadata
    - Read current/voltage samples
    - Control the DAC
    - Change the AMU address
- The driver returns:
    - Hardware revision
    - Configuration values
    - Sweep metadata
    - Current/voltage samples - stored into `psp_sweep` protocol
-----------

## Public API
> This provides application level to device functionalities without accessing AMU registers directly
 

1. **Device access**    
    - `amu_from_dev()`: 

        - Converts a Zephyr `struct device` into an `amu_t *`
        - The Zephyr device must come from a valid AMU devicetree node.
        - The device should be checked with `device_is_ready()` first.  
    
    - `amu_probe()`  

        - Reads the AMU hardware revision
        - Stores the revision in `dev->hw_rev`.  

2. **Readiness**
    - `amu_wait_ready` :

        -  Checks device communication and command-busy state

    
    ``` c
    int amu_wait_ready(amu_t *dev, uint32_t timeout_ms, uint32_t poll_interval_ms)
    ```

    | Parameter | Description |  
    |-----------|-------------|
    | `dev` | Pointer to the AMU driver object |
    | `timeout_ms` | Maximum time to wait |
    | `poll_interval_ms` | Delay between readiness checks |

3. **Configuration**
    - `amu_get_config()`:
    
        - Reads the current configuration from the AMU
        - Write the result to an `amu_config_t`
    
    - `amu_set_config()`:

        - Writes an `amu_config_t` to the AMU
        - **DOES NOT** save the configuration

    - `amu_save_config()`:

        - Sends the AMU configuration-save command
        - Keep the change in configuration permanently
    
4. **Sweep operations**
    - `amu_trigger_sweep()`:
        - Waits for readiness
        - Sends the sweep trigger command
        - Waits for the sweep to finish
        - Returns **ONLY** after the AMU is ready again or an error occurs
    
    - `amu_get_sweep_meta()`:
        - Reads the metadata about the most recent sweep
        - Writes it into `psp_sweep_metadata`
    - `amu_get_sweep_iv()`:
        - Reads voltage (V) samples
        - Reads current (A) samples
        - Stores them in `psp_sweep_points`
    - `amu_get_sweep()`:
        - Combines `amu_get_sweep_meta()` and `amu_get_sweep_iv()`
        - Fills both `sweep->meta` and `sweep->iv`
        - Gets the full sample of a sweep including metadata and IV measurements.

5. **DAC operations**
    - `amu_dac_enable()`:
        - Accepts the requested DAC (Digital - Analog Converter) voltage as a `float`
        - Writes the voltage to the AMU
        - Enables the DAC
    - `amu_dac_disable()`
        - Disables the DAC
        - Does not require a voltage argument
        - Returns a negative error if the AMU cannot be reached or the command fails

----------

