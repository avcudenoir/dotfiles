#!/bin/sh

FOLDER="$HOME/.tmux/plugins/tpm"

mkdir -p "$(dirname $FOLDER)"
if [ ! -d "$FOLDER" ] ; then
    git clone "https://github.com/tmux-plugins/tpm" $FOLDER 
fi