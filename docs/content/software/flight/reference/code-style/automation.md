# Code Style Automation

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT driver repos use **[pre-commit](https://pre-commit.com/)** hooks defined in `.pre-commit-config.yaml`.

## Hooks

| Hook | Tool | Applies to |
|------|------|------------|
| `trailing-whitespace` | pre-commit-hooks | all text files |
| `end-of-file-fixer` | pre-commit-hooks | all text files |
| `clang-format` | mirrors-clang-format v22 | `*.c`, `*.h`, C++ |

## Setup

After cloning a repo (or running `perovsat-app/setup.sh`), install hooks once:

```bash
pre-commit install
```

Run manually on all files:

```bash
pre-commit run --all-files
```

CI may run the same checks on pull requests (exact pipeline TBD).
