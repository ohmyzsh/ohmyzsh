# ----------------------------------------------------------------
# Description
# -----------
# An Oh My Zsh plugin for GPG encrypted, Internet synchronized Zsh
# history using Git.
#
# ----------------------------------------------------------------
# Authors
# -------
#
# * James Fraser <wulfgar.pro@gmail.com>
#   https://www.wulfgar.pro
# ----------------------------------------------------------------
#
autoload -U colors && colors

alias zhpl=history_sync_pull
alias zhps=history_sync_push
alias zhsync="history_sync_pull && history_sync_push"

GIT=$(which git)
GPG=$(which gpg)

ZSH_HISTORY_PROJ="${ZSH_HISTORY_PROJ:-${HOME}/.zsh_history_proj}"
ZSH_HISTORY_FILE_NAME="${ZSH_HISTORY_FILE_NAME:-.zsh_history}"
ZSH_HISTORY_FILE="${ZSH_HISTORY_FILE:-${HOME}/${ZSH_HISTORY_FILE_NAME}}"
ZSH_HISTORY_FILE_ENC_NAME="${ZSH_HISTORY_FILE_ENC_NAME:-zsh_history}"
ZSH_HISTORY_FILE_ENC="${ZSH_HISTORY_FILE_ENC:-${ZSH_HISTORY_PROJ}/${ZSH_HISTORY_FILE_ENC_NAME}}"
ZSH_HISTORY_FILE_DECRYPT_NAME="${ZSH_HISTORY_FILE_DECRYPT_NAME:-zsh_history_decrypted}"
ZSH_HISTORY_FILE_MERGED_NAME="${ZSH_HISTORY_FILE_MERGED_NAME:-zsh_history_merged}"
ZSH_HISTORY_COMMIT_MSG="${ZSH_HISTORY_COMMIT_MSG:-latest $(date)}"

function _print_git_error_msg() {
    echo "$bold_color${fg[red]}There's a problem with git repository: ${ZSH_HISTORY_PROJ}.$reset_color"
    return
}

function _print_gpg_encrypt_error_msg() {
    echo "$bold_color${fg[red]}GPG failed to encrypt history file.$reset_color"
    return
}

function _print_gpg_decrypt_error_msg() {
    echo "$bold_color${fg[red]}GPG failed to decrypt history file.$reset_color"
    return
}

function _usage() {
    echo "Usage: [ [-r <string> ...] [-y] ]" 1>&2
    echo
    echo "Optional args:"
    echo
    echo "      -r receipients"
    echo "      -y force"
    return
}

# "Squash" each multi-line command in the passed history files to one line
function _squash_multiline_commands_in_files() {
    # Create temporary files
    # Use global variables to use same path's in the restore-multi-line commands
    # function
    TMP_FILE_1=$(mktemp)
    TMP_FILE_2=$(mktemp)

    # Generate random character sequences to replace \n and anchor the first
    # line of a command (use global variable for new-line-replacement to use it
    # in the restore-multi-line commands function)
    NL_REPLACEMENT=$(tr -dc 'a-zA-Z0-9' < /dev/urandom |
        fold -w 32 | head -n 1)
    local FIRST_LINE_ANCHOR=$(tr -dc 'a-zA-Z0-9' < /dev/urandom |
        fold -w 32 | head -n 1)

    for i in "$ZSH_HISTORY_FILE" "$ZSH_HISTORY_FILE_DECRYPT_NAME"; do
        # Filter out multi-line commands and save them to a separate file
        grep -v -B 1 '^: [0-9]\{1,10\}:[0-9]\+;' "${i}" |
            grep -v -e '^--$' > "${TMP_FILE_1}"

        # Filter out multi-line commands and remove them from the original file
        grep -v -x -F -f "${TMP_FILE_1}" "${i}" > "${TMP_FILE_2}" \
            && mv "${TMP_FILE_2}" "${i}"

        # Add anchor before the first line of each command
        sed "s/\(^: [0-9]\{1,10\}:[0-9]\+;\)/${FIRST_LINE_ANCHOR} \1/" \
            "${TMP_FILE_1}" > "${TMP_FILE_2}" \
            && mv "${TMP_FILE_2}" "${TMP_FILE_1}"

        # Replace all \n with a sequence of symbols
        sed ':a;N;$!ba;s/\n/'" ${NL_REPLACEMENT} "'/g' \
            "${TMP_FILE_1}" > "${TMP_FILE_2}" \
            && mv "${TMP_FILE_2}" "${TMP_FILE_1}"

        # Replace first line anchor by \n
        sed "s/${FIRST_LINE_ANCHOR} \(: [0-9]\{1,10\}:[0-9]\+;\)/\n\1/g" \
            "${TMP_FILE_1}" > "${TMP_FILE_2}" \
            && mv "${TMP_FILE_2}" "${TMP_FILE_1}"

        # Merge squashed multiline commands to the history file
        cat "${TMP_FILE_1}" >> "${i}"

        # Sort history file
        sort -n < "${i}" > "${TMP_FILE_1}" && mv "${TMP_FILE_1}" "${i}"
    done
}

# Restore multi-line commands in the history file
function _restore_multiline_commands_in_file() {
    # Filter unnecessary lines from the history file (Binary file ... matches)
    # and save them in a separate file
    grep -v '^: [0-9]\{1,10\}:[0-9]\+;' "$ZSH_HISTORY_FILE" > "${TMP_FILE_1}"

    # Filter out unnecessary lines and remove them from the original file
    grep -v -x -F -f "${TMP_FILE_1}" "$ZSH_HISTORY_FILE" > "${TMP_FILE_2}" && \
        mv "${TMP_FILE_2}" "$ZSH_HISTORY_FILE"

    # Replace the sequence of symbols by \n to restore multi-line commands
    sed "s/ ${NL_REPLACEMENT} /\n/g" "$ZSH_HISTORY_FILE" > "${TMP_FILE_1}" \
        && mv "${TMP_FILE_1}" "$ZSH_HISTORY_FILE"

    # Unset global variables
    unset NL_REPLACEMENT TMP_FILE_1 TMP_FILE_2
}

# Pull current master, decrypt, and merge with .zsh_history
function history_sync_pull() {
    # Get options force
    local force=false
    while getopts y opt; do
        case "$opt" in
            y)
                force=true
                ;;
        esac
    done
    DIR=$(pwd)

    # Backup
    if [[ $force = false ]]; then
        cp -av "$ZSH_HISTORY_FILE" "$ZSH_HISTORY_FILE.backup" 1>&2
    fi

    # Pull
    cd "$ZSH_HISTORY_PROJ" && "$GIT" pull
    if [[ "$?" != 0 ]]; then
        _print_git_error_msg
        cd "$DIR"
        return
    fi

    # Decrypt
    "$GPG" --output "$ZSH_HISTORY_FILE_DECRYPT_NAME" --decrypt "$ZSH_HISTORY_FILE_ENC"
    if [[ "$?" != 0 ]]; then
        _print_gpg_decrypt_error_msg
        cd "$DIR"
        return
    fi

    # Check if EXTENDED_HISTORY is enabled, and if so, "squash" each multi-line
    # command in local and decrypted history files to one line
    [[ -o extendedhistory ]] && _squash_multiline_commands_in_files

    # Merge
    cat "$ZSH_HISTORY_FILE" "$ZSH_HISTORY_FILE_DECRYPT_NAME" | awk '/:[0-9]/ { if(s) { print s } s=$0 } !/:[0-9]/ { s=s"\n"$0 } END { print s }' | LC_ALL=C sort -u > "$ZSH_HISTORY_FILE_MERGED_NAME"
    mv "$ZSH_HISTORY_FILE_MERGED_NAME" "$ZSH_HISTORY_FILE"
    rm  "$ZSH_HISTORY_FILE_DECRYPT_NAME"
    cd  "$DIR"

    # Check if EXTENDED_HISTORY is enabled, and if so, restore multi-line
    # commands in the local history file
    [[ -o extendedhistory ]] && _restore_multiline_commands_in_file
    sed -i '/^$/d' "$ZSH_HISTORY_FILE"
}

# Encrypt and push current history to master
function history_sync_push() {
    # Get options recipients, force
    local recipients=()
    local signers=()
    local force=false
    while getopts r:s:y opt; do
        case "$opt" in
            r)
                recipients+="$OPTARG"
                ;;
            s)
                signers+="$OPTARG"
                ;;
            y)
                force=true
                ;;
            *)
                _usage
                return
                ;;
        esac
    done

    # Encrypt
    if ! [[ "${#recipients[@]}" > 0 ]]; then
        echo -n "Please enter GPG recipient name: "
        read name
        recipients+="$name"
    fi

    ENCRYPT_CMD="$GPG --yes -v "
    for r in "${recipients[@]}"; do
        ENCRYPT_CMD+="-r \"$r\" "
    done
    if [[ "${#signers[@]}" > 0 ]]; then
        ENCRYPT_CMD+="--sign "
        for s in "${signers[@]}"; do
            ENCRYPT_CMD+="--default-key \"$s\" "
        done
    fi

    if [[ "$ENCRYPT_CMD" != *"--sign"* ]]; then
        if [[ $force = false ]]; then
            echo -n "$bold_color${fg[yellow]}Do you want to sign with first key found in secret keyring (y/N)?$reset_color "
            read sign
        else
            sign='y'
        fi

        case "$sign" in
            [Yy]* )
                    ENCRYPT_CMD+="--sign "
                    ;;
                * )
                    ;;
        esac
    fi

    if [[ "$ENCRYPT_CMD" =~ '.(-r).+.' ]]; then
        ENCRYPT_CMD+="--encrypt --armor --output $ZSH_HISTORY_FILE_ENC $ZSH_HISTORY_FILE"
        eval "$ENCRYPT_CMD"
        if [[ "$?" != 0 ]]; then
            _print_gpg_encrypt_error_msg
            return
        fi

        # Commit
        if [[ $force = false ]]; then
            echo -n "$bold_color${fg[yellow]}Do you want to commit current local history file (y/N)?$reset_color "
            read commit
        else
            commit='y'
        fi

        if [[ -n "$commit" ]]; then
            case "$commit" in
                [Yy]* )
                    DIR=$(pwd)
                    cd "$ZSH_HISTORY_PROJ" && "$GIT" add * && "$GIT" commit -m "$ZSH_HISTORY_COMMIT_MSG"

                    if [[ $force = false ]]; then
                        echo -n "$bold_color${fg[yellow]}Do you want to push to remote (y/N)?$reset_color "
                        read push
                    else
                        push='y'
                    fi

                    if [[ -n "$push" ]]; then
                        case "$push" in
                            [Yy]* )
                                "$GIT" push
                                if [[ "$?" != 0 ]]; then
                                    _print_git_error_msg
                                    cd "$DIR"
                                    return
                                fi
                                cd "$DIR"
                                ;;
                        esac
                    fi

                    if [[ "$?" != 0 ]]; then
                        _print_git_error_msg
                        cd "$DIR"
                        return
                    fi
                    ;;
                * )
                    ;;
            esac
        fi
    fi
}
