.PHONY: dev dev-site dev-docs build preview install

VENV := .venv
PYTHON := $(VENV)/bin/python
PIP := $(VENV)/bin/pip

install:
	cd site && npm install
	@test -d $(VENV) || python3 -m venv $(VENV)
	$(PIP) install -r docs/requirements.txt

dev-site:
	cd site && npm run dev

dev-docs:
	cd docs && ../$(PYTHON) -m mkdocs serve

dev:
	@echo "Starting Astro (http://localhost:4321/) and MkDocs (http://127.0.0.1:8000/)"
	@trap 'kill 0' INT TERM; \
	(cd site && npm run dev) & \
	(cd docs && ../$(PYTHON) -m mkdocs serve) & \
	wait

build:
	cd site && npm run build
	cd docs && ../$(PYTHON) -m mkdocs build -d ../site/dist/documentation

preview: build
	cd site && npm run preview
