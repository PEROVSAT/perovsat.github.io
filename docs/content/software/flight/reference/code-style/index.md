# Code Style

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT C/C++ repos follow a shared formatting baseline so reviews focus on logic, not whitespace.

## Rules

- **clang-format** — `.clang-format` at repo root (from `driver-template`)
- **No trailing whitespace** — stripped on commit
- **Files end with newline**

Editor defaults: `.editorconfig` in driver repos.

## Automation

Hooks are installed by `perovsat-app/setup.sh` for PEROVSAT west projects. See [Automation](automation.md).

## Open questions

- Whether additional naming or documentation conventions beyond clang-format should be documented here.
