# ~/.profile: sourced by sh(1) for login shells.

# The default umask is set in /etc/login.defs
umask 027

# If bash is defined, source .bashrc
if [ ! -z "$BASH" ]
then
	if [ -f ~/.bashrc ]
	then
		. ~/.bashrc
	fi
fi

