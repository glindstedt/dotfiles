# Size of all files and directories in folder
alias lsize='ls -A --quoting-style=c | xargs du -sh | sort -h'
function archive() { mv "$1" /mnt/home/common/Archive; }
export -f archive

# ls aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lf='ls -F'
#alias lsize='ls -sSh'
alias SL='sl -aF'

alias cmd='command'

alias gen-sshkey='ssh-keygen -C "$(whoami)@$(hostname)-$(date -I)"'

alias sbl='xbacklight ='
alias ibl='xbacklight +'
alias dbl='xbacklight -'

# Pretty print json
alias pjcat='python -m json.tool'

# grc
#alias ping='grc ping -p 54657272792050726174636865747420'
#alias ping6='grc ping6'
#alias cat='grc cat'
#alias gcc='grc gcc'
#alias g++='grc g++'
#alias make='grc make'
#alias netstat='grc netstat'
#alias diff='grc diff'
#alias last='grc last'

# Source: ioncache on github
# Add an "alert" alias for long running commands. Use like so:
# sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
