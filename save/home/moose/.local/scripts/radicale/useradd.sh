#!/bin/sh
[[ -z "$1" ]] && echo "Error: missing new user name" && exit 1
htpasswd -5 /home/radicale/server/users $1
