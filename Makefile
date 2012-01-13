all:
	@echo "This Makefile isn't intended to build anything."
	@echo "Is just a convenience to do some repetitive tasks with my configuration".

windows-push-vim-config:
	rsync -av --delete --exclude=.git --exclude-from=ignore-patterns --safe-links ./dotvim/ /cygdrive/c/vimfiles/

roger-push-config:
	rsync -avz --delete --exclude=.git --exclude-from=ignore-patterns --exclude=spell ./ roger:./configs
