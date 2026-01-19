# fzf.zsh - fzf configuration and functions

# fzf options file
export FZF_DEFAULT_OPTS_FILE=$HOME/.config/fzf/config

# fzf keybinding options
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}' --preview-window=right:50%"
export FZF_ALT_C_OPTS="--preview 'eza -la --icons=always {}' --preview-window=right:50%"

# fzf standard keybindings
if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
fi

# cdr (recent directories)
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# Custom fzf functions
if type fzf &>/dev/null; then
    # cdr - recent directory selection (Ctrl+D)
    function fzf-cdr() {
        local selected_dir=$(cdr -l | awk '{ print $2 }' | fzf)
        if [[ -n "$selected_dir" ]]; then
            BUFFER="cd ${selected_dir}"
            zle accept-line
        else
            zle redisplay
        fi
    }
    zle -N fzf-cdr
    bindkey '^D' fzf-cdr

    # ghq integration (Ctrl+O)
    if type ghq &>/dev/null; then
        function fzf-ghq() {
            local selected_dir=$(fd -H -t d '^\.git$' "$(ghq root)" --max-depth 7 | sed -e "s#/.git##" | sort | fzf --query "$LBUFFER")
            if [[ -n "$selected_dir" ]]; then
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
