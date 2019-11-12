#!/bin/bash

set -xe
HERE=$(dirname $(readlink -f "$0"))

for dotfile in gitconfig gitignore_global tmux.conf zshrc zshenv inputrc
do
    ln -fs "$HERE/${dotfile}" "$HOME/.${dotfile}"
done

mkdir -p "$HOME/.config/nvim" && ln -sf "$HERE/nvim-init.vim" "$HOME/.config/nvim/init.vim"
