all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Run 'make setup-unix' to setup the configuration."

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude=gnupg.vim --exclude-from=ignore-patterns ./dotvim/ /cygdrive/c/vimfiles/

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs

# Setup for "everything" except Vim.
setup-unix:
	ln -sf ${PWD}/bashrc ~/.bashrc
	ln -sf ${PWD}/aliases ~/.aliases
	ln -sf ${PWD}/environment ~/.environment
	test -d ~/.kde/ && test -d ~/.kde/env || mkdir -p ~/.kde/env/
	ln -sf ${PWD}/environment ~/.kde/env/environment.sh
	@# This config is for git to modify at will, so is only copied. Is where the
	@# user name and email can be set to each ones values.
	cp -f ${PWD}/gitconfig ~/.gitconfig
	@# This is not changed by "git config --global", so it can be under version
	@# control, and improved by hand like the other files.
	ln -sf ${PWD}/gitconfig.extra ~/.gitconfig.extra
	ln -sf ${PWD}/ignore-patterns ~/.ignore-patterns
	ln -sf ${PWD}/screenrc ~/.screenrc
	ln -sf ${PWD}/inputrc ~/.inputrc
	ln -sf ${PWD}/tmux.conf ~/.tmux.conf
	ln -sf ${PWD}/gemrc ~/.gemrc
	test -d ~/.ssh || mkdir ~/.ssh/
	ln -sf ${PWD}/sshconfig ~/.ssh/config
	@# Set the symbolic links for vim, but not the submodules for plugins.
	ln -sf ${PWD}/vimrc ~/.vimrc
	test -L ~/.vim || ln -sf ${PWD}/dotvim ~/.vim
	test -d ~/.config || mkdir ~/.config
	test -L ~/.config/nvim || ln -sf ${PWD}/dotvim ~/.config/nvim
	ln -sf ${PWD}/vimrc ~/.config/nvim
	# https://stackoverflow.com/questions/20828657/docker-change-ctrlp-to-something-else
	echo 'Remember to add "detachKeys": "ctrl-z,z" to ~/.docker/config.json'


setup-unix-vim: setup-unix
	@# Just in case I forgot to use --recursive.
	git submodule update --init
	git x-submodule-attach
	git x-submodule-reset
	git remote set-url --push origin git@github.com:suy/configs.git
