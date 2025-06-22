#!/usr/bin/env bash
# screenshot.sh – select | freeze | edit

set -euo pipefail

SAVE_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
EDITOR_CMD="${SCREENSHOT_EDITOR:-gimp}"
CLIP="xclip -selection clipboard -t image/png"

die()  { notify-send -u critical "screenshot ❌ $*"; exit 1; }
need() { command -v "$1" &>/dev/null || die "missing: $1"; }
for b in maim xclip notify-send slop; do need "$b"; done
timestamp(){ date +"%Y-%m-%d_%H-%M-%S"; }

MODE=${1:-help}

case "$MODE" in
  select)
    maim -s | $CLIP || die maim
    notify-send -u low "📸 area screenshot"
    ;;

  freeze)
    need feh
    mkdir -p "$SAVE_DIR"
    FILE="$SAVE_DIR/$(timestamp).png"
    BG=$(mktemp --suffix=.png)
    maim "$BG"
    feh -x -F --zoom fill "$BG" & FEH=$!
    sleep 0.1
    GEOM=$(slop -f "%g") || die slop
    kill "$FEH"
    maim -g "$GEOM" "$FILE" && $CLIP <"$FILE" || die maim
    rm "$BG"
    notify-send -u low "❄️ frozen screenshot saved"
    ;;

  edit)
    mkdir -p "$SAVE_DIR"
    FILE="$SAVE_DIR/$(timestamp).png"
    maim -s "$FILE" || die maim
    ("$EDITOR_CMD" "$FILE" &)
    ;;

  *)
    echo "usage: $(basename "$0") {select|freeze|edit}" >&2
    exit 1
    ;;
esac
