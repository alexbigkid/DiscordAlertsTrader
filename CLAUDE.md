# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DiscordAlertsTrader is a Python package that automates trading based on Discord alerts from analysts. It monitors Discord channels, parses trading signals (BTO/STC/STO/BTC), executes trades through multiple brokerage APIs, and tracks portfolio performance with real-time quotes.

## Core Architecture

### Main Components

- **GUI Entry Point**: `gui.py` - Main application entry with PySimpleGUIQt interface
- **Discord Integration**: `discord_bot.py` - Monitors Discord channels for trading alerts  
- **Message Processing**: `message_parser.py` - Parses trading signals from Discord messages
- **Trade Execution**: `alerts_trader.py` - Handles trade execution logic and position management
- **Portfolio Tracking**: `alerts_tracker.py` - Tracks analyst performance and portfolio state
- **Configuration**: `configurator.py` - Manages configuration from config.ini file

### Brokerage Integrations

Multiple brokerage APIs are supported in `brokerages/`:
- **TradeStation API**: `tradestation_api.py` with async/sync clients in `tradestation/client/`
- **E*Trade API**: `eTrade_api.py` 
- **Webull API**: `weBull_api.py` with detailed implementation in `webull/`
- **IBKR API**: `ibkr_api.py`
- **Schwab API**: `schwab_api.py`

### Market Data

Market data providers in `marketdata/`:
- **Polygon API**: `polygon.py`
- **ThetaData API**: `thetadata_api.py`

## Development Commands

This project uses [uv](https://docs.astral.sh/uv/) for fast Python package management.

### Installation and Setup
```bash
# Install project dependencies
make install
# Or: uv sync

# Install with debug dependency group (includes build tools)
make install-debug  
# Or: uv sync --group debug

# Copy example configuration
cp DiscordAlertsTrader/config_example.ini DiscordAlertsTrader/config.ini
# Or use: make setup
```

### Running the Application
```bash
# Launch the GUI application with uv
uv run DiscordAlertsTrader

# Or use the Makefile
make run

# Or run directly with uv
uv run python -m DiscordAlertsTrader.gui
```

### Testing
The project uses Python's built-in `unittest` framework.

```bash
# Run all tests
make test
# Or: uv run python -m unittest discover tests -v

# Run specific test categories
make test-alerts    # AlertsTracker/AlertsTrader tests
make test-parser    # Message parsing tests
make test-gui       # GUI component tests
make test-tda       # TDA API tests
make test-config    # Configuration tests
make test-calc      # ROI calculation tests
```

### Development Setup
```bash
# Install with debug dependency group (includes build tools, debugging utilities)
make install-debug
# Or: uv sync --group debug

# Code Quality
make lint           # Run ruff linter
make format         # Format code with ruff
make format-check   # Check formatting without changes

# Check dependency tree
make check-deps
# Or: uv tree

# Dependency Management (use uv commands directly):
uv add package_name       # Add new dependency
uv remove package_name    # Remove dependency
uv lock                   # Lock dependencies
uv sync                   # Sync dependencies

# Dependency Groups:
# - dev: ruff (linting/formatting), twine (publishing) - installed by default
# - debug: build tools, setuptools, wheel, pip-tools, pipdeptree

# Key dependencies for development:
# - PySimpleGUIQt for GUI
# - discord.py-self for Discord integration
# - pandas/numpy for data processing
# - matplotlib for visualization
```

### Building and Distribution
```bash
# Build package
make build
# Or: uv build

# Upload to PyPI (requires credentials)
make upload
# Or: uv run python -m twine upload dist/*
```

## Configuration System

The application uses INI-based configuration in `config_example.ini`:

- **[general]**: Core settings including `DO_BTO_TRADES`, `BROKERAGE` selection
- **[discord]**: Discord token, author subscriptions, channel IDs  
- **[TDA/eTrade/webull/IBKR]**: Brokerage-specific API credentials
- **[exits]**: Default exit strategies (PT/SL/TS configurations)

## Key Data Flows

1. **Alert Processing**: Discord bot receives message → message_parser extracts trade info → alerts_trader executes if conditions met
2. **Portfolio Management**: alerts_tracker maintains CSV-based portfolio state with real-time price updates  
3. **GUI Updates**: Background threads update GUI tables with trade status and portfolio performance

## Important Notes

- **Paper Trading**: Set `DO_BTO_TRADES = false` in config to disable live trading
- **Multi-brokerage**: Only one brokerage can be active at a time via `BROKERAGE` setting
- **Options Support**: Full options trading with strike/expiration parsing
- **Local OCO**: Implements One-Cancels-Other logic for brokerages that don't support it natively
- **Discord TOS**: Using user tokens violates Discord ToS (mentioned in README)

## Testing Strategy

Tests are located in `tests/` directory:
- Unit tests for core components (AlertsTracker, AlertsTrader, message parsing)
- Mock data in `tests/data/` for portfolio and quote testing
- No continuous integration configured - tests must be run manually