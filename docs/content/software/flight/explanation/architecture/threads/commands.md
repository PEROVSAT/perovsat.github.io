# Commands Thread

Updated: 9/2/26

!!! warning "Under Construction"
    The full command set is unknown at this stage in development

The Commands thread processes ground commands received during Iridium sessions and coordinates acknowledgements back through Communications.

## Wake pattern

Event-driven: on message from the Communications thread.

## Dependencies

- Communications thread - Receive commands and send acknowledgements
- Other subsystems depending on which commands are implemented
