# Commands Thread

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

The Commands thread processes ground commands received during Iridium sessions and coordinates acknowledgements back through Communications.

## Boot conditions

Starts when `DEPLOY_COMPLETE` is set.

## Responsibilities

- Parse and execute ground commands (command set TBD)
- Send completion ACKs to Communications when appropriate

## Wake pattern

Event-driven: blocks on messages from the Communications thread.

## Dependencies

- Communications thread (command input and ACK output)
- Other subsystems depending on which commands are implemented

## Open questions

- The full command dictionary, parsing format, and security constraints are not defined yet.
