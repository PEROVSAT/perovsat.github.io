# Measureing IV Curves
## Device Identification

Red ID numbers shall be defined as the upper end of the cells

Primary number used for identification is the first 1-2 digits at the upper left corner of the cell

The surface with the ID number shall be the front side of the devices

The surface with 6 gold contanct pads chall be the back side of the devices

While having the pv cell face up:

- pixel A shall be at the upper right corner of the front side
- pixel B shall be at the center right side ...
- pixel C shall be at the lower right corner ...
- pixel D shall be at the lower left corner ...
- pixel E shall be at the center left side ...
- pixel F shall be at the upper left corner ...

Identifying summer 2026 "chenchao jar" pervoskite batch (observed 05-28-26):

- Device #2: prominent dent on the back side next to pixel F
- Device #8: smudge on the back side on pixel C, **pixel 8B is dead**
- Device #9: small scratch on the front side on top of pixel C, **pixel 9A and 9C are dead**
- Device #10: small scratch on the back side glass layer next to pixel B
- Device #11: prominent scratch on the front side on top of pixel B, **pixel 11B is dead**
  
## Measuring Condition & Configuration
Environment:

- Distance from solar simulator light from cell: 10cm (tip: put the pv cell on top of the glass container it came in)
- Room light ON
- Solar simulator is turned on for at least a 30 seconds before measurement
- The jig lies parallel and directly under the solar simulator light

In NI LabVIEW 2026:

- Sweep Direction: Descending
- Source Mode: Voltage
- Vmin: 0
- Vmax: 1.2 (should be tweeked for reference cells so that Isc shows)
- Number of points: ~60
- VISA Resource Name: GPIBO::24
  
## Testing Jig Mounting
The testing jig is a sandwich:

- top layer: metal cnc'd plate
- middle layer: perovskite cell
- bottom layer: pogo PCB

Pay special attention to mounting orientation as it is critical for correct pixel identifications and measurement.

Directions:

1. Put metal plate caved side up and in vertical position (2 columns x 3 rows of hole)
2. Before anything, give the cell a quick wipe. Place perovskite cell face down/metal plate side up into the plate in the same vertical poistion. From this viewpoint, the top-left corner is the backside of pixel A.
3. Place pogo PCB so that the pogo pins are in contact with contact pads of the pv cell. The pixel A label on the PCB should match pixel A of the pv cell.
4. Screw in corners in diagonal order, not too tight or loose.

##2-Wire and 4-Wire on NI LabVIEW/Keithley 24XX
Perovskite cells can be swept in either 2-wire or 4-wire arrangement. 2-wire arrangement combines sense wires (I) and force wires (V) into single positive and negative wires. This arrangement is best for quick perovskite testing with no components between to add resistance. On the Keithley, only the HI/LO on the right side is used. 4-wire arrangement isolates the sense and force wires, creating four +I/-I/+V/-V wires. This arrangement is going to be implemented onto the AMU/perovsktie circuit. Because the sense wire carry no current, it eliminates all lead and series resistance for highly accurate measurements. On the Keithley, both HI/LO is used.

Checking Measurement Mode:

1. Open NI MAX
2. Check measurement mode by going on NI MAX > My System > Devices and Interfaces > NI GPIB-USB-HS "GPIB0" > Instrument 0
3. Right click Instrument 0, in the "Send String" field, write `:SYST:RSEN?` and press "Query"
4. If String Received = `0`, 2-wire mode; if `1`, 4-wire mode

Switching Measurement Mode:

1. Open NI LabVIEW 2026 Q1 (32-bit)
2. Select IVMeasurement_Keithley2400
3. Press `ctrl+E` to open block diagram
4. On the left side there should be a "Configure the measurement and output" note. Below is VISA write block with pink block containing `:SYST:RSEN:OFF`
5. If OFF = 2-wire, if ON = 4-wire. Edit as needed and save

On new installation or version, you might need recreate block diagram:
1. 

## Best Practices

