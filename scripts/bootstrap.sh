#!/usr/bin/env bash

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOCAL_LIB_DIR="$PROJECT_ROOT/.local-lib"

echo "Using local::lib at: $LOCAL_LIB_DIR"

# Ensure local::lib exists and generate env snippet
perl -Mlocal::lib="$LOCAL_LIB_DIR" -e1

# Capture the env exports into scripts/local-env.sh (overwrites each time)
perl -Mlocal::lib="$LOCAL_LIB_DIR" \
  -e 'print local::lib->environment_vars' \
  > "$PROJECT_ROOT/scripts/local-env.sh"

# Load the env for this script's execution (so cpanm installs into local-lib)
# Note: This does NOT affect your shell - you must source scripts/local-env.sh manually
# shellcheck disable=SC1090
source "$PROJECT_ROOT/scripts/local-env.sh"

# Install cpanm if the user doesn't have it
if ! command -v cpanm >/dev/null 2>&1; then
  echo "Installing App::cpanminus locally..."
  curl -L https://cpanmin.us | perl - App::cpanminus
fi

# Install project deps
if [ -f "$PROJECT_ROOT/cpanfile" ]; then
  cpanm --installdeps "$PROJECT_ROOT"
elif [ -f "$PROJECT_ROOT/Makefile.PL" ] || [ -f "$PROJECT_ROOT/Build.PL" ]; then
  cpanm .
else
  echo "No cpanfile / Makefile.PL / Build.PL found; nothing to install."
fi

echo "Bootstrap complete."
echo ""
echo "To activate the local::lib environment, run:"
echo "  source scripts/local-env.sh"
echo ""
echo "You must source scripts/local-env.sh each time you work on this project."
