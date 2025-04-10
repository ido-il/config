#!/bin/sh

set -e 

# variables
INDEX_FILE="index"
SAVE_DIR="save"
DATE=$(date +"%Y-%m-%d_%H:%M:%S  %z") 
GIT_KEY="$HOME/.ssh/git"

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

# remove submodules by force
find "$(pwd)/save" -type d -name ".git" -exec rm -rf {} +

git add save/
git diff --staged
git status

read -p "Would you like to save these chanegs? [y/N]: " answer

if [[ "$answer" = "y" || "$answer" = "Y" ]]; then
    # initiate ssh agent
    # TODO: better method to push with SSH without initiating a new agent every time
    eval $(ssh-agent -s)
    ssh-add $GIT_KEY
    
    # save to repo
    git commit -m "Backup on $DATE"
    git push
else
    git restore --staged save/
fi
