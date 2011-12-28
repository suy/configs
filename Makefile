all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Is just a convenience to do some repetitive tasks with my configuration".

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude=tags ./dotvim/ /cygdrive/c/vimfiles/
	cp -uf vimrc '/cygdrive/c/Archivos de programa/Vim/_vimrc'

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude=spell ./ roger:./configs
