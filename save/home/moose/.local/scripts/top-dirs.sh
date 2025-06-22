#!/usr/bin/env bash
# top-dirs – show the 5 largest directories (default /)
set -euo pipefail

need() { command -v "$1" >/dev/null || { echo "Need $1"; exit 127; }; }
for c in du sort head; do need "$c"; done

TARGET="${1:-/}"
DEPTH="${2:-5}"
[[ -d $TARGET ]] || { echo "Not a directory: $TARGET"; exit 1; }

sudo du -xh "$TARGET" --max-depth=1 2>/dev/null | sort -h -r | head -n $DEPTH
