# DiscordAlertsTrader Makefile

.PHONY: help install install-debug setup run test clean build upload lint format format-check

# Default target
help:
	@echo "Available commands:"
	@echo "  install      - Install project dependencies with uv"
	@echo "  install-debug - Install project with debug dependency group using uv"
	@echo "  setup        - Setup configuration file from example"
	@echo "  run          - Run the DiscordAlertsTrader GUI application"
	@echo "  test         - Run all tests"
	@echo "  test-alerts  - Run AlertsTracker and AlertsTrader tests"
	@echo "  test-parser  - Run message parser tests"
	@echo "  test-gui     - Run GUI tests"
	@echo "  lint         - Run ruff linter"
	@echo "  format       - Format code with ruff"
	@echo "  format-check - Check code formatting without making changes"
	@echo "  clean        - Clean build artifacts and cache files"
	@echo "  build        - Build distribution packages"
	@echo "  upload       - Upload package to PyPI (requires credentials)"

# Installation with uv
install:
	uv sync

install-debug:
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
	uv run python -m unittest discover tests -v

test-alerts:
	uv run python -m unittest tests.test_AlertsTracker tests.test_AlertsTrader tests.test_AlertsTrader_exits -v

test-parser:
	uv run python -m unittest tests.test_msg_parsed -v

test-gui:
	uv run python -m unittest tests.test_gui_generator tests.test_discord_bot -v

test-tda:
	uv run python -m unittest tests.test_TDA -v

test-config:
	uv run python -m unittest tests.test_configurator -v

test-calc:
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

format:
	uv run ruff format .

format-check:
	uv run ruff format --check .

# Create data directory if it doesn't exist
create-data-dir:
	@mkdir -p data/live_quotes

# Check dependencies
check-deps:
	uv tree

# Show package info
info:
	@echo "Package: DiscordAlertsTrader"
	@echo "Version: $(shell uv run python -c "import DiscordAlertsTrader; print(DiscordAlertsTrader.__version__)")"
	@echo "Python: $(shell uv run python --version)"
	@echo "UV: $(shell uv --version)"