#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

# Ruby
eval "$(rbenv init -)"
# Python
eval "$(pyenv init -)"
# Java
export JAVA_HOME=`/usr/libexec/java_home`

# direnv
eval "$(direnv hook zsh)"

# fuck
eval $(thefuck --alias)

# alias
alias rm='trash '

# powerline
RPROMPT=""
