#!/bin/sh

# Update submodule
git submodule update --init --recursive

DOT_FILES=(.zsh .zshenv)

dir_path=$(cd $(dirname $0) && pwd)

for file in ${DOT_FILES[@]}
do
    ln -s $dir_path/$file $HOME/$file
done

# use zsh
echo /usr/local/bin/zsh | sudo tee -a /etc/shells
chsh -s /usr/local/bin/zsh

