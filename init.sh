#!/bin/sh

DOT_FILES=(.Brewfile .gitignore_global .inputrc .vimrc)

dir_path=$(cd $(dirname $0) && pwd)

for file in ${DOT_FILES[@]}
do
    ln -s $dir_path/$file $HOME/$file
done

# Homebrew
brew bundle --global

# Karabiner
rsync -av .config/karabiner ~/.config
# fzf
rsync -av .config/fzf ~/.config

# Java
sudo ln -sfn $(brew --prefix)/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
