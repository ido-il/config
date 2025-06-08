#!/bin/sh

LANGS=`cat <<EOF
us:English
il:Hebrew
EOF`

CURRENT=$(setxkbmap -query | awk '/layout:/ {print $2}')

NEXT_KEYMAP=""
NEXT_LABEL=""
FOUND=0

while IFS= read -r line; do
    KEYMAP=$(echo "$line" | cut -d: -f1)
    LABEL=$(echo "$line" | cut -d: -f2-)

    if [ "$FOUND" = 1 ]; then
        NEXT_KEYMAP=$KEYMAP
        NEXT_LABEL=$LABEL
        break
    fi

    [ "$KEYMAP" = "$CURRENT" ] && FOUND=1

    [ -z "$FIRST_KEYMAP" ] && FIRST_KEYMAP=$KEYMAP && FIRST_LABEL=$LABEL
done <<EOF
$LANGS
EOF

if [ "$FOUND" = 0 ]; then
	notify-send -u critical "Error: unrecognize language" "current keymap '$CURRENT'"
	exit 1
elif [ -n "$NEXT_KEYMAP" ]; then
    setxkbmap "$NEXT_KEYMAP"
    notify-send -u low "Switch language: $NEXT_LABEL"
else
    setxkbmap "$FIRST_KEYMAP"
    notify-send -u low "Switch language: $FIRST_LABEL"
fi
