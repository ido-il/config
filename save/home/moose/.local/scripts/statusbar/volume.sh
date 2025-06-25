#!/bin/sh

case $BLOCK_BUTTON in
    1) pamixer -t ;;
    4) pamixer --increase 5 ;;
    5) pamixer --decrease 5 ;;
esac

volume=$(pamixer --get-volume)
mute=$(pamixer --get-mute)

if [ "$mute" = "true" ]; then
    out="MUTE"
else
    out="$volume%"
fi

echo "$out"
