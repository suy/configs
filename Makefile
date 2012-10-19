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
	ln -sf ${PWD}/screenrc ~/.screenrc
	ln -sf ${PWD}/inputrc ~/.inputrc
	# My git configuration, for now, is not a file like others
	git config --global alias.st status
	git config --global alias.co checkout
	git config --global alias.ci commit
	git config --global alias.br branch
	git config --global alias.sb show-branch
	git config --global alias.subdo "submodule foreach git"
	git config --global alias.unstage-all "reset HEAD ."
	git config --global alias.last "checkout -- "
	git config --global alias.wdiff "diff --word-diff=color"
	git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative"
	git config --global user.name "Alejandro Exojo"
	git config --global user.email suy@badopi.org
	git config --global core.excludesfile ${PWD}/ignore-patterns
	#git config --global core.autocrlf input # Caution: not throughly tested, only Win?
	#git config --global core.symlinks true
	git config --global color.ui true
	git config --global help.autocorrect 20 # Fix typos automatically

install-powerline-fonts:
	git clone git://gist.github.com/1630581.git ~/.fonts/ttf-dejavu-powerline
