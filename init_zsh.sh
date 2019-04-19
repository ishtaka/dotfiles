#!/bin/sh

# Update submodule
git submodule update --init --recursive

DOT_FILES=(.zsh .zshenv)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done

# use zsh
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

