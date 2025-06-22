#!/bin/bash
set -euo pipefail

INDEX_FILE="index"
SAVE_DIR="$PWD/save"

rm -rf "$SAVE_DIR"
mkdir -p "$SAVE_DIR"

while IFS= read -r line; do
    [[ "$line" =~ ^#.*$ || -z "$line" ]] && continue
    if [[ "$line" =~ ^! ]]; then
        path="$SAVE_DIR${line:1}"
        rm -rf "$path"
    else
        [[ ! -e "$line" ]] && continue
        path="$SAVE_DIR$line"
        mkdir -p "$(dirname "$path")"
        cp -r "$line" "$path"
    fi
done < "$INDEX_FILE"

find "$SAVE_DIR" -type d -name ".git" -exec rm -rf {} +

git add save/
git diff --staged
git status

read -p "Would you like to save these changes? [y/N]: " answer
if [[ "$answer" =~ ^[Yy]$ ]]; then
    git commit -m "Backup on $(date +"%Y-%m-%d_%H:%M:%S  %z")"
    git push
else
    git restore --staged save/
fi
