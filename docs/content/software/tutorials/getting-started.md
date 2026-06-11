# Getting started with PEROVSAT software

This tutorial walks you through setting up a local development environment for the PEROVSAT flight software repository.

## Prerequisites

- Git
- Python 3.10 or newer
- A Unix-like shell (macOS, Linux, or WSL on Windows)

## Clone the repository

```bash
git clone https://github.com/perovsat/<repository>.git
cd <repository>
```

## Install dependencies

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run the test suite

```bash
pytest
```

If all tests pass, your environment is ready. See the **How-to guides**, **Reference**, and **Explanation** sections for task-specific workflows and deeper background.

## Next steps

- Browse the [how-to guides](../how-to/index.md) for common development tasks
- Consult the [reference](../reference/index.md) for API and configuration details
