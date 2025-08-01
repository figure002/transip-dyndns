.PHONY: lint
lint: flake8 mypy

.PHONY: flake8
flake8:
	@echo "Checking Python code..."
	@flake8 .

.PHONY: mypy
mypy:
	@echo "Checking types..."
	@mypy .
