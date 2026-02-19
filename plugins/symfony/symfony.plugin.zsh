# Unified Symfony plugin for all versions
# Supports Symfony 2, 3, 4, 5, and 6+ with automatic version detection

_symfony_console_path() {
    if [[ -f "bin/console" ]]; then
        echo "bin/console"
    elif [[ -f "app/console" ]]; then
        echo "app/console"
    elif [[ -f "console" ]]; then
        echo "console"
    elif [[ -f "symfony" ]]; then
        echo "symfony"
    else
        return 1
    fi
}

_symfony_console_command() {
    local console_path
    console_path=$(_symfony_console_path)
    if [[ -n "$console_path" ]]; then
        if [[ "$console_path" == "symfony" ]]; then
            echo "php symfony"
        else
            echo "php $console_path"
        fi
    else
        return 1
    fi
}

_symfony_supports_native_completion() {
    local console_cmd
    console_cmd=$(_symfony_console_command)
    if [[ -n "$console_cmd" ]]; then
        $console_cmd _complete --no-interaction -szsh -a1 -c1 >/dev/null 2>&1
        return $?
    fi
    return 1
}

_symfony_legacy_completion() {
    local console_cmd commands
    console_cmd=$(_symfony_console_command)
    if [[ -n "$console_cmd" ]]; then
        if [[ "$console_cmd" == *"symfony"* ]]; then
            commands=$(php symfony 2>/dev/null | sed "1,/Available tasks/d" | awk 'BEGIN { cat=null; } /^[A-Za-z]+$/ { cat = $1; } /^  :[a-z]+/ { print cat $1; }')
        else
            commands=$($console_cmd --no-ansi 2>/dev/null | sed "1,/Available commands/d" | awk '/^  ?[^ ]+ / { print $1 }')
        fi
        compadd ${(f)commands}
    fi
}

_symfony_native_completion() {
    local lastParam flagPrefix requestComp out comp
    local -a completions

    words=("${=words[1,CURRENT]}") lastParam=${words[-1]}

    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    local console_cmd
    console_cmd=$(_symfony_console_command)
    if [[ -z "$console_cmd" ]]; then
        return 1
    fi

    requestComp="$console_cmd _complete --no-interaction -szsh -a1 -c$((CURRENT-1))" i=""
    for w in ${words[@]}; do
        w=$(printf -- '%b' "$w")
        quote="${w:0:1}"
        if [ "$quote" = \' ]; then
            w="${w%\'}"
            w="${w#\'}"
        elif [ "$quote" = \" ]; then
            w="${w%\"}"
            w="${w#\"}"
        fi
        if [ ! -z "$w" ]; then
            i="${i}-i${w} "
        fi
    done

    if [ "${i}" = "" ]; then
        requestComp="${requestComp} -i\" \""
    else
        requestComp="${requestComp} ${i}"
    fi

    out=$(eval ${requestComp} 2>/dev/null)

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            comp=${comp//:/\\:}
            local tab=$(printf '\t')
            comp=${comp//$tab/:}
            completions+=${comp}
        fi
    done < <(printf "%s\n" "${out[@]}")

    eval _describe "completions" completions $flagPrefix
    return $?
}

_symfony() {
    if _symfony_supports_native_completion; then
        _symfony_native_completion
    else
        _symfony_legacy_completion
    fi
}

# Aliases
alias sf='$(_symfony_console_command)'
alias sfcl='sf cache:clear'
alias sfsr='sf server:run -vvv'
alias sfcw='sf cache:warmup'
alias sfroute='sf debug:router'
alias sfcontainer='sf debug:container'
alias sfgb='sf generate:bundle'
alias sfgc='sf generate:controller'
alias sfgcom='sf generate:command'
alias sfge='sf doctrine:generate:entity'
alias sfsu='sf doctrine:schema:update'
alias sfdc='sf doctrine:database:create'
alias sfdev='sf --env=dev'
alias sfprod='sf --env=prod'

# Completions for all supported console commands
compdef _symfony sf
compdef _symfony 'php app/console'
compdef _symfony 'php bin/console'
compdef _symfony 'php console'
compdef _symfony 'php symfony'
compdef _symfony 'app/console'
compdef _symfony 'bin/console'
compdef _symfony console
