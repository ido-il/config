#!/bin/sh

set -e 

INDEX_FILE="index"
GIT_KEY="$HOME/.ssh/git"
DATE=$(date +"%Y-%m-%d_%H:%M:%S  %z") 
SAVE_DIR="$PWD/save"

rm -rf "$SAVE_DIR"
mkdir -p "$SAVE_DIR"

for path in $(cat $INDEX_FILE | grep "^/*"); do
	echo $path
	[[ ! -e "$path" ]] && continue
	save_path="$SAVE_DIR$path"
	mkdir -p "$(dirname $save_path)"
    cp -r "$path" "$save_path"
done

for path in $(cat $INDEX_FILE | grep "^!/*"); do
	path=$(echo "$path" | sed 's/!//')
	[[ ! -e "$path" ]] && continue
	save_path="$SAVE_DIR$path"
	mkdir -p "$(dirname $save_path)"
    rm -rf "$save_path"
done

find "$(pwd)/save" -type d -name ".git" -exec rm -rf {} +

git add save/
git diff --staged
git status

read -p "Would you like to save these chanegs? [y/N]: " answer

if [[ "$answer" = "y" || "$answer" = "Y" ]]; then    
    git commit -m "Backup on $DATE"
    git push
else
    git restore --staged save/
fi
