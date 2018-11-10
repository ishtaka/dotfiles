# PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/opt/openssl/bin:$PATH

# History
export HISTSIZE=2000
export HISTCONTROL=ignoreboth
export HISTIGNORE=ls*:fg*:bg*:history*:which*

# direnv
eval "$(direnv hook bash)"

# Ruby
eval "$(rbenv init -)"

# Python
eval "$(pyenv init -)"

# Java
export JAVA_HOME=`/usr/libexec/java_home`

if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

