# (c) Hyperion Labs 2025

THIS_MAKEFILE_DIR:=$(dir $(realpath $(firstword $(MAKEFILE_LIST))))
SRC_DIR = src
TEST_DIR = tests

COVERAGE_DIR = $(THIS_MAKEFILE_DIR)htmlcov

.PHONY: all clean typecheck lint test coverage config run requirements

all: typecheck lint coverage
	@echo "\nPYTHONPATH=$(PYTHONPATH)\n"

clean:
	rm -rf .coverage .mypy_cache .pytest_cache .ruff_cache $(COVERAGE_DIR)
	rm -rf `find $(SRC_DIR) -name __pycache__`
	rm -rf `find $(TEST_DIR) -name __pycache__`

typecheck:
	MYPYPATH=$(SRC_DIR) mypy \
		--check-untyped-defs --namespace-packages --explicit-package-bases \
		--package mypkg.api \
		--package tests

lint:
	ruff check $(SRC_DIR)/$(PYTHON_ROOT_PKG) $(TEST_DIR)

test:
	pytest -v \
		--asyncio-mode=strict \
		$(TEST_DIR)

coverage:
	pytest --cov=$(SRC_DIR)/$(PYTHON_ROOT_PKG) \
		--cov-report=term-missing --cov-report=html:$(COVERAGE_DIR) \
		--asyncio-mode=strict \
		$(TEST_DIR)

config:
	python -m mypkg.api.config

run:
	uvicorn mypkg.api.main:app --reload \
		--env-file $(THIS_MAKEFILE_DIR).env

requirements:
	@ echo "Requires pip-tools to be installed: pip install pip-tools"
	rm -rf requirements/base.txt && pip-compile --strip-extras --output-file=requirements/base.txt requirements/base.in
	rm -rf requirements/dev.txt  && pip-compile --strip-extras --output-file=requirements/dev.txt requirements/dev.in
	pip-sync requirements/base.txt requirements/dev.txt

integration:
	curl -i -X GET \
		http://localhost:8000/info

smoke: config
