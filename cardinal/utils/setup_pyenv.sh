#!/usr/bin/env bash

ENV_DIR="local-py-env"

# List packages here
PACKAGES=(
    numpy
    matplotlib
    PyQt5
)

# Setup environment
if [ ! -d "$ENV_DIR" ]; then
  echo "Creating virtual environment in '$ENV_DIR'..."
  python3 -m venv "$ENV_DIR"

  echo "Installing packages..."
  "$ENV_DIR/bin/pip3" install "${PACKAGES[@]}"
else
  echo "Using existing virtual environment '$ENV_DIR'."
fi

# Activate environment
# (only works when you run: source setup_env.sh)
source "$ENV_DIR/bin/activate"

echo "Environment active: $(python -c 'import sys; print(sys.executable)')"
