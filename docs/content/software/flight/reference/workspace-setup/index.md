# Workspace Setup

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT flight software uses a **west** multi-repo workspace. Cloning `perovsat-app` and running `setup.sh` creates the full environment.

## What `setup.sh` does

- Installs system packages (macOS / Linux)
- Clones Zephyr and required modules per `west.yml`
- Clones driver repos listed in the manifest (skips private repos if access denied)
- Creates a Python venv and installs dependencies
- Wraps the app directory in a workspace folder for sibling repos
- Installs pre-commit hooks for PEROVSAT projects

Supported hosts: macOS and Linux (Windows via WSL).

## Key paths

| Path | Contents |
|------|----------|
| `perovsat-app/` | Application, dbuild, snippets |
| `zephyr/` | Zephyr RTOS source |
| `modules/` | HAL and third-party modules |
| `*-driver/` | Out-of-tree driver repos |

## Flashing hardware

For STM32 boards, install **STM32CubeProgrammer** (see `perovsat-app` README). Use `west flash` after `west dbuild`.

Tutorial walkthrough: [Getting Started](../../tutorials/getting-started.md).

## Open questions

- Documented layout when starting from `perovsat-workspace` vs cloning `perovsat-app` directly.
