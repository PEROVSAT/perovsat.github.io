# Code Style

Updated: 7/9/26

PEROVSAT software follows **Zephyr-aligned** conventions for embedded C/C++. Style is defined in repo-root config files and enforced by EditorConfig (editor settings), clang-format (C/C++ layout), and pre-commit hooks (checks on every commit).

Canonical configs live in `perovsat-app` (`.editorconfig`, `.clang-format`, `.pre-commit-config.yaml`). Driver repos carry matching copies.

## Conventions

### All text files

| Rule | Value |
|------|-------|
| Encoding | UTF-8 |
| Line endings | LF |
| Final newline | required |
| Trailing whitespace | stripped (except `.patch` / `.diff`) |
| Max line length | 100 (75 for `COMMIT_EDITMSG`) |

### Indentation by file type

| Files | Style | Width |
|-------|-------|-------|
| `.c`, `.h`, `.cpp`, `.hpp`, `.S`, `.ld` | tab | 8 |
| `.dts`, `.dtsi`, `.overlay`, `Kconfig*` | tab | 8 |
| `.py`, `.sh` | space | 4 |
| `.yml`, `.yaml`, `CMakeLists.txt`, `*.cmake` | space | 2 |

C/C++ layout beyond indentation (braces, macros, includes) is handled by clang-format, not EditorConfig.

## EditorConfig

**File:** `.editorconfig` (repo root)

[EditorConfig](https://editorconfig.org/) is supported by most editors and IDEs. It applies whitespace and indentation rules as you type or save. It does **not** reformat C/C++ structure — use clang-format for that.

## clang-format

**File:** `.clang-format` (repo root)

Based on **LLVM** style, aligned with Zephyr's `.clang-format` in the west workspace. Notable settings:

| Setting | Value |
|---------|-------|
| `ColumnLimit` | 100 |
| `BreakBeforeBraces` | Linux |
| `UseTab` | ForContinuationAndIndentation |
| `IndentWidth` | 8 |
| `InsertBraces` | true |
| `SortIncludes` | Never |
| `SpaceBeforeParens` | ControlStatementsExceptControlMacros |

Zephyr-specific macros (`FOR_EACH`, `SYS_DLIST_FOR_EACH_NODE`, `DT_INST_FOREACH_STATUS_OKAY`, etc.) and attribute macros (`__syscall`, `__packed`, …) are configured so loops and kernel code format correctly.

Format a file manually:

```bash
clang-format -i path/to/file.c
```

Format all staged C/C++ files (same as the pre-commit hook):

```bash
pre-commit run clang-format --files $(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(c|h|cpp|hpp)$')
```

## pre-commit

**File:** `.pre-commit-config.yaml` (repo root)

Hooks run automatically on `git commit` for any repo that has the config installed:

| Hook | Scope | Effect |
|------|-------|--------|
| `trailing-whitespace` | all staged files | removes trailing spaces |
| `end-of-file-fixer` | all staged files | ensures final newline |
| `clang-format` | `.c`, `.h`, `.cpp`, `.hpp` | reformats to `.clang-format` |

The clang-format hook uses [pre-commit/mirrors-clang-format](https://github.com/pre-commit/mirrors-clang-format) (clang-format v22.1.1) — no separate system install required.

When clang-format modifies staged files, the commit is **aborted**, so the user must re-add any changed files

See also [Contributing](../../tutorials/contributing.md) for the basic git workflow.
