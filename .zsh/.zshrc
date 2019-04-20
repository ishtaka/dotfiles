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

# history via peco
if type "peco" > /dev/null 2>&1; then
  function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
  }
  zle -N peco-history-selection
  bindkey '^R' peco-history-selection
fi

