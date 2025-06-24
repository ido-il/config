#!/bin/bash

need() { command -v "$1" >/dev/null || { echo "Need $1"; exit 127; }; }
for c in wpctl; do need "$c"; done

ACTION="$1"
TARGET="${2:-alsa_output.usb-Jieli_Technology_CA-2890_USB_Speaker_Bar_50443090BAF0811F-00.analog-stereo}"
STEP="${3:-5%}"

case "$ACTION" in
  up) wpctl set-volume "$TARGET" "++$STEP" ;;
  down) wpctl set-volume "$TARGET" "--$STEP" ;;
  mute) wpctl set-mute "$TARGET" 1 ;;
  unmute) wpctl set-mute "$TARGET" 0 ;;
  *)
    echo "Usage: $0 [up|down|mute|unmute] [target] [step]"
    echo "Examples:"
    echo "  $0 up"
    echo "  $0 mute @DEFAULT_AUDIO_SOURCE@"
    ;;
esac

