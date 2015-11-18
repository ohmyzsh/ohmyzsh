NAME=zsh-syntax-highlighting

INSTALL?=install -c
PREFIX?=/usr/local
SHARE_DIR?=$(DESTDIR)$(PREFIX)/share/$(NAME)
DOC_DIR?=$(DESTDIR)$(PREFIX)/share/doc/$(NAME)
ZSH?=zsh # zsh binary to run tests with

# Have the default target do nothing.
all:
	@ :

install:
	$(INSTALL) -d $(SHARE_DIR)
	$(INSTALL) -d $(DOC_DIR)
	$(INSTALL) .version zsh-syntax-highlighting.zsh $(SHARE_DIR)
	$(INSTALL) COPYING.md README.md changelog.md $(DOC_DIR)
	if [ x"true" = x"`git rev-parse --is-inside-work-tree 2>/dev/null`" ]; then \
		git rev-parse HEAD; \
	else \
		cat .revision-hash; \
	fi > $(SHARE_DIR)/.revision-hash
	:
# The [ -e ] check below is to because sh evaluates this with (the moral
# equivalent of) NONOMATCH in effect, and highlighters/*.zsh has no matches.
	for dirname in highlighters highlighters/*/ ; do \
		$(INSTALL) -d $(SHARE_DIR)/"$$dirname"; \
		$(INSTALL) -d $(DOC_DIR)/"$$dirname"; \
		for fname in "$$dirname"/*.zsh ; do [ -e "$$fname" ] && $(INSTALL) "$$fname" $(SHARE_DIR)"/$$dirname"; done; \
		for fname in "$$dirname"/*.md ; do  [ -e "$$fname" ] && $(INSTALL) "$$fname" $(DOC_DIR)"/$$dirname"; done; \
	done

test:
	@result=0; \
	for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			$(ZSH) -f tests/test-highlighting.zsh "$${test##*/}"; \
			: $$(( result |= $$? )); \
		fi \
	done; \
	exit $$result

perf:
	@result=0; \
	for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			$(ZSH) -f tests/test-perfs.zsh "$${test##*/}"; \
			: $$(( result |= $$? )); \
		fi \
	done; \
	exit $$result

.PHONY: all install test perf
