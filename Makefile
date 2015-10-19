NAME=zsh-syntax-highlighting

INSTALL?=install -c
PREFIX?=/usr/local
SHARE_DIR=$(DESTDIR)$(PREFIX)/share/$(NAME)

# Have the default target do nothing.
all:
	@ :

install:
	$(INSTALL) -d $(SHARE_DIR)
	cp -r zsh-syntax-highlighting.zsh highlighters $(SHARE_DIR)

test:
	@result=0
	@for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			zsh tests/test-highlighting.zsh "$${test##*/}"; \
			: $$(( result |= $$? )); \
		fi \
	done
	@exit $$result
