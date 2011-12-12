# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL="ignoreboth"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi

# some more ls aliases
alias ll='ls -l'
alias lh='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    export KDEHOME=$HOME/.kdechroot
fi

# set a fancy prompt (non-color, unless we know we "want" color)
#case "$TERM" in
#xterm-color)
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
#    ;;
#*)
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#    ;;
#esac

# Comment in the above and uncomment this below for a color prompt
if [ -z $SSH_TTY ]
then
    connection_color="\[\e[1;32m\]"
else
    connection_color="\[\e[1;33m\]"
fi

PS1="\[\e[37m\]\A\[\e[0m\] \
${debian_chroot:+($debian_chroot)}\
$connection_color\u@\h\[\e[0m\]\
 \[\e[1;34m\]\w\[\e[0m\]\$ "

# If this is an xterm set the title (window) and the session (tab) name
case "$TERM" in
xterm*|rxvt*|konsole*)
    PS1=$PS1"\[\e]0;\w\a\]"
#    PS1=$PS1"\[\e]30;\u@\h\a\]"
    ;;
*)
    ;;
esac

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

if [ -f ~/.aliases ] ; then
    . ~/.aliases
fi

if [ -f ~/.environment ] ; then
    . ~/.environment
fi

