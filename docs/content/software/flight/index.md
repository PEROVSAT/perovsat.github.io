# Start Here: About the Docs

These docs follow the [Diátaxis](https://diataxis.fr) framework: documentation split by the reader's goal, not by subsystem. Each section below answers a different kind of question.

!!! note "TLDR"
    - Need to understand *why* something works the way it does? → [Explanation](explanation/architecture/index.md)
    - Need an exact syntax, field, or option? → [Reference](reference/index.md)
    - Know what you want, need the steps? → [How-to guides](how-to/index.md)
    - Looking to start writing code? → [Tutorials](tutorials/getting-started.md)

## Explanation

The *why*: design decisions, trade-offs, and how the pieces fit together conceptually. Read this to reason about the system rather than act on it right now. Start with [Flight Software Architecture](./explanation/architecture/index.md).

## Reference

The exact facts: file formats, CLI flags, Kconfig symbols, API signatures. Dry and structured, meant to be looked up rather than read start to finish. Browse the [Reference index](./reference/index.md).

## How-to guides

Recipes for a specific task, written for someone who already knows the concepts — register a device, implement a driver, wire it in.

## Tutorials

A guided, linear walkthrough for someone who has never touched this codebase before. Start with [Getting Started](./tutorials/getting-started.md).

---

## `Updated` Notes

In many documents, you will see an `Updated: date` line near the top. The date listed can actually reflect one of two things:

- When the document was updated to reflect changes
- When the document was reviewed to double-check consistency with the codebase

The second exists to give the readers confidence they are reading accurate information, and contributors should periodically review their articles to keep the date relatively recent

## For contributors

Before adding or editing a page, decide which of the four jobs above it's actually doing. Each has a different purpose and voice, and mixing them is the main way these docs get messy:

| Type | Purpose | Voice | Must NOT contain |
|---|---|---|---|
| **Tutorial** | Take a beginner from zero to a working result | Imperative, narrated, one linear path | Options/branches, unexplained jumps, design rationale |
| **How-to** | Let a competent dev accomplish a specific task | Imperative, terse, assumes context | Background explanation, exhaustive option listings |
| **Reference** | Describe the system accurately and completely | Dry, structured, consistent | Narrative, opinions, "why," step-by-step instructions |
| **Explanation** | Help the reader reason about the system | Discursive, can digress into trade-offs/history | Step-by-step instructions, exhaustive field-by-field listings |

!!! tip "DRY - Don't Repeat Yourself"
    Each piece of information should live ONCE, in the place where it makes the most sense. If you're tempted to restate it elsewhere, link to the primary source instead.

When in doubt, write less: a one-line link to the section that owns a fact is better than a duplicated paragraph that will drift out of sync.

Another good rule of thumb when writing `reference` documentation: large code blocks should only be used when the reference docs ARE the definition, which the code implements. Just repasting code into documentation is unnecessary duplication