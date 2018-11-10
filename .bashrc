# alias
alias ls='ls -G '
alias ll='ls -l '
alias vi='vim '
alias sudo='sudo '

alias rm='trash '
alias fuck='eval $(thefuck $(fc -ln -l))'

# git
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\h\[\033[00m\]:\W\[\033[31m\]$(__git_ps1 [%s])\[\033[00m\]\$ '

# PHP
source $HOME/.phpbrew/bashrc
