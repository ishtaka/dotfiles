# aliases.zsh - Alias definitions

# ls (eza)
alias ls='eza'
alias l='eza -1a'
alias ll='eza -l'
alias la='eza -la'
alias lt='eza -l --sort=modified'

# grep
export GREP_COLOR='37;45'
export GREP_COLORS="mt=$GREP_COLOR"
alias grep='grep --color=auto'

# Safety
alias cp='cp -i'
alias mv='mv -i'

# Custom
alias cat='ccat'
alias g='git'
alias rm='trash'
alias o='open'

# Resource usage
alias df='df -kh'
alias du='du -kh'
alias topc='top -o cpu'
alias topm='top -o vsize'

# Directory stack
alias -- -='cd -'
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# History statistics
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
