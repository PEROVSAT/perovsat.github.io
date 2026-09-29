# Testing

!!! warning "Incomplete"
    Still needs to be written

Ease of testing was one of the core requirements when determining the software design, and guided the decision both to use [Zephyr](zephyr/index.md) and justifies the added complexity of the [driver model](driver-model.md).

PEROVSAT testing is split into three layers, which this document will overview.

## Unit Testing

Since the [flight software architecture](architecture/index.md) decomposes well into individual drivers 

