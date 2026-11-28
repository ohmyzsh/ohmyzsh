NAME=zsh-navigation-tools

INSTALL?=install -c
PREFIX?=/usr/local
SHARE_DIR?=$(DESTDIR)$(PREFIX)/share/$(NAME)
DOC_DIR?=$(DESTDIR)$(PREFIX)/share/doc/$(NAME)

all:

install:
	$(INSTALL) -d $(SHARE_DIR)
	$(INSTALL) -d $(SHARE_DIR)/.config
	$(INSTALL) -d $(SHARE_DIR)/.config/znt
	$(INSTALL) -d $(DOC_DIR)
	cp zsh-navigation-tools.plugin.zsh _n-kill doc/znt-tmux.zsh $(SHARE_DIR)
	cp README.md NEWS LICENSE doc/img/n-history2.png $(DOC_DIR)
	if [ x"true" = x"`git rev-parse --is-inside-work-tree 2>/dev/null`" ]; then \
		git rev-parse HEAD; \
	else \
		cat .revision-hash; \
	fi > $(SHARE_DIR)/.revision-hash
	:
	for fname in n-*; do cp "$$fname" $(SHARE_DIR); done; \
	for fname in znt-*; do cp "$$fname" $(SHARE_DIR); done; \
	for fname in .config/znt/n-*; do cp "$$fname" $(SHARE_DIR)/.config/znt; done;

uninstall:
	rm -f $(SHARE_DIR)/.revision-hash $(SHARE_DIR)/_* $(SHARE_DIR)/zsh-* $(SHARE_DIR)/n-* $(SHARE_DIR)/znt-* $(SHARE_DIR)/.config/znt/n-*
	[ -d $(SHARE_DIR)/.config/znt ] && rmdir $(SHARE_DIR)/.config/znt || true
	[ -d $(SHARE_DIR)/.config ] && rmdir $(SHARE_DIR)/.config || true
	[ -d $(SHARE_DIR) ] && rmdir $(SHARE_DIR) || true
	rm -f $(DOC_DIR)/README.md $(DOC_DIR)/LICENSE $(DOC_DIR)/n-history2.png 
	[ -d $(DOC_DIR) ] && rmdir $(DOC_DIR) || true

.PHONY: all install uninstall
