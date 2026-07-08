# Getting Started with PEROVSAT Flight Software

This tutorial will guide you through setting up the PEROVSAT Zephyr workspace, and running the flight software

## Prerequisites

- Git (command line utility)
- A Unix-like shell (macOS, Linux, or WSL on Windows)

## Setup
!!! note
    All commands shown here are for Unix shell systems. This will not work in Windows powershell/command line

### 1. Clone the application repository

```bash
git clone git@github.com:PEROVSAT/perovsat-app.git
cd perovsat-app
```

### 2. Run setup script

```bash
./setup.sh
```

!!! note "GitHub Permissions"
    You can safely ignore any errors to do with lacking access to a GitHub repo. Some drivers that the script clones are private, and require specific access. If you require access, please reach out to an admin of the PEROVSAT GitHub organization

If you encounter any errors outside of GitHub permissions, or encounter later errors that say you're missing some package, please let somebody know so we can add them to the setup script or fix issues with it.

After running this script, the directory that perovsat-app was in will have been renamed to perovsat-workspace, and will contain perovsat-app. Move back into the application code:
```bash
cd perovsat-app
```

### 3. Configuration

Run configuration is done by modifying the `dbuild.yml` file. To begin, set all the available devices in the `selections` section to be `public-mock`

!!! warning "Do not use simulation or hardware mode"
    The `simulation` and `hardware` modes require additional configuration to get running, and will have other tutorials made for setup

### 4. Build and Run
We use the custom `dbuild` command to compile our code. Usually, building and running are separate steps, but since this tutorial uses a virtual QEMU device, they are done both at once using the `-t run` flag

```bash
west dbuild -b qemu_cortex_m3 -t run
```

Use control+c to stop the program

!!! note "Troubleshooting: west command not found"
    If your shell was not able to find west, you likely are not in the Python virtual environment that the setup script made. It is in the `perovsat-workspace` directory, so if you're in the `perovsat-app` you can reactivate it with `source ../.venv/bin/activate`

## Next steps
- Try running the software on [hardware](./running-hardware.md)
- Learn how the `dbuild` system works in [DBuild overview](../explanation/dbuild.md)
- Browse the [how-to guides](../how-to/index.md) for common development tasks
- Consult the [reference](../reference/index.md) for API and configuration details
