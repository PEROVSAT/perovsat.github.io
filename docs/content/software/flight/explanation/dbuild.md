# DBuild

Updated: 7/10/26

While developing PEROVSAT flight software, we often need to switch between different run configurations depending on what parts we are trying to test or what hardware we have available to run with. However, managing all the different configuration files and DeviceTree overlay files manually is really tedious.

Instead, our DBuild (Device Build) system augments the `west build` command to automagically switch everything in compile-time based on a single YAML line. You simply name a mode, and DBuild resolves everything that you don't need to touch day-to-day

## Selection Flow

The primary interaction with DBuild is done via the `selections` section, which will look something like this:
```yaml
selections:
  IMU: public-mock
  MODEM: public-mock
  AMU: hardware
```

DBuild resolves the matching backend and snippet for that selection, and (after some verification), hands those off by running the normal `west build` with the added snippets and flags