export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init -)"

export HISTSIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE=ls*:fg*:bg*:history*:which*


if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

export JAVA_HOME=`/usr/libexec/java_home -v 1.8`
