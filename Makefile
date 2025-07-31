# DiscordAlertsTrader Makefile

.PHONY: help install install_debug setup run test test_v clean build upload lint lint_fix format
.SILENT: clean

# Default target
help:
	@echo "Available commands:"
	@echo "  install      - Install project dependencies with uv"
	@echo "  install_debug - Install project with debug dependency group using uv"
	@echo "  setup        - Setup configuration file from example"
	@echo "  run          - Run the DiscordAlertsTrader GUI application"
	@echo "  test         - Run all tests (quiet mode)"
	@echo "  test_v       - Run all tests (verbose mode)"
	@echo "  test_alerts  - Run AlertsTracker and AlertsTrader tests"
	@echo "  test_parser  - Run message parser tests"
	@echo "  test_gui     - Run GUI tests"
	@echo "  lint         - Run ruff linter"
	@echo "  lint_fix     - Run ruff linter with automatic fixes"
	@echo "  format       - Format code with ruff"
	@echo "  clean        - Clean build artifacts and cache files"
	@echo "  build        - Build distribution packages"
	@echo "  upload       - Upload package to PyPI (requires credentials)"

# Installation with uv
install:
	uv sync

install_debug:
	uv sync --group debug

# Setup
setup:
	@if [ ! -f "DiscordAlertsTrader/config.ini" ]; then \
		cp DiscordAlertsTrader/config_example.ini DiscordAlertsTrader/config.ini; \
		echo "Created config.ini from example. Please edit with your settings."; \
	else \
		echo "config.ini already exists."; \
	fi

# Run application
run:
	uv run DiscordAlertsTrader

# Testing
test:
	@PYTHONWARNINGS=ignore::FutureWarning uv run python -m unittest discover tests

test_v:
	uv run python -m unittest discover tests -v

test_alerts:
	uv run python -m unittest tests.test_AlertsTracker tests.test_AlertsTrader tests.test_AlertsTrader_exits -v

test_parser:
	uv run python -m unittest tests.test_msg_parsed -v

test_gui:
	uv run python -m unittest tests.test_gui_generator tests.test_discord_bot -v

test_tda:
	uv run python -m unittest tests.test_TDA -v

test_config:
	uv run python -m unittest tests.test_configurator -v

test_calc:
	uv run python -m unittest tests.test_calc_rois -v

# Cleanup
clean:
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	rm -rf build/
	rm -rf dist/

# Build and distribution
build: clean
	uv build

upload: build
	uv run python -m twine upload dist/*

# Code quality
lint:
	uv run ruff check .

lint_fix:
	uv run ruff check . --fix

format:
	uv run ruff format .

# Create data directory if it doesn't exist
create-data-dir:
	@mkdir -p data/live_quotes


# Show package info
info:
	@echo "Package: DiscordAlertsTrader"
	@echo "Version: $(shell uv run python -c "import DiscordAlertsTrader; print(DiscordAlertsTrader.__version__)")"
	@echo "Python: $(shell uv run python --version)"
	@echo "UV: $(shell uv --version)"
