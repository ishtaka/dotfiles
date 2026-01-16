# options.zsh - General Zsh options

# General
setopt COMBINING_CHARS      # Combine zero-length punctuation characters
setopt INTERACTIVE_COMMENTS # Enable comments in interactive shell
setopt RC_QUOTES            # Allow 'Henry''s Whose strstrdings?'

# Job Control
setopt LONG_LIST_JOBS       # List jobs in the long format by default
setopt AUTO_RESUME          # Attempt to resume existing job before creating a new process
setopt NOTIFY               # Report status of background jobs immediately
unsetopt BG_NICE            # Don't run all background jobs at a lower priority
unsetopt HUP                # Don't kill jobs on shell exit
unsetopt CHECK_JOBS         # Don't report on jobs when shell exit

# Directory
setopt AUTO_CD              # Auto changes to a directory without typing cd
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given
setopt CDABLE_VARS          # Change directory to a path stored in a variable
setopt MULTIOS              # Write to multiple descriptors
setopt EXTENDED_GLOB        # Use extended globbing syntax
unsetopt CLOBBER            # Do not overwrite existing files with > and >>

# Input/Output
setopt IGNORE_EOF           # Do not exit on end-of-file (Ctrl-D)

# Disable flow control (Ctrl-S/Ctrl-Q)
[[ -r ${TTY:-} && -w ${TTY:-} && $+commands[stty] == 1 ]] && stty -ixon <$TTY >$TTY
