# keybindings.zsh - Key bindings configuration

# Use emacs key bindings
bindkey -e

# Word characters
WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Load terminfo
zmodload zsh/terminfo

# Edit command line in external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Basic key bindings
bindkey '^[[H' beginning-of-line      # Home
bindkey '^[[F' end-of-line            # End
bindkey '^[[3~' delete-char           # Delete
bindkey '^?' backward-delete-char     # Backspace
bindkey '^[[1;5D' backward-word       # Ctrl+Left
bindkey '^[[1;5C' forward-word        # Ctrl+Right
bindkey '^[[Z' reverse-menu-complete  # Shift+Tab
