# Contributing to Flight Software

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT flight software lives across several GitHub repositories. Most day-to-day work happens in `perovsat-app` and individual driver repos; the workspace repo ties them together.

## Repositories

| Repository | Purpose |
|------------|---------|
| `perovsat-workspace` | West manifest, `setup.sh`, and onboarding scripts |
| `perovsat-app` | Application threads, dbuild config, snippets, and board overlays |
| `driver-template` | Bootstrap new out-of-tree Zephyr drivers |
| `*-driver` / `*-mock-driver` | Individual device drivers (some are private under NDA) |
| `design-and-planning` | Architecture notes and design docs (public) |

## Access and teams

Some drivers are private. GitHub teams gate access:

- **Flight Software** — write access to the workspace and application repos
- **NSL NDA** — EPS and Eyestar driver repos
- **Aerospace NDA** — AMU driver repo

If you need access to a private repo, contact a PEROVSAT GitHub org admin after signing the relevant NDA.

## Basic workflow

1. Clone `perovsat-app` and run `./setup.sh` (see [Getting Started](getting-started.md)).
2. Create a feature branch from `main`.
3. Make changes, build with `west dbuild`, and run relevant tests.
4. Open a pull request against the target repository.

Code style hooks (`clang-format`, trailing whitespace) are installed by `setup.sh` via pre-commit. See [Code Style Automation](../reference/code-style/automation.md).

## Open questions

- Exact PR review requirements and CI expectations are not documented here yet.
