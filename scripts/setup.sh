#!/usr/bin/env bash
set -euo pipefail

PY=python3.14
if ! command -v "$PY" >/dev/null 2>&1; then
  echo "Error: $PY not found. Install Python 3.14." >&2
  exit 1
fi

# Create venv
if [ -d ".venv" ]; then
  echo ".venv already exists — skipping venv creation"
else
  "$PY" -m venv .venv
  echo "Created .venv using $PY"
fi

# Activate
# shellcheck disable=SC1091
source .venv/bin/activate

# Upgrade pip and install requirements
python -m pip install --upgrade pip setuptools wheel
if [ -f requirements.txt ]; then
  python -m pip install -r requirements.txt
else
  echo "No requirements.txt found — nothing to install"
fi

echo
echo "Virtual environment created and dependencies installed."
echo "Activate it with: source .venv/bin/activate"