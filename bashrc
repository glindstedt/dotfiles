#
# ~/.bashrc
#

# Source system profile
[[ -f /etc/profile ]] && . /etc/profile

# ANSI color codes for easier prompt setting
# Options: Bold=1; Underline=4;
# Put options before \dm for example: "\[\033[1;32m\]"
RS="\[\033[0m\]"    # reset
HC="\[\033[1m\]"    # hicolor
UL="\[\033[4m\]"    # underline
INV="\[\033[7m\]"   # inverse background and foreground
FBLK="\[\033[30m\]" # foreground black
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[01;32m\]" # foreground green
FYEL="\[\033[33m\]" # foreground yellow
FBLE="\[\033[1;34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBLK="\[\033[40m\]" # background black
BRED="\[\033[41m\]" # background red
BGRN="\[\033[42m\]" # background green
BYEL="\[\033[43m\]" # background yellow
BBLE="\[\033[44m\]" # background blue
BMAG="\[\033[45m\]" # background magenta
BCYN="\[\033[46m\]" # background cyan
BWHT="\[\033[47m\]" # background white

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source machine-specific settings
if [ -f ~/.dotsources ]; then
    . ~/.dotsources
fi

# enable automatic core-dumping by c programs
ulimit -c unlimited

# EDITOR
export EDITOR=vim

# Make java GUI work with tiling WM
_JAVA_AWT_WM_NONREPARENTING=1; export _JAVA_AWT_WM_NONREPARENTING

PS1="${FGRN}[\u@\h \W]\$${RS} "

#fortune | cowsay -n
