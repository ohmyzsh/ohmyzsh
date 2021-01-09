# Autocompletion for the GitHub CLI (gh).

autoload -U add-zsh-hook

_gh_completion_auto_update() {
    if [[ $+commands[gh] -eq 0 \
        && ( ! -r "$ZSH_CACHE_DIR/gh_version" \
        || "$(gh --version)" != "$(< "$ZSH_CACHE_DIR/gh_version")" ) ]]; then
        mkdir -p $ZSH/completions
        gh completion --shell zsh > $ZSH/completions/_gh
        gh --version > $ZSH_CACHE_DIR/gh_version
    fi
}

PERIOD=86400 # 24h
add-zsh-hook periodic _gh_completion_auto_update

if (( $+commands[gh] )); then
    if [[ ! -f "$ZSH/completions/_gh" ]]; then
        mkdir -p $ZSH/completions
        gh completion --shell zsh > $ZSH/completions/_gh
        gh --version > $ZSH_CACHE_DIR/gh_version
    fi

    if ! (($fpath[(I)$ZSH/completions])); then
        # When using some package managers, such as zinit, the $ZSH/completions
        # dir is not added to fpath
        fpath+=($ZSH/completions)
    fi
fi

