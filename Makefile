.PHONY: dev dev-site dev-docs build preview install

install:
	cd site && npm install
	pip install -r docs/requirements.txt

dev-site:
	cd site && npm run dev

dev-docs:
	cd docs && mkdocs serve

dev:
	@echo "Starting Astro (http://localhost:4321/) and MkDocs (http://127.0.0.1:8000/)"
	@trap 'kill 0' INT TERM; \
	(cd site && npm run dev) & \
	(cd docs && mkdocs serve) & \
	wait

build:
	cd site && npm run build
	cd docs && mkdocs build -d ../site/dist/documentation

preview: build
	cd site && npm run preview
