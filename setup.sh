#!/bin/bash

DOT_FILES=(.bashrc .bash_profile .gitignore_global .vimrc .inputrc)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done
