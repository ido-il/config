#!/bin/sh

case $BLOCK_BUTTON in
    1) st -e btop ;;
esac

cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%.0f%%", usage}')
temperature=$(sensors | grep -m 1 'Package' | awk '{print $4}' | sed 's/+//')
[ -z "$temperature" ] && temperature="$(sensors | grep -m 1 'Tctl' | awk '{print $2}' | sed 's/+//')"

memory=$(free -h | awk '/Mem:/ {print $3 "/" $2}')

echo "CPU:$cpu $temperature RAM:$memory"
