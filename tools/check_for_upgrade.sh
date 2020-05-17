# Migrate .zsh-update file to $ZSH_CACHE_DIR
if [[ -f ~/.zsh-update && ! -f "${ZSH_CACHE_DIR}/.zsh-update" ]]; then
    mv ~/.zsh-update "${ZSH_CACHE_DIR}/.zsh-update"
fi

# Cancel update if:
# - the automatic update is disabled.
# - the current user doesn't have write permissions for the oh-my-zsh directory.
# - git is unavailable on the system.
if [[ "$DISABLE_AUTO_UPDATE" = true || ! -w "$ZSH" ]] || ! command -v git &>/dev/null; then
    return
fi


function current_epoch() {
    zmodload zsh/datetime
    echo $(( EPOCHSECONDS / 60 / 60 / 24 ))
}

function update_last-updated_file() {
    echo "LAST_EPOCH=$(current_epoch)" >! "${ZSH_CACHE_DIR}/.zsh-update"
}

function update_ohmyzsh() {
    ZSH="$ZSH" sh "$ZSH/tools/upgrade.sh"
    update_last-updated_file
}

() {
    emulate -L zsh

    # Remove lock directory if older than a day
    zmodload zsh/datetime
    zmodload -F zsh/stat b:zstat
    if mtime=$(zstat +mtime "$ZSH/log/update.lock" 2>/dev/null); then
        if (( (mtime + 3600 * 24) < EPOCHSECONDS )); then
            command rm -rf "$ZSH/log/update.lock"
        fi
    fi

    # Check for lock directory
    if ! command mkdir "$ZSH/log/update.lock" 2>/dev/null; then
        return
    fi

    # Remove lock directory on exit
    trap "rm -rf '$ZSH/log/update.lock'" EXIT INT QUIT

    # Create or update .zsh-update file if missing or malformed
    if ! source "${ZSH_CACHE_DIR}/.zsh-update" 2>/dev/null || [[ -z "$LAST_EPOCH" ]]; then
        update_last-updated_file
        return
    fi

    # Number of days before trying to update again
    epoch_target=${UPDATE_ZSH_DAYS:-13}
    # Test if enough time has passed until the next update
    if (( ( $(current_epoch) - $LAST_EPOCH ) < $epoch_target )); then
        return
    fi

    # Ask for confirmation before updating unless disabled
    if [[ "$DISABLE_UPDATE_PROMPT" = true ]]; then
        update_ohmyzsh
    else
        echo -n "[oh-my-zsh] Would you like to update? [Y/n] "
        read -k 1 option
        case "$option" in
            [nN]) update_last-updated_file ;;
            *) update_ohmyzsh ;;
        esac
    fi
}

unset -f current_epoch update_last-updated_file update_ohmyzsh
