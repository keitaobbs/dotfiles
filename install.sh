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

if [ ! -e $HOME/.vim/coc-settings.json ] ; then
    ln -sv $HOME/dotfiles/coc-settings.json $HOME/.vim/coc-settings.json
fi

if [ ! -e $HOME/.vim/UltiSnips ] ; then
    ln -sv $HOME/dotfiles/UltiSnips $HOME/.vim/UltiSnips
fi

mkdir -p $HOME/.config/efm-langserver
if [ ! -e $HOME/.config/efm-langserver/config.yaml ] ; then
    ln -sv $HOME/dotfiles/efm-langserver/config.yaml $HOME/.config/efm-langserver/config.yaml
fi

echo "Installation succeeded"
