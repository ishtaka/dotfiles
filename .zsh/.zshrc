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
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
# Go
eval "$(goenv init -)"
export PATH=$GOPATH/bin:$PATH
# Java
export JAVA_HOME=`/usr/libexec/java_home`
# Node.js
eval "$(nodenv init -)"

# direnv
eval "$(direnv hook zsh)"

# alias
alias cat='ccat '
alias g='git'
alias rm='trash '

# Google Clound SDK
if [[ -s "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc" ]]; then
    source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
fi

if [[ -s "/usr/local/bin/kubectl" ]]; then
    source <(kubectl completion zsh)
fi

# fzf
export FZF_DEFAULT_OPTS_FILE=$HOME/.config/fzf/config

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

# history via fzf
if type "fzf" > /dev/null 2>&1; then
  function fzf-history-selection() {
    local selected=`history -n 1 | tail -r  | awk '!a[$0]++' | fzf`
    if [ -n "$selected" ]; then
      BUFFER=$selected
      CURSOR=$#BUFFER
    fi
    zle reset-prompt
  }
  zle -N fzf-history-selection
  bindkey '^R' fzf-history-selection

  function fzf-cdr () {
    local selected_dir="$(cdr -l | awk '{ print $2 }' | fzf)"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    else
        zle redisplay
    fi
  }
  zle -N fzf-cdr
  bindkey '^D' fzf-cdr

  if type "ghq" > /dev/null 2>&1; then
      function fzf-ghq() {
          local selected_dir=$(find "$(ghq root)" -type d -name .git -maxdepth 7 | sed -e "s#/.git##" | sort | fzf --query "$LBUFFER")
          if [ -n "$selected_dir" ]; then
              BUFFER="cd ${selected_dir}"
              zle accept-line
          else
              zle redisplay
          fi
      }
      zle -N fzf-ghq
      bindkey '^O' fzf-ghq
  fi
fi

