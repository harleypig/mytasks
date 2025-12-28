#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || (cd "$SCRIPT_DIR/.." && pwd))"

# Load local env (perl lib, PATH, etc.)
source "$PROJECT_ROOT/scripts/local-env.sh"

# Ensure project libs are first
export PERL5LIB="$PROJECT_ROOT/lib:$PROJECT_ROOT/t/lib:${PERL5LIB:-}"

# Use nproc - 1 when possible
JOBS=$(nproc)
if [ "$JOBS" -gt 1 ]; then
  JOBS=$((JOBS - 1))
fi

exec prove -l -j"$JOBS" "$@"
