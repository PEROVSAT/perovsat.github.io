# Website Software

!!! warning "Under Construction"
    This page is a stub and still under construction. Details may be incomplete or change.

PEROVSAT publishes two related sites from the [`perovsat.github.io`](https://github.com/PEROVSAT/perovsat.github.io) repository:

| Site | Build | Audience |
|------|-------|----------|
| Main site | Static HTML at repo root | Public mission overview |
| Documentation | MkDocs Material under `docs/` | Technical docs (software, payload, electronics) |

Documentation source lives in `docs/content/`. MkDocs config is `docs/mkdocs.yml`.

## Local preview

From the `docs/` directory:

```bash
pip install -r requirements.txt
mkdocs serve
```

## Adding pages

See [How to Add Pages](how-to-add-pages.md).

## Open questions

- CI/deploy workflow (GitHub Actions vs manual) is not documented here yet.
