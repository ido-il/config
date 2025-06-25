#!/bin/sh

date '+%y-%m-%d %H:%M'

case $BLOCK_BUTTON in
    1) thunderbird -calendar;;
	2) notify-send "test";;
esac
