NAME=zsh-syntax-highlighting

PREFIX?=/usr/local
SHARE_DIR=$(DESTDIR)$(PREFIX)/share/$(NAME)

install:
	$(INSTALL) -d $(SHARE_DIR)
	cp -r zsh-syntax-highlighting.zsh highlighters $(SHARE_DIR)

test:
	@for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			zsh tests/test-highlighting.zsh "$${test##*/}"; \
		fi \
	done
