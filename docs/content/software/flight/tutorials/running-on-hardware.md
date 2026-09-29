# Running PEROVSAT FSW on Hardware

!!! warning "Out of date"
    We're now using the Raspberry Pi Pico 2, which has a different hardware setup

Ensure you have completed the [Getting Started](./getting-started.md) tutorial

This tutorial will cover how to use the `hardware` mode for drivers, and flashing the software onto the Raspberry Pi Pico 2 on-board computer

## Flashing to Hardware
### 1. Ensure DBuild configuration
This tutorial is only to cover running the flight software on hardware, not using actual devices with it.

- Any devices should be in a `-mock` mode
- Console should be in `usb`, this will allow us to observe the software as it runs
- Flash should be in `pico2`

### 2. Build Software
Use the `west dbuild` command to compile the code for your board

Like in the getting started tutorial, ensure you are in the Python virtual environment before you run this.

```bash
west dbuild -b rpi_pico2
```

### 3. Flash to Board

The Pico2 has a separate mode for flashing new software than running the current one. To get it into this mode you should:

- Unplug the Pico2 from any power
- Press and hold the white `BOOTSEL` button
- While still holding, plug the USB into your computer. Continue holding until it shows up in your file explorer/finder

If done correctly, you should see it as a mountable device, and the following command should upload the flight software build:
```bash
west flash
```

After this runs, the device will no longer show up as mountable, as it's now running the flight software

### 4. View Log Output

You can use the `screen` utility to montior output from the board

First, identify the terminal it's exposing. If you put it in USB console mode, it should be listed somewhere within `/dev/`. On Mac, it is a `/dev/cu.usbmodem`

You can then connect to it with the following:
```bash
screen /dev/REPLACE_WITH_YOURS 115200
```

You can exit the application using `control+a`, `k`, `y`. The 115200 is the Baud rate of the connection
