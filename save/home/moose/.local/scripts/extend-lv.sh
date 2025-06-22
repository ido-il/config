#!/usr/bin/env bash
# extend-lv – extend an LVM logical volume and its filesystem
set -euo pipefail

usage() {
cat <<EOF
Usage: $(basename "$0") <LV_PATH> <+SIZE|SIZE> [--dry-run]
  LV_PATH   full path, e.g. /dev/vg0/root
  SIZE      target size (e.g. 50G) or “+SIZE” to grow by that amount
Examples:
  $(basename "$0") /dev/vg0/root +5G
  $(basename "$0") /dev/vg0/root 120G
EOF
exit 1
}

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing cmd: $1"; exit 127; }; }
for c in lvs lvextend lsblk blkid; do need "$c"; done

[[ $# -lt 2 || $# -gt 3 ]] && usage
LV=$1
SIZE=$2
DRY=${3:-}

[[ $SIZE =~ ^\+?[0-9]+[MGTP]$ ]] || { echo "Invalid size: $SIZE"; usage; }

echo "# Extending $LV by/to $SIZE"
[[ $DRY == "--dry-run" ]] || {
  sudo lvextend -r -L "$SIZE" "$LV"
}

