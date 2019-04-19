#!/bin/zsh

setopt EXTENDED_GLOB
for rcfile in .zsh/.zprezto/runcoms/^README.md(.N); do
  cp "$rcfile" .zsh/."${rcfile:t}"
done

