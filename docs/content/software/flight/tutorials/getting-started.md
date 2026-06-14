# Getting Started with PEROVSAT Flight Software

!!! warning "Under Construction"
    This page is still under construction. Steps are accurate for the current workspace but may change.

This tutorial will guide you through setting up the PEROVSAT Zephyr workspace

## Prerequisites

- Git (command line utility)
- A Unix-like shell (macOS, Linux, or WSL on Windows)

## Setup

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

Additionally, this will wrap the application repository in a workspace directory so that we can clone the other repositories without interfering with wherever you installed it.

### 3. Configure run settings

In the perovsat-app repository, you should see a file named `dbuild_devices.conf`. This is used in a custom `dbuild` command extension to the `west` build manager, and enables us to rapidly switch devices between hardware and mock data.

For a first run, it is recommended to set all the values in `dbuild_devices.conf` to `=mock`, instead of requiring a hardware setup

### 4. Build and run
#### Linux (or Windows Subsystem for Linux)
Zephyr supports a `native_sim` build option that can run the whole flight software on your machine. To build, you can run the following:
```bash
west dbuild -b native_sim -t run
```

#### MacOS
While we may add emulation support with QEMU in the future, MacOS currently does not support `native_sim`.

You'll need to run the code on an actual supported board. This example uses the Nucleo-U575ZI-Q, but you should change this to whatever you have available. The command will notify you if we lack support for it. (TODO: link to currently supported boards)
```bash
west dbuild -b nucleo_u575zi_q
west flash
```

## Next steps
- Learn how the `dbuild` system works in [The DBuild Command](../reference/dbuild.md)
- Browse the [how-to guides](../how-to/index.md) for common development tasks
- Consult the [reference](../reference/index.md) for API and configuration details
