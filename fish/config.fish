#
# Init file for fish
#

#
# Some things should only be done for login terminals
#

if status --is-login

    #
    # Set some value for LANG if nothing was set before, and this is a
    # login shell.
    #

    if not set -q LANG >/dev/null
        set -gx LANG en_US.UTF-8
    end

    # Check for i18n information in
    # /etc/sysconfig/i18n

    if test -f /etc/sysconfig/i18n
        eval (cat /etc/sysconfig/i18n |sed -ne 's/^\([a-zA-Z]*\)=\(.*\)$/set -gx \1 \2;/p')
    end

    #
    # Put linux consoles in unicode mode.
    #

    if test "$TERM" = linux
        if expr "$LANG" : ".*\.[Uu][Tt][Ff].*" >/dev/null
            if which unicode_start >/dev/null
                unicode_start
            end
        end
    end
end

# Add path variables
set -gx PATH /usr/local/bin $PATH

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# Set som vars
set -x BROWSER 'luakit'
set -x EDITOR 'vim'
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x _JAVA_AWT_WM_NONREPARENTING 1 # Make java GUI work with tiling WM


# Aliases
# ls aliases
alias ls 'ls --color=auto'
alias ll 'ls -alF'
alias la 'ls -A'
alias l 'ls -CF'
alias lf 'ls -F'
alias lsize 'ls -sSh'
alias SL 'sl -aF'

alias cmd 'command'
alias rot13 'tr a-zA-Z n-za-mN-ZA-M'
alias feh 'feh -Z --keep-zoom-vp'

# grc
alias ping 'grc ping'
alias ping6 'grc ping6'
alias cat 'grc cat'
alias gcc 'grc gcc'
alias g++ 'grc g++'
alias make 'grc make'
alias netstat 'grc netstat'
alias diff 'grc diff'
alias last 'grc last'

# Source: ioncache on github
# Add an "alert" alias for long running commands. Use like so:
# sleep 10; alert
function alert 
    #notify-send --urgency=low -i (eval ([ $status = 0 ] and echo terminal or echo error)) (eval (history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert\$//'))
    echo "alert broken."
end


function fish_prompt
  printf '%s%s%s@%s%s %s%s%s>' (set_color blue) (whoami) (set_color magenta) (set_color cyan) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

function fish_right_prompt
  set last_status $status
  printf '%s ' (__fish_git_prompt)
  set_color normal
end
