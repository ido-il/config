#!/usr/bin/env bash
SCRIPTS="
top-dirs.sh
extend-lv.sh
apparmor.sh
qemu.sh
screenshot.sh
"

mkdir -p $HOME/.local/bin

for script in $(echo $SCRIPTS | sed 's/\n/ /g'); do
	cp "$SCRIPT_HOME/$script" "$HOME/.local/bin"
done
