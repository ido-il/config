#!/bin/sh

case $BLOCK_BUTTON in
    1) st -e iwctl ;;
esac

iface=$(ip route | awk '/default/ {print $5}' | head -n1)

if iwctl station "$iface" show >/dev/null 2>&1; then
    ssid=$(iwctl station "$iface" show | awk -F'SSID: ' '/SSID/ {print $2}')
    out="$ssid$vpn"
else
    out="$iface$vpn"
fi

echo "$out"
