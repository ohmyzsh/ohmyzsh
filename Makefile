NAME=zsh-syntax-highlighting

PREFIX?=/usr/local
SHARE_DIR=$(DESTDIR)$(PREFIX)/share/$(NAME)

install:
	$(INSTALL) -d $(SHARE_DIR)
	cp -r zsh-syntax-highlighting.zsh highlighters $(SHARE_DIR)
