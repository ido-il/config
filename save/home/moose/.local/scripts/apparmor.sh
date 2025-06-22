#!/usr/bin/env bash
# apparmor – lightweight wrapper for common AppArmor tasks
set -euo pipefail

need() { command -v "$1" >/dev/null || { echo "Need $1"; exit 127; }; }
for c in apparmor_parser aa-status; do need "$c"; done

usage() {
cat <<EOF
Usage: $(basename "$0") COMMAND [ARGS]
  install                – enable AppArmor service and load profiles
  status                 – show loaded profiles
  create  <binary>       – start aa-genprof for <binary>
  enforce <profile>      – set profile to enforce
  complain <profile>     – set profile to complain
  disable <profile>      – unload and disable
EOF
exit 1
}

[[ $# -lt 1 ]] && usage
cmd=$1 ; shift

case $cmd in
  install)
    need systemctl
    sudo systemctl enable --now apparmor.service
    sudo systemctl reload apparmor.service
    ;;

  status)
    aa-status
    ;;

  create)
    need aa-genprof
    [[ $# -eq 1 ]] || usage
    sudo aa-genprof "$1"
    ;;

  enforce|complain|disable)
    [[ $# -eq 1 ]] || usage
    sudo aa-"$cmd" "$1"
    ;;

  *) usage;;
esac
