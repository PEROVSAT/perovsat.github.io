# Contributing to Flight Software

The PEROVSAT flight software lives across many GitHub repositories, shown below, but the process of making contributions to them is largely the same.

## Repositories

| Repository | Purpose |
|------------|---------|
| `perovsat-app` | Application threads, dbuild system, and setup scripting |
| `driver-template` | Bootstrap new out-of-tree Zephyr drivers |
| `*-driver` | Individual device drivers |
| `*-lib` | Libraries for use in certain device drivers for NDA hardware |
| `perovsat.github.io` | The website you're on, for both documentation and publicity |


## Basic workflow

1. Clone `perovsat-app` and run `./setup.sh` (see [Getting Started](getting-started.md)).
2. Use `git switch main` to get to the main branch of a repository
3. Use `git switch -c new-branch-name` to create a branch for a feature you are working on
4. Use `git add` and `git commit -m "short description of changes"` to make changes
5. Once all changes are done, double check that everything still can be run without errors
6. Use `git push -u origin your-branch-name` to publish your branch to GitHub
7. On GitHub, make a Pull Request (PR) for your branch, and add a description of what you did
8. Other team members can review your code. Once they merge it, do `git switch main` and `git pull` to see your code on the main branch, where you can now work on another feature

If you want to learn more about git, [MIT's Missing Semester](https://missing.csail.mit.edu/2026/version-control/) is a great resource. AI can also be very useful if you get stuck.

!!! note "Git Commit Errors"
    Due to the use of clang-format in a pre-commit script (see [Code Style](../reference/code_style.md#pre-commit) for details), your commits may "fail" to go through. This is expected, and just a result of git seeing that clang-format changed some files that were going to be committed. You can readd any files that were changed, and try to commit again.
