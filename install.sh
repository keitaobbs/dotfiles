#!/bin/bash

COMMANDS=("zsh" "tmux" "ack")
for cmd in ${COMMANDS[@]}
do
    if !(type $cmd > /dev/null 2>&1) ; then
        echo "$cmd not found, abort installation"
        exit
    fi
done

if [ ! -e $HOME/.fzf ] ; then
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --no-key-bindings --no-completion --no-update-rc
fi

DOT_FILES=(".zshrc" ".vimrc" ".tmux.conf" ".ctags" ".ackrc")
for file in ${DOT_FILES[@]}
do
    if [ ! -e $HOME/$file ] ; then
        ln -sv $HOME/dotfiles/$file $HOME/$file
    fi
done

echo "Installation succeeded"
