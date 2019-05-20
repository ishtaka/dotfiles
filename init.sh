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
# peco
rsync -av .config/peco ~/.config

# Fonts
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

