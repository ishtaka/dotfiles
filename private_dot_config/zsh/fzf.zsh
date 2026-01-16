# fzf.zsh - fzf configuration and functions

# fzf options file
export FZF_DEFAULT_OPTS_FILE=$HOME/.config/fzf/config

# cdr (recent directories)
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# fzf functions
if type fzf &>/dev/null; then
    # History search (Ctrl+R)
    function fzf-history-selection() {
        local selected=$(history -n 1 | tail -r | awk '!a[$0]++' | fzf)
        if [[ -n "$selected" ]]; then
            BUFFER=$selected
            CURSOR=$#BUFFER
        fi
        zle reset-prompt
    }
    zle -N fzf-history-selection
    bindkey '^R' fzf-history-selection

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
