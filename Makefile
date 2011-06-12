install:
	[ -f $(HOME)/.oh-my-zsh ] || ln -v -s $(PWD) $(HOME)/.oh-my-zsh
	[ -f $(HOME)/.zshrc ] || ln -v -s $(PWD)/templates/zshrc.zsh-template $(HOME)/.zshrc
