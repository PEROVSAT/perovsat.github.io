# Reliability and FDIR

Updated: 9/2/26

Given that PEROVSAT is an expensive scientific mission, we want to take as many steps as we can to make it reliabile. The primary failure points to mitigate are **radiation events**. When cosmic rays hit the spacecraft, it can (among other possibilites) flip bits in our flight computer's memory.

Fault Detection, Isolation, and Recovery (FDIR) refers to how the spacecraft finds and handles unexpected states in computer hardware. This section of documentation will go over PEROVSAT's strategy

## Watchdogs

Intuitively, a watchdog is the idea that someone can say "I'm still here," (also known as 'petting'), and if they stop saying that, then we can assume something has gone wrong.

The most common implmentation of this is a hardware watchdog, in which software pets a specialized piece of hardware, and if it doesn't receive them it can restart the software.

## Memory Scrubbing

Some microcontrollers have error correcting code (ECC) memory, which has extra memory and control hardware to use [Hamming Codes](https://en.wikipedia.org/wiki/Hamming_code) to find and fix single bitflips without the software needing to even know it happened. Unfortunately, ECC memory is uncommon and more expensive, and our onboard computer doesn't have it, so we need other ways to detect problems

Memory scrubbing is a very similar idea to ECC memory, but is done entirely in software, and can only detect rather than fix. Essentially, for any large section of static data (like binary code), we can compute something like a [checksum](https://en.wikipedia.org/wiki/Checksum) for the section. Then, in the background we dedicate some compute power to constantly go through memory, recalculate the checksums, and compare it to the originals. If it ever finds a mismatch, it can trigger some sort of mitigation strategy in the software.

## Triple Redundancy

Triple redundancy is fairly simple, but very effective. For things in memory that aren't static (meaning memory scrubbing can't help), we simply have to duplicate it three times and add a small voting process each time we use it:

```
----------------
| 42 | 42 | 42 |
----------------
       | Bitflip
       v
----------------
| 42 | 43 | 42 |
----------------
       |  2/3 addresses agree on 42:
       |  Bitflip is overwritten
       v
----------------
| 42 | 42 | 42 |
----------------
```

If (in the extraordinarily rare case) all three disagree, you would want to do something like reset to a default value

## Power Management

Outside of radiation, another important aspect of keeping the spacecraft alive is careful power management.

PEROVSAT uses four power statuses, which is then published as a global variable to all threads.

| Status | Behavior |
|--------|----------|
| **SAFE**      | Depower all sensors, only wait for commands |
| **LOW**       | Basic payload sensors only; send occasional beacons |
| **NOMINAL**   | Full payload sweeps; filtered downlink |
| **HIGH**      | Advanced analysis and higher payload reading frequency |
