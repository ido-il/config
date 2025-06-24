#!/bin/bash

usage() {
cat <<EOF
Usage: $0 [set|up|down|mute|unmute] [id] [volume]

Options:
  $0 set [id] [volume]
  $0 up [id] [volume]
  $0 down [id] [volume]
  $0 mute [id]
  $0 unmute [id]

Examples:
  $0 set [id] 0.8
  $0 up [id]
  $0 up [id] 10%
  $0 down [id] 0.15
  $0 mute [id]
EOF
}

need() { command -v "$1" >/dev/null || { echo "Need $1"; exit 127; }; }
need wpctl

[[ -z "$1" || -z "$2" ]] && usage && exit 1
[[ -n "$3" && ! $3 =~ ^(100%|[01]|[0-9]{1,2}%|0\.[0-9]+)$ ]] && echo "Error: \`$3\` is not a valid volume option" && exit 1

ID="$2"

case "$1" in
  set)    wpctl set-volume "$ID" "${3:-0.5}" ;;
  up)     wpctl set-volume "$ID" "${3:-0.05}+" ;;
  down)   wpctl set-volume "$ID" "${3:-0.05}-" ;;
  mute)   wpctl set-mute "$ID" 1 ;;
  unmute) wpctl set-mute "$ID" 0 ;;
  toggle) wpctl set-mute "$ID" toggle ;;
  *) usage;;
esac
