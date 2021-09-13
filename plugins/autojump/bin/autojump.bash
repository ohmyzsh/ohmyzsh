export AUTOJUMP_SOURCED=1

# set user installation paths
if [[ -d ~/.autojump/ ]]; then
    export PATH=~/.autojump/bin:"${PATH}"
fi


# set error file location
if [[ "$(uname)" == "Darwin" ]]; then
    export AUTOJUMP_ERROR_PATH=~/Library/autojump/errors.log
elif [[ -n "${XDG_DATA_HOME}" ]]; then
    export AUTOJUMP_ERROR_PATH="${XDG_DATA_HOME}/autojump/errors.log"
else
    export AUTOJUMP_ERROR_PATH=~/.local/share/autojump/errors.log
fi

if [[ ! -d "$(dirname ${AUTOJUMP_ERROR_PATH})" ]]; then
    mkdir -p "$(dirname ${AUTOJUMP_ERROR_PATH})"
fi


# enable tab completion
_autojump() {
        local cur
        cur=${COMP_WORDS[*]:1}
        comps=$(autojump --complete $cur)
        while read i; do
            COMPREPLY=("${COMPREPLY[@]}" "${i}")
        done <<EOF
        $comps
EOF
}
complete -F _autojump j


# change pwd hook
autojump_add_to_database() {
    if [[ -f "${AUTOJUMP_ERROR_PATH}" ]]; then
        (autojump --add "$(pwd)" >/dev/null 2>>${AUTOJUMP_ERROR_PATH} &) &>/dev/null
    else
        (autojump --add "$(pwd)" >/dev/null &) &>/dev/null
    fi
}

case $PROMPT_COMMAND in
    *autojump*)
        ;;
    *)
        PROMPT_COMMAND="${PROMPT_COMMAND:+$(echo "${PROMPT_COMMAND}" | awk '{gsub(/; *$/,"")}1') ; }autojump_add_to_database"
        ;;
esac


# default autojump command
j() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
        autojump ${@}
        return
    fi

    output="$(autojump ${@})"
    if [[ -d "${output}" ]]; then
        if [ -t 1 ]; then  # if stdout is a terminal, use colors
                echo -e "\\033[31m${output}\\033[0m"
        else
                echo -e "${output}"
        fi
        cd "${output}"
    else
        echo "autojump: directory '${@}' not found"
        echo "\n${output}\n"
        echo "Try \`autojump --help\` for more information."
        false
    fi
}


# jump to child directory (subdirectory of current path)
jc() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
        autojump ${@}
        return
    else
        j $(pwd) ${@}
    fi
}


# open autojump results in file browser
jo() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
        autojump ${@}
        return
    fi

    output="$(autojump ${@})"
    if [[ -d "${output}" ]]; then
        case ${OSTYPE} in
            linux*)
                xdg-open "${output}"
                ;;
            darwin*)
                open "${output}"
                ;;
            cygwin)
                cygstart "" $(cygpath -w -a ${output})
                ;;
            *)
                echo "Unknown operating system: ${OSTYPE}." 1>&2
                ;;
        esac
    else
        echo "autojump: directory '${@}' not found"
        echo "\n${output}\n"
        echo "Try \`autojump --help\` for more information."
        false
    fi
}


# open autojump results (child directory) in file browser
jco() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
        autojump ${@}
        return
    else
        jo $(pwd) ${@}
    fi
}
