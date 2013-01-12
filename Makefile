all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Is just a convenience to do some repetitive tasks with my configuration".

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude=gnupg.vim --exclude-from=ignore-patterns ./dotvim/ /cygdrive/c/vimfiles/

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs

setup-unix:
	git submodule update --init
	ln -sf ${PWD}/vimrc ~/.vimrc
	ln -sf ${PWD}/dotvim ~/.vim # FIXME: fails on reruns
	ln -sf ${PWD}/bashrc ~/.bashrc
	ln -sf ${PWD}/aliases ~/.aliases
	ln -sf ${PWD}/environment ~/.environment
	ln -sf ${PWD}/environment ~/.kde/env/environment.sh
	ln -sf ${PWD}/gitconfig ~/.gitconfig
	ln -sf ${PWD}/ignore-patterns ~/.ignore-patterns
	ln -sf ${PWD}/screenrc ~/.screenrc
	ln -sf ${PWD}/inputrc ~/.inputrc

install-powerline-fonts:
	git clone git://gist.github.com/1630581.git ~/.fonts/ttf-dejavu-powerline
