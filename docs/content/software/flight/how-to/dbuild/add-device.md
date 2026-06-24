# Add a Device to DBuild

This guide walks through adding a new logical device to the dbuild system

For background on how DBuild itself works, see [The DBuild Command](../reference/dbuild.md)

## Overview

Adding a device requires four areas of work:

1. Register driver west projects in `west.yml`
2. Create snippets for each supported mode
3. Add the device to the `devices` section of `dbuild.yml`
4. Add the current mode selection to the `selections` section of `dbuild.yml`

The MPU6050 IMU is the reference implementation today. Use the `snippets/mpu6050-*` directories and IMU device in `dbuild.yml` as examples

## 1. Add west driver projects

Each mode needs a Zephyr module for the driver in `west.yml`:

```yaml
- name: mpu6050-driver
  remote: origin
  revision: main
```

The name in this should match what the git repository for the driver is named

To make sure it is included in the current workspace, you can rerun `setup.sh`

## 2. Create snippets

Create one directory per mode under `snippets/`. Naming convention: `<device>-<mode>`

A snippet requires three parts:
1. A `snippet.yml` file that declares the name and other parts of the snippet
2. A `.conf` configuration file that enables the device
3. 1 or more `.overlay` DeviceTree files

For a `public-mock`, `library-mock`, or `simulation` mode, only a single overlay file is required to set up the emulated communication bus. However, for `hardware` mode, you need to set up an individual `.overlay` file for each supported board under the `boards/` subdirectory

## 3. Add Device to `devices` Section of `dbuild.yml`
The format for this section is as follows:
```yaml
devices:
    LOGICAL_NAME:
        west_project: <repository_name>
        modes:
            public-mock:
                snippet: <snippet_name_from_step_2>
                kconfig_backend: CONFIG_PEROVSAT_<LOGICAL_NAME>_BACKEND_<MODE>
            library-mock:
                ...
```

!!! note "Hardware mode"
    In defining the hardware mode, be sure to include `board_overlay_required: true` to tell DBuild to enforce there being a matching `.overlay` file for the board being compiled

## 4. Select an Initial Run Mode
In the `selections` section of `dbuild.yml`, add a line like the following:
```yaml
selections:
     <LOGICAL_NAME_YOU_ADDED_IN_STEP_3>: public-mock
```

## 5. Verify the configuration

Preview the resolved build command:

```bash
west dbuild -b nucleo_u575zi_q --dry-run
```

You should see your new snippet(s) in the `-S` list and no validation errors. If it looks correct, attempt a build:

```bash
west dbuild -b nucleo_u575zi_q
```
