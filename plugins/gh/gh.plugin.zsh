# Autocompletion for the GitHub CLI (gh).

if (( $+commands[gh] )); then
    if [[ ! -r "$ZSH_CACHE_DIR/gh_version" \
        || "$(gh --version)" != "$(< "$ZSH_CACHE_DIR/gh_version")"
        || ! -f "$ZSH/plugins/gh/_gh" ]]; then
        mkdir -p $ZSH/plugins/gh
        gh completion --shell zsh > $ZSH/plugins/gh/_gh
        gh --version > $ZSH_CACHE_DIR/gh_version
    fi

    if ! (($fpath[(I)$ZSH/plugins/gh])); then
        # When using some package managers, such as zinit, the $ZSH/plugins/gh
        # dir is not added to fpath
        fpath+=($ZSH/plugins/gh)
    fi
fi

