#!/bin/sh

case $BLOCK_BUTTON in
    1) st -e ncmpcpp ;;
    4) mpc prev ;;
    5) mpc next ;;
esac

status=$(mpc status 2>/dev/null)

if [ -z "$status" ]; then
    out="🎵 ---"
else
    line=$(mpc current)
    state=$(echo "$status" | awk 'NR==2 {print $1}')

    icon=""
    case "$state" in
        "[playing]") icon="▶️" ;;
        "[paused]") icon="⏸️" ;;
        *) icon="⏹️" ;;
    esac

    [ -z "$line" ] && line="No Track"

    out="$icon $line"
fi

echo $out
