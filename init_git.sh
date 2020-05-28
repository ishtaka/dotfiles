#!/bin/sh

if [ $# -ne 2 ]; then
    exit 1
fi

# user info
git config --global user.name $1
git config --global user.email $2

# prevent garbled
git config --global core.quotepath false

# auto lf
git config --global core.autocrlf input

# color ui
git config --global color.ui auto
git config --global color.status auto
git config --global color.branch auto

# git global ignore
git config --global core.excludesfile ~/.gitignore_global

# alias
git config --global alias.st status
git config --global alias.br branch
git config --global alias.ch checkout
git config --global alias.co commit
git config --global alias.df diff
git config --global alias.dfc "diff --cached"
git config --global alias.sw switch
git config --global alias.sb \!"git switch \$(git branch --format='%(refname:short)' | peco)"
