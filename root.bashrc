# ~/.bashrc: executed by bash(1) for non-login shells.

if [ -z $SSH_TTY ]
then
    connection_color="\[\e[1;31m\]"
else
    connection_color="\[\e[1;37;41m\]"
fi

PS1="$connection_color\h\[\e[0m\]\
:\[\e[1;33m\]\w\[\e[0m\]\
\[\e[31m\]\\$\[\e[0m\] "

# If this is an xterm set the title (window) and the session (tab) name
case "$TERM" in
xterm*|rxvt*)
  PS1=$PS1"\[\e]0;\w\a\]"
  PS1=$PS1"\[\e]30;\u@\h#\l\a\]"
  ;;
*)
  ;;
esac

umask 022

# You may uncomment the following lines if you want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval "`dircolors`"
alias ls='ls $LS_OPTIONS'
alias ll='ls $LS_OPTIONS -l'
alias l='ls $LS_OPTIONS -lA'

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
