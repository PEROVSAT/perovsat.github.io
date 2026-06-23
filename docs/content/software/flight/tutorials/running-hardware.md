# Running PEROVSAT FSW on Hardware
Ensure you have completed the [Getting Started](./getting-started.md) tutorial

This tutorial will cover how to use the `hardware` mode for drivers, and flashing the software onto an on-board computer

## Required Software
If you are using a NUCLEO development board, you will need the STM32CubeProgrammer software from STMicroelectronics.
1. Go to the [download page](https://www.st.com/en/development-tools/stm32cubeprog.html)
2. Select the 2.22.0 release for your machine
!!! note
    Even if you have an ARM-based Mac, just get the normal Mac version. The ARM one is broken.
3. Log in or download as guest and get the email link
4. Unzip the download and run the setup app
5. Step through all steps with default settings

## Flashing to Hardware
### 1. Modify DBuild
For any hardware that you have connected to your development board that you would like to run, switch the mode under the `selections` tab of `dbuild.yml`

### 2. Build Software
Use the `west dbuild` command to compile the code for your board. If the driver lacks support for it right now, dbuild will throw an error.

Replace `nucleo_u575zi_q` in the command below with the board you have plugged into your computer. Like in the getting started tutorial, ensure you are in the Python virtual environment before you run this.

```bash
west dbuild -b nucleo_u575zi_q
```

### 3. Flash to Board
```bash
west flash
```

### 4. View Log Output
On Mac, you can use the `screen` utility to read log data output from the development board. To start, look at what devices are available for reading:
```bash
ls /dev/
```
It is likely something like `cu.usbmodem`

You can then connect to it with the following:
```bash
screen /dev/cu.usbmodem 115200
```

You can exit the application using control+a, k, y

The 115200 is the Baud rate of the connection. It may vary with different boards, so if you see no output that should be the first troubleshooting step.
