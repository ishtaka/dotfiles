# dev-env.zsh - Development environment configuration

# Ruby
if type rbenv &>/dev/null; then
    eval "$(rbenv init -)"
fi

# Python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if type pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Go
if type goenv &>/dev/null; then
    eval "$(goenv init -)"
    export PATH=$GOPATH/bin:$PATH
fi

# Java
if [[ -x /usr/libexec/java_home ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi

# Node.js
if type nodenv &>/dev/null; then
    eval "$(nodenv init -)"
fi

# direnv
if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi
