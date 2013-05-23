all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Is just a convenience to do some repetitive tasks with my configuration".

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude=gnupg.vim --exclude-from=ignore-patterns ./dotvim/ /cygdrive/c/vimfiles/

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs

setup-unix:
	git submodule update --init
	@# Specific module/plugin setup.
	make -C dotvim/bundle/vimproc -f make_unix.mak
	ln -sf ${PWD}/dotvim/bundle/linepower/config ~/.config/powerline
	@# ln -sf ${PWD}/powerline/powerline/bindings/vim/ dotvim/bundle/powerline
	ln -sf ${PWD}/vimrc ~/.vimrc
	test -L ~/.vim || ln -sf ${PWD}/dotvim ~/.vim
	ln -sf ${PWD}/bashrc ~/.bashrc
	ln -sf ${PWD}/aliases ~/.aliases
	ln -sf ${PWD}/environment ~/.environment
	test ~/.kde/ && test -d ~/.kde/env || mkdir ~/.kde/env/
	ln -sf ${PWD}/environment ~/.kde/env/environment.sh
	ln -sf ${PWD}/gitconfig ~/.gitconfig
	ln -sf ${PWD}/ignore-patterns ~/.ignore-patterns
	ln -sf ${PWD}/screenrc ~/.screenrc
	ln -sf ${PWD}/inputrc ~/.inputrc
	ln -sf ${PWD}/tmux.conf ~/.tmux.conf

install-powerline-fonts:
	# git clone git://gist.github.com/1630581.git ~/.fonts/ttf-dejavu-powerline
	mkdir -p ~/.fonts ~/.config/fontconfig
	ln -sf ${PWD}/powerline/font/ ~/.fonts/powerline
	ln -sf ${PWD}/powerline/font/ ~/.config/fontconfig/powerline
