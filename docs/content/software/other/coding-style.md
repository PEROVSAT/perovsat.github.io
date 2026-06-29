# Coding Style

This page explains the coding style PEROVSAT uses for its C and C++ code: what
that style is, how to confirm it for yourself, and what you need to do to follow
it. If you have ever wondered why the tabs are so wide or whether a brace goes on
the same line or the next one, this is the page to read.

## Summary

PEROVSAT C/C++ code follows the **Zephyr coding style**, which is the **Linux
kernel coding style** with a few small adjustments. If you already know how Linux
kernel code looks, you already know how our code should look.

We did not define a style of our own. We adopted Zephyr's, because all of our
flight code is built on top of Zephyr, and keeping one consistent style across
the whole tree is far easier to read than switching conventions between the RTOS
and our own files.

## Confirming the style

You do not have to take this on trust. The evidence sits in the config files at
the root of every C/C++ repo (`amu-driver`, `perovsat-app`, `mpu6050-driver`).
The key settings in `.clang-format` are:

| Setting | Value | What it indicates |
|---------|-------|-------------------|
| `IndentWidth` | `8` | Eight columns per indent level, the classic kernel width |
| `UseTab` | `ForContinuationAndIndentation` | Real tab characters, not spaces |
| `BreakBeforeBraces` | `Linux` | The named "Linux" brace preset in clang-format |
| `ColumnLimit` | `100` | The modern kernel and Zephyr line limit |
| `IndentCaseLabels` | `false` | `case` labels line up under `switch`, kernel style |

`BreakBeforeBraces: Linux` is the clearest signal. It is a named preset in
clang-format that exists specifically to reproduce Linux kernel brace placement.
Beyond that, the comment header in our `.clang-format` reads "PerovSat
clang-format style (Zephyr-aligned)" and points at `zephyr/.clang-format`, and
the `.editorconfig` header notes that it is "Aligned with Zephyr conventions".
Zephyr's own contributor documentation states that Zephyr follows the Linux
kernel coding style. The chain is therefore straightforward: PEROVSAT follows
Zephyr, and Zephyr follows Linux.

To verify this directly, compare our `.clang-format` against `zephyr/.clang-format`
in the west workspace. They are intentionally almost identical; Zephyr only lists
a few extra `ForEachMacros` for subsystems we do not use.

## The rules in practice

You rarely have to apply these by hand, since clang-format does it for you (see
[Applying the style](#applying-the-style) below). Still, it helps to know what
the formatter is aiming for so its output does not catch you off guard.

### Indentation

- Indent with **hard tabs**, and treat a tab as **8 columns**.
- Continuation lines (a statement wrapped onto the next line) are indented an
  extra 8 columns.
- If code drifts so far to the right that 8-wide tabs become painful, take that
  as a signal that the function is doing too much. Extract logic into a helper
  rather than fighting the indentation.

### Braces

This is the rule most often gotten wrong, so it is worth stating plainly:

- **Functions** get their opening brace on its **own line**.
- **Everything else** (`if`, `for`, `while`, `switch`, `struct`, and so on) gets
  the opening brace on the **same line**, after a single space.

```c
/* function: brace drops to the next line */
static int sample_fetch(const struct device *dev, enum sensor_channel channel)
{
	struct mpu6050_data *data = dev->data;

	/* control statement: brace stays on the same line */
	if (channel != SENSOR_CHAN_ALL) {
		return -ENOTSUP;
	}

	return 0;
}
```

Braces are also mandatory. `InsertBraces: true` means clang-format adds braces to
a one-line `if` even if you leave them off, so there is no point writing
brace-less bodies.

### Line length

Lines stop at **100 columns**. Both `.clang-format` and `.editorconfig` enforce
this. Commit message lines are kept shorter, at 75 columns, which matches normal
Git convention.

### switch statements

`case` labels are **not** indented past the `switch`. They sit at the same level,
and the body of each case is indented one tab in:

```c
switch (device_type) {
case DEVICE_TYPE_MPU6500:
	tmp_val = (tmp_val * 1000 / 333870) + 21000000;
	break;

case DEVICE_TYPE_MPU6050:
default:
	tmp_val = (tmp_val / 340) + 36000000;
	break;
}
```

### Includes

We do not sort includes alphabetically (`SortIncludes: Never`), but clang-format
does group them by category, and the order is:

1. Local headers in quotes, like `"mpu6050.h"`
2. Standard C library headers, like `<errno.h>`
3. Zephyr headers, like `<zephyr/device.h>`
4. Everything else

Put your own header first, and let the formatter handle the spacing between
groups.

### File hygiene

- Files end with a single newline (`InsertNewlineAtEOF: true`).
- No trailing whitespace on any line.
- Encoding is UTF-8 and line endings are LF (Unix), never CRLF.

### Indentation per file type

The C rules above are for actual C/C++ source. Other file types in the repo use
their own conventions, all set in `.editorconfig`:

| File type | Indent | Width |
|-----------|--------|-------|
| `*.c`, `*.h`, `*.cpp`, `*.hpp`, `*.S`, `*.ld` | tab | 8 |
| Devicetree (`*.dts`, `*.dtsi`, `*.overlay`) | tab | 8 |
| `Kconfig*` | tab | 8 |
| Python (`*.py`) | space | 4 |
| Shell (`*.sh`) | space | 4 |
| YAML (`*.yml`, `*.yaml`) | space | 2 |
| CMake (`CMakeLists.txt`, `*.cmake`) | space | 2 |

In short, C-family and hardware description files use tabs, while scripting and
build-config files use spaces. Do not reformat a Python helper with tabs just
because the C files use them.

## The files that enforce the style

Three files do the work. They live at the root of each C/C++ repo and are copied
from the `driver-template`, so every repo gets the same setup.

- **`.clang-format`** is the formatter config. It is the source of truth for
  spacing, braces, and wrapping.
- **`.editorconfig`** tells your editor about tabs, line endings, charset, and
  per-filetype indent so files look right while you type, before you ever run
  clang-format.
- **`.pre-commit-config.yaml`** wires up the automatic checks (see below).

## Applying the style

You should almost never format code by hand. Let the tooling do it.

### One-time setup

Pre-commit hooks are installed for you when you run `perovsat-app/setup.sh`. If
you cloned a repo on its own, install the hooks once from the repo root:

```bash
pip install pre-commit
pre-commit install
```

Most editors pick up `.editorconfig` automatically. For clang-format, install
the matching version (we pin **v22** through the pre-commit mirror) and turn on
"format on save" if your editor supports it.

### Formatting your changes

To format everything before a commit:

```bash
pre-commit run --all-files
```

To format a single file directly with clang-format:

```bash
clang-format -i path/to/file.c
```

The `-i` flag edits the file in place.

### What the hooks check

The pre-commit config runs three hooks on every commit:

| Hook | What it does |
|------|--------------|
| `trailing-whitespace` | strips trailing spaces from all text files |
| `end-of-file-fixer` | makes sure files end with exactly one newline |
| `clang-format` | reformats C and C++ to match `.clang-format` |

If a hook changes a file, the commit is stopped so you can review the change and
stage it. Run the commit again once you have staged it.

## Writing readable code

clang-format handles layout, but it cannot make code clear on its own. The kernel
style assumes a few habits that the formatter cannot enforce:

- Keep functions short enough to read on a single screen.
- Treat the 8-wide indentation as a warning sign. Deep nesting usually means a
  function should be split up.
- Write comments that explain *why*, not *what*. The example files in
  `mpu6050-driver` are a good reference for tone.

## Scope and open questions

This page covers C and C++, where almost all of our embedded code lives. A few
points are still being settled:

- Naming conventions (functions, structs, macros) beyond what clang-format
  touches are not formally documented yet. For now, match the surrounding
  Zephyr-style code: lower_snake_case for functions and variables, UPPER_CASE
  for macros and enum values.
- The exact CI pipeline that runs these checks on pull requests is not yet
  finalized. Locally, the pre-commit hooks are what to rely on.

When you add a new repo, copy `.clang-format`, `.editorconfig`, and
`.pre-commit-config.yaml` from an existing one so it inherits the same style.
