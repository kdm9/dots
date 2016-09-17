#!/bin/bash

set -xe
HERE="$(readlink -f "$0"/.. )"

for dotfile in gitconfig tmux.conf zshrc
do
    ln -fs "$HERE/${dotfile}" "$HOME/.${dotfile}"
done

mkdir -p $HOME/.vim
ln -sf $HERE/vimrc $HOME/.vim


