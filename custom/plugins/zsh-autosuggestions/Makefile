SRC_DIR    := ./src

SRC_FILES := \
	$(SRC_DIR)/config.zsh \
	$(SRC_DIR)/util.zsh \
	$(SRC_DIR)/bind.zsh \
	$(SRC_DIR)/highlight.zsh \
	$(SRC_DIR)/widgets.zsh \
	$(SRC_DIR)/strategies/*.zsh \
	$(SRC_DIR)/fetch.zsh \
	$(SRC_DIR)/async.zsh \
	$(SRC_DIR)/start.zsh

HEADER_FILES := \
	DESCRIPTION \
	URL \
	VERSION \
	LICENSE

PLUGIN_TARGET := zsh-autosuggestions.zsh

all: $(PLUGIN_TARGET)

$(PLUGIN_TARGET): $(HEADER_FILES) $(SRC_FILES)
	cat $(HEADER_FILES) | sed -e 's/^/# /g' > $@
	cat $(SRC_FILES) >> $@

.PHONY: clean
clean:
	rm $(PLUGIN_TARGET)

.PHONY: test
test: all
	@test -n "$$TEST_ZSH_BIN" && echo "Testing zsh binary: $(TEST_ZSH_BIN)" || true
	bundle exec rspec $(TESTS)
