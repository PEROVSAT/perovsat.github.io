# mission-website

The website for PEROVSAT's mission and documentation.

This repository is split into two projects:

- **`site/`** — Astro-based main website (home, about, team, etc.)
- **`docs/`** — MkDocs-based technical documentation

## Local development

Install dependencies once (creates a Python virtualenv in `.venv/` and installs Node packages):

```bash
make install
```

MkDocs dependencies are listed in `docs/requirements.txt` (Material theme, which includes MkDocs itself). A root `requirements.txt` re-exports that file for convenience.

Run the main site only (http://localhost:4321/):

```bash
make dev-site
```

Run the documentation only (http://127.0.0.1:8000/):

```bash
make dev-docs
```

Run both in parallel:

```bash
make dev
```

Build and preview the combined production output (main site + docs at `/documentation/`):

```bash
make preview
```

## Deployment

Pushes to `main` build both projects and deploy to GitHub Pages:

- Main site: https://perovsat.github.io/
- Documentation: https://perovsat.github.io/documentation/
