# Autocompletion for the GitHub CLI (gh).

autoload -U add-zsh-hook

_gh_completion_auto_update() {
    if [[ $+commands[gh] -eq 0 \
        && ( ! -r "$ZSH_CACHE_DIR/gh_version" \
        || "$(gh --version)" != "$(< "$ZSH_CACHE_DIR/gh_version")" ) ]]; then
        mkdir -p $ZSH/plugins/gh
        gh completion --shell zsh > $ZSH/plugins/gh/_gh
        gh --version > $ZSH_CACHE_DIR/gh_version
    fi
}

PERIOD=86400 # 24h
add-zsh-hook periodic _gh_completion_auto_update

if (( $+commands[gh] )); then
    if [[ ! -f "$ZSH/plugins/gh/_gh" ]]; then
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

