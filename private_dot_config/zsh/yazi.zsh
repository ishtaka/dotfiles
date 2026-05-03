# yazi.zsh - Yazi file manager shell integration

# yy: launch yazi and cd to its last directory on exit
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
}
