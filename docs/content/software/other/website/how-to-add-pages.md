# How to Add Documentation Pages

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

## 1. Create the Markdown file

Add a `.md` file under `docs/content/`, following the existing section layout:

```text
docs/content/software/flight/how-to/my-guide.md
```

Use `# Title` as the first line. Admonitions use Material syntax:

```markdown
!!! warning "Under Construction"
    Optional note.
```

## 2. Register in navigation

Add the page to `docs/mkdocs.yml` under the appropriate `nav:` entry so it appears in the sidebar.

## 3. Preview locally

```bash
cd docs
mkdocs serve
```

Open the URL printed in the terminal and verify links and formatting.

## 4. Deploy

Push to the branch that triggers GitHub Pages deployment for the docs site (exact branch/workflow TBD).

## Conventions

- **`index.md`** — section overview with links to child pages
- **Tutorials** — learning-oriented walkthroughs
- **How-to** — task-focused recipes
- **Reference** — precise technical descriptions
- **Explanation** — background and architecture

## Open questions

- Whether nav generation should stay manual in `mkdocs.yml` or move to a plugin/auto-index pattern.
