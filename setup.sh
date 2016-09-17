#!/bin/bash

set -xe
HERE=$(dirname $(readlink -f "$0"))

for dotfile in gitconfig tmux.conf zshrc
do
    ln -fs "$HERE/${dotfile}" "$HOME/.${dotfile}"
done

VI=$HOME/.vim
mkdir -p $VI
if [ ! -d $VI/bundle/Vundle.vim ]; then
    mkdir $VI/bundle
    git clone https://github.com/VundleVim/Vundle.vim.git $VI/bundle/Vundle.vim
fi
ln -sf $HERE/vimrc $VI
vim +PluginInstall +qall
unset VI
