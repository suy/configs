.PHONY: all roger-push-config setup-unix setup-unix-extras

all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Run 'make setup-unix' to setup the configuration."

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs

# Setup for "everything" except the submodules or anything "heavy".
setup-unix:
	ln -sf $(CURDIR)/bashrc ~/.bashrc
	ln -sf $(CURDIR)/aliases ~/.aliases
	ln -sf $(CURDIR)/environment ~/.environment
	@# I don't think this is needed anymore. Kept just in case I regret it later.
	@# test -d ~/.kde/ && test -d ~/.kde/env || mkdir -p ~/.kde/env/
	@# ln -sf $(CURDIR)/environment ~/.kde/env/environment.sh
	@# This config is for git to modify at will, so is only copied. Is where the
	@# user name and email can be set to each ones values.
	cp -f $(CURDIR)/gitconfig ~/.gitconfig
	@# This is not changed by "git config --global", so it can be under version
	@# control, and improved by hand like the other files.
	ln -sf $(CURDIR)/gitconfig.extra ~/.gitconfig.extra
	ln -sf $(CURDIR)/ignore-patterns ~/.ignore-patterns
	ln -sf $(CURDIR)/screenrc ~/.screenrc
	ln -sf $(CURDIR)/inputrc ~/.inputrc
	ln -sf $(CURDIR)/tmux.conf ~/.tmux.conf
	ln -sf $(CURDIR)/gemrc ~/.gemrc
	test -d ~/.ssh || mkdir ~/.ssh/
	test -d ~/.ssh/config.d || mkdir ~/.ssh/config.d
	ln -sf $(CURDIR)/sshconfig ~/.ssh/config
	@# Set the symbolic links for Neovim, but not the submodules for plugins.
	test -d ~/.config || mkdir ~/.config
	test -L ~/.config/nvim || ln -sf $(CURDIR)/dotvim ~/.config/nvim
	# https://stackoverflow.com/questions/20828657/docker-change-ctrlp-to-something-else
	@echo 'Remember to add "detachKeys": "ctrl-z,z" to ~/.docker/config.json'


setup-unix-extras: setup-unix
	@# Just in case I forgot to use --recursive.
	git submodule update --init
	git x-submodule-attach
	git x-submodule-reset
	git remote set-url --push origin git@github.com:suy/configs.git
