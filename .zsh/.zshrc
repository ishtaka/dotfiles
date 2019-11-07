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

# alias
alias cat='ccat '
alias g='git'
alias rm='trash '

# powerline
RPROMPT=""

# Ignore EOF
setopt IGNORE_EOF

# cdr
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# history via peco
if type "peco" > /dev/null 2>&1; then
  function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
  }
  zle -N peco-history-selection
  bindkey '^R' peco-history-selection

  function peco-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | peco)"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
  }
  zle -N peco-cdr
  bindkey '^D' peco-cdr

  if type "ghq" > /dev/null 2>&1; then
      function peco-ghq() {
          local selected_dir=$(ghq list -p | sort | peco --query "$LBUFFER")
          if [ -n "$selected_dir" ]; then
              BUFFER="cd ${selected_dir}"
              zle accept-line
          fi
      }
      zle -N peco-ghq
      bindkey '^O' peco-ghq
  fi
fi

