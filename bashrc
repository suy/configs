# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL="ignoreboth"
export HISTFILESIZE=5000
export HISTSIZE=5000
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Give "**" and "**/" some additional meaning.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# Enable the shell completion. Some functions can be used later to set PS1
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
elif [ -f /usr/share/bash-completion/bash_completion ]; then
	. /usr/share/bash-completion/bash_completion
fi

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" -a -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
    export KDEHOME=$HOME/.kdechroot
fi

if [ -z $SSH_TTY ]
then
    connection_color="\[\e[1;32m\]"
else
    connection_color="\[\e[1;33m\]"
fi

# First the hour wrapped in colors
# Next the chroot name if available
# Now the user@host preceded by a different color if in a remote host
# The current directory
# The information about the git repository
# The trailing prompt
PS1="\[\e[37m\]\A\[\e[0m\] \
${debian_chroot:+($debian_chroot)}\
$connection_color\u@\h\[\e[0m\] \
\[\e[1;34m\]\w\[\e[0m\]"
# Check if __git_ps1 exists.
if type -t __git_ps1 > /dev/null ; then
	PS1=$PS1'\[\e[1;35m\]$(__git_ps1 " %s")\[\e[0m\]\$ '
else
	PS1=$PS1'\[\e[0m\]\$ '
fi

# Additional options for git prompt flags
case "$(uname)" in
MINGW*|MSYS*|CYGWIN*)
	# alias git='git.cmd'
	# source '/cygdrive/c/Archivos de programa/Git/etc/git-completion.bash'
	;;
*)
	# Don't do this on Cygwin, since is slow.
	export GIT_PS1_SHOWDIRTYSTATE=1
	export GIT_PS1_SHOWUPSTREAM=auto
	;;
esac

# export GIT_PS1_SHOWSTASHSTATE=1
# export GIT_PS1_SHOWUNTRACKEDFILES=1

# source ~/local/configs/powerline/powerline/bindings/bash/powerline.sh

# If this is an xterm set the title (window) and the session (tab) name
case "$TERM" in
xterm*|rxvt*|konsole*)
    # PS1=$PS1"\[\e]0;\w\a\]"
#    PS1=$PS1"\[\e]30;\u@\h\a\]"
    ;;
*)
    ;;
esac

if [ -f ~/.aliases ] ; then
    . ~/.aliases
fi

if [ -f ~/.environment ] ; then
    . ~/.environment
fi

