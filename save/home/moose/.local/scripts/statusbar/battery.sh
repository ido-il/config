#!/bin/sh

battery=$(ls /sys/class/power_supply | grep BAT | head -n 1)

if [ -n "$battery" ]; then
    status=$(cat /sys/class/power_supply/$battery/status)
    capacity=$(cat /sys/class/power_supply/$battery/capacity)

	[ "$status" = "Charging" ] && status="CHR"
    [ "$status" = "Discharging" ] && status="BAT"
    [ "$status" = "Full" ] && status="FUL"

    echo "$status $capacity%"
fi
