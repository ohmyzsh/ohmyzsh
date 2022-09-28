ZSH := $(shell command -v zsh 2> /dev/null)

all:

zwc:
	$(MAKE) -C gitstatus zwc
	$(or $(ZSH),:) -fc 'for f in *.zsh-theme internal/*.zsh; do zcompile -R -- $$f.zwc $$f || exit; done'

minify:
	$(MAKE) -C gitstatus minify
	rm -rf -- .git .gitattributes .gitignore LICENSE Makefile README.md font.md powerlevel10k.png

pkg: zwc
	$(MAKE) -C gitstatus pkg
