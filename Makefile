NAME=zsh-syntax-highlighting

INSTALL?=install -c
PREFIX?=/usr/local
SHARE_DIR=$(DESTDIR)$(PREFIX)/share/$(NAME)

# Have the default target do nothing.
all:
	@ :

install:
	$(INSTALL) -d $(SHARE_DIR)
	cp -r .version zsh-syntax-highlighting.zsh highlighters $(SHARE_DIR)
	if [ x"true" = x"`git rev-parse --is-inside-work-tree 2>/dev/null`" ]; then \
		git rev-parse HEAD; \
	else \
		cat .revision-hash; \
	fi > $(SHARE_DIR)/.revision-hash

test:
	@result=0; \
	for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			zsh -f tests/test-highlighting.zsh "$${test##*/}"; \
			: $$(( result |= $$? )); \
		fi \
	done; \
	exit $$result

.PHONY: all install test
