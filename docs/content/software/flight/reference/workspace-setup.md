# Workspace Setup

Updated: 7/9/26

PEROVSAT flight software uses a **west** multi-repo workspace. Cloning `perovsat-app` and running `setup.sh` creates the full environment.

## `setup.sh` Features

- Installs system packages (macOS / Linux)
- Clones Zephyr and required modules per `west.yml`
- Clones driver repos listed in the manifest (skips private repos if access denied)
- Creates a Python venv and installs dependencies
- Wraps the app directory in a workspace folder for sibling repos
- Installs pre-commit hooks for PEROVSAT projects

Supported hosts: macOS and Linux (Windows via WSL).

## Links

Tutorial walkthrough: [Getting Started](../../tutorials/getting-started.md).