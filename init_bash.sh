#!/bin/sh

DOT_FILES=(.bashrc .bash_profile)

dir_path=$(cd $(dirname $0) && pwd)

for file in ${DOT_FILES[@]}
do
    ln -s $dir_path/$file $HOME/$file
done

