#!/bin/zsh
# Toggles the buffer between natural language and shell command.
_englizsh_toggle() {
    # The text in the terminal is stored in BUFFER.
    # If it is empty, then use the last executed command.
    [[ -z $BUFFER ]] && BUFFER=$(fc -ln -1)

    # Cache the answers when toggling (optimization). If the keybinding
    # is pressed twice, then the first answer would already be stored.
    if [[ $BUFFER == $_englizsh_penult_cmd ]]; then
        # Swap the buffer and the previous cached result. Then store
        # the command that is being translated.
        tmp=$BUFFER
        BUFFER=$_englizsh_prev_cmd
        _englizsh_penult_cmd=$_englizsh_prev_cmd
        _englizsh_prev_cmd=$tmp
    else
        # If there is a mismatch (text changed between toggles), then the
        # result must be recalculated.
        _englizsh_prev_cmd=$BUFFER
        BUFFER="$BUFFER ⌛"
        zle redisplay
        BUFFER=$(_englizsh_translate_buffer "$_englizsh_prev_cmd" $1)
        _englizsh_penult_cmd=$BUFFER
    fi
    # Move cursor to end of line.
    zle end-of-line
}

# Explicitly translate the buffer from natural language to shell command.
# Useful when the first word of the query is a shell command, e.g. "ls -al with color"
# Wrapper function for _english_toggle (because bindkey cannot pass parameters).
_englizsh_toggle_nl() {
    _englizsh_toggle --toggle-nl
}

# Decides whether the input string is shell command or natural language, 
# then translates it to the other one using the command in either 
# 'SHELL_TO_ENGLISH_CMD' or 'ENGLISH_TO_SHELL_CMD'.
_englizsh_translate_buffer() {
    # If no override flag is given and the first word is a command, then it is a command.
    if [[ -z $2 ]] && command -v ${1%% *} > /dev/null; then
        eval "$SHELL_TO_ENGLISH_CMD <<< \"$1\""
    else
        eval "$ENGLISH_TO_SHELL_CMD <<< \"$1\""
    fi
}

# Overrides the function that executes when a command is not found.
# First, decide if the incorrect command is natural language. If it is, 
# then translate to shell. If the translated command is destructive,
# then prompt before executing. Otherwise, directly execute.
command_not_found_handler() {
    # Determines if the command is actually just shell by two conditions:
    # 1. The first letter of the first word of the command is lowercased, and
    # 2. The number of words is below some arbitrary threshold, because natural
    #    language is much more verbose.
    local nl_word_count_threshold=6
    if [[ ${1:0:1} = [[:lower:]] && $(wc -w <<< "$@") -lt $nl_word_count_threshold ]]
    then
        # No need to translate, so return the exit code of the previous command
        echo "command not found: $@"
        return 1
    fi

    # Convert the natural language to shell
    printf '⌛'
    local converted_command=$(eval "$ENGLISH_TO_SHELL_CMD <<< \"$@\"")
    printf "\r"

    # If it's destructive, then prompt for confirmation.
    if ! _englizsh_handle_destructive_command "$converted_command"; then
        return 1
    fi

    # Execute the translated command.
    eval "$converted_command"
}

# Explicitly translate buffer from natural language and execute the command
# First handle destructive commands, then execute the command, and add the
# natural language to history.
_englizsh_override_enter() {
    local old_buffer=$BUFFER
    BUFFER="$BUFFER ⌛"
    zle -I && zle redisplay
    local converted_command=$(eval "$ENGLISH_TO_SHELL_CMD <<< \"$old_buffer\"")
    BUFFER="$old_buffer"
    zle redisplay
    zle -I
    if ! _englizsh_handle_destructive_command "$converted_command"; then
        BUFFER=''
        return 1
    fi

    # Execute the translated command, add the natural language 
    # to history, and clear the buffer
    eval "$converted_command"
    print -s "$old_buffer"
    BUFFER=''
}

# Prompts the user for confirmation if the command is destructive.
# If the command is not destructive or the user confirms, then return 0.
# Otherwise, return 1.
_englizsh_handle_destructive_command() {
    local config_options=($ENGLIZSH_SAFE_CMD_NO_CONFIRM $ENGLIZSH_DEFAULT_EXECUTE)
    local confirm_string=$(
        [[ $config_options[2] == true ]] && echo 'Y/n' || echo 'y/N'
    )

    # If the command is destructive, then prompt for confirmation
    if _englizsh_is_destructive_command "$1"; then
        # Then prompt for confirmation
        echo -e "\033[1;31m${1}\033[0m" # Print the command in red
        echo -e "Execute \033[1mdestructive\033[0m shell command? [$confirm_string]:"
        read confirmation < /dev/tty
        # If user types enter or a word starting with n or N, then exit unsuccessfully
        if [[ ($config_options[2] != true \
            && -z $confirmation) || ${confirmation:0:1} == [nN] ]]; then
            return 1
        fi
    elif [[ $config_options[1] != true ]]; then
        # If the command is not destructive, then prompt for confirmation only if the
        # no-confirm configuration is not set to true.
        echo $1 # Print the command in green
        echo "Execute shell command? [$confirm_string]:"
        read confirmation < /dev/tty
        if [[ ($config_options[2] != true \
            && -z $confirmation) || ${confirmation:0:1} == [nN] ]]; then
            return 1
        fi
    fi
}

# Decides whether or not a given command mutates the system.
# Returns 0 if destructive, 1 if safe.
_englizsh_is_destructive_command() {
    local destructive_commands=(sudo rm mv cp dd chown chmod fdisk git modprobe mkfs mkswap)

    declare -A safe_flags_for_destructive_commands=(
        [rm]='-i --interactive --help --version'
        [mv]='-i --interactive -n --no-clobber --help --version'
        [cp]='-n --no-clobber --help --version'
        [git]='status log diff show fetch ls-files -h -v --help --version'
    )

    declare -A destructive_flags_for_safe_commands=(
        [sed]='-i --in-place'
        [find]='-delete'
    )

    local command_name=${1%% *}
   
    # If the command is destructive
    if [[ "$destructive_commands[@]" == *"$command_name"* ]]; then
        # If the command has a flag that makes it safe, then return 1
        for flag in $(echo $safe_flags_for_destructive_commands[$command_name]); do
            [[ "$1" == *"$flag"* ]] && return 1
        done
        return 0
    else
        for flag in $(echo $destructive_flags_for_safe_commands[$command_name]); do
            [[ "$1" == *"$flag"*  ]] && return 0
        done
        return 1
    fi
}

# Set default value for environmental configuration variables
[[ -z "$ENGLISH_TO_SHELL_CMD" ]] && ENGLISH_TO_SHELL_CMD='sgpt -s'
[[ -z "$SHELL_TO_ENGLISH_CMD" ]] && SHELL_TO_ENGLISH_CMD='sgpt -d'
[[ -z "$TOGGLE_BUFFER_KEYBINDING" ]] && TOGGLE_BUFFER_KEYBINDING='^@'
[[ -z "$TOGGLE_ENGLISH_KEYBINDING" ]] && TOGGLE_ENGLISH_KEYBINDING=' '
[[ -z "$EXECUTE_ENGLISH_KEYBINDING" ]] && EXECUTE_ENGLISH_KEYBINDING='[27;5;13~'
[[ -z "$ENGLIZSH_SAFE_CMD_NO_CONFIRM" ]] && ENGLIZSH_SAFE_CMD_NO_CONFIRM='false'
[[ -z "$ENGLIZSH_DEFAULT_EXECUTE" ]] && ENGLIZSH_DEFAULT_EXECUTE='false'

# Create zle widget for functions, then set keybinding
zle -N _englizsh_toggle
zle -N _englizsh_toggle_nl
zle -N _englizsh_override_enter
bindkey $TOGGLE_BUFFER_KEYBINDING _englizsh_toggle
bindkey $TOGGLE_ENGLISH_KEYBINDING _englizsh_toggle_nl
bindkey $EXECUTE_ENGLISH_KEYBINDING _englizsh_override_enter
