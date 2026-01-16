# dev-env.zsh - Development environment configuration

# mise
if type mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# Java
if [[ -x /usr/libexec/java_home ]]; then
    export JAVA_HOME=$(/usr/libexec/java_home 2>/dev/null)
fi

# direnv
if type direnv &>/dev/null; then
    eval "$(direnv hook zsh)"
fi
