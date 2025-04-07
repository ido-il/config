#!/bin/sh

set -e 

# variables
INDEX_FILE="index"
SAVE_DIR="save"
DATE=$(date +"%Y-%m-%d_%H:%M:%S  %z") 

# clear current save dir
rm -rf $SAVE_DIR
mkdir -p $SAVE_DIR

# copy indexed files to save dir
for dest in $(cat $INDEX_FILE); do
  if [ -f $dest ] || [ -d $dest ]; then
    mkdir -p "$(pwd)/$SAVE_DIR$(dirname $dest)"
    cp -r $dest "$(pwd)/$SAVE_DIR$dest"
  fi
done

# show changes
git diff

# save to repo
git add .
git commit -m "Backup on $DATE"
git push origin main
