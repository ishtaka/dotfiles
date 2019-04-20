#!/bin/sh

DOT_FILES=(.gitignore_global .vimrc .inputrc .Brewfile)

for file in ${DOT_FILES[@]}
do
    ln -s $HOME/dotfiles/$file $HOME/$file
done

# Homebrew
brew bundle --global

# Karabiner
rsync -av .config/karabiner ~/.config

# Fonts
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf

