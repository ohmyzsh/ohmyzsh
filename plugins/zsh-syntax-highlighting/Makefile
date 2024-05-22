NAME=zsh-syntax-highlighting

INSTALL?=install -c
PREFIX?=/usr/local
SHARE_DIR?=$(DESTDIR)$(PREFIX)/share/$(NAME)
DOC_DIR?=$(DESTDIR)$(PREFIX)/share/doc/$(NAME)
ZSH?=zsh # zsh binary to run tests with

all:
	cd docs && \
	cp highlighters.md all.md && \
	printf '\n\nIndividual highlighters documentation\n=====================================' >> all.md && \
	for doc in highlighters/*.md; do printf '\n\n'; cat "$$doc"; done >> all.md

install: all
	$(INSTALL) -d $(SHARE_DIR)
	$(INSTALL) -d $(DOC_DIR)
	cp .version zsh-syntax-highlighting.zsh $(SHARE_DIR)
	cp COPYING.md README.md changelog.md $(DOC_DIR)
	sed -e '1s/ .*//' -e '/^\[build-status-[a-z]*\]: /d' < README.md > $(DOC_DIR)/README.md
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
		for fname in "$$dirname"/*.zsh ; do [ -e "$$fname" ] && cp "$$fname" $(SHARE_DIR)"/$$dirname"; done; \
	done
	cp -R docs/* $(DOC_DIR)

clean:
	rm -f docs/all.md

test:
	@$(ZSH) -fc 'echo ZSH_PATCHLEVEL=$$ZSH_PATCHLEVEL'
	@result=0; \
	for test in highlighters/*; do \
		if [ -d $$test/test-data ]; then \
			echo "Running test $${test##*/}"; \
			env -i QUIET=$$QUIET $${TERM:+"TERM=$$TERM"} $(ZSH) -f tests/test-highlighting.zsh "$${test##*/}"; \
			: $$(( result |= $$? )); \
		fi \
	done; \
	exit $$result

quiet-test:
	$(MAKE) test QUIET=y

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

.PHONY: all install clean test perf
