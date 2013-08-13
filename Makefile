all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Is just a convenience to do some repetitive tasks with my configuration".

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude=gnupg.vim --exclude-from=ignore-patterns ./dotvim/ /cygdrive/c/vimfiles/

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs

setup-unix:
	@# Just in case I forgot to use --recursive.
	git submodule update --init
	git remote set-url --push origin git@github.com:suy/configs.git
	@#
	@# Specific module/plugin setup.
	make -C dotvim/bundle/vimproc -f make_unix.mak
	ln -sf ${PWD}/dotvim/bundle/linepower/config ~/.config/powerline
	@# ln -sf ${PWD}/powerline/powerline/bindings/vim/ dotvim/bundle/powerline
	@#
	@# Set the symbolic links.
	ln -sf ${PWD}/vimrc ~/.vimrc
	test -L ~/.vim || ln -sf ${PWD}/dotvim ~/.vim
	ln -sf ${PWD}/bashrc ~/.bashrc
	ln -sf ${PWD}/aliases ~/.aliases
	ln -sf ${PWD}/environment ~/.environment
	test ~/.kde/ && test -d ~/.kde/env || mkdir -p ~/.kde/env/
	ln -sf ${PWD}/environment ~/.kde/env/environment.sh
	@# This config is for git to modify at will, so is only copied.
	cp ${PWD}/gitconfig ~/.gitconfig
	@# This is not seen by Git, so is under version control, manually edited.
	ln -sf ${PWD}/gitconfig.local ~/.gitconfig.local
	ln -sf ${PWD}/ignore-patterns ~/.ignore-patterns
	ln -sf ${PWD}/screenrc ~/.screenrc
	ln -sf ${PWD}/inputrc ~/.inputrc
	ln -sf ${PWD}/tmux.conf ~/.tmux.conf
	ln -sf ${PWD}/sshconfig ~/.ssh/config

install-powerline-fonts:
	# git clone git://gist.github.com/1630581.git ~/.fonts/ttf-dejavu-powerline
	mkdir -p ~/.fonts ~/.config/fontconfig
	ln -sf ${PWD}/powerline/font/ ~/.fonts/powerline
	ln -sf ${PWD}/powerline/font/ ~/.config/fontconfig/powerline
