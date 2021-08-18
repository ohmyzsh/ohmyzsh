export AUTOJUMP_SOURCED=1

# set user installation paths
if [[ -d ~/.autojump/bin ]]; then
    path=(~/.autojump/bin ${path})
fi
if [[ -d ~/.autojump/functions ]]; then
    fpath=(~/.autojump/functions ${fpath})
fi


# set homebrew installation paths
if command -v brew &>/dev/null; then
  local brew_prefix=${BREW_PREFIX:-$(brew --prefix)}
  if [[ -d "${brew_prefix}/share/zsh/site-functions" ]]; then
    fpath=("${brew_prefix}/share/zsh/site-functions" ${fpath})
  fi
fi


# set error file location
if [[ "$(uname)" == "Darwin" ]]; then
    export AUTOJUMP_ERROR_PATH=~/Library/autojump/errors.log
elif [[ -n "${XDG_DATA_HOME}" ]]; then
    export AUTOJUMP_ERROR_PATH="${XDG_DATA_HOME}/autojump/errors.log"
else
    export AUTOJUMP_ERROR_PATH=~/.local/share/autojump/errors.log
fi

if [[ ! -d ${AUTOJUMP_ERROR_PATH:h} ]]; then
    mkdir -p ${AUTOJUMP_ERROR_PATH:h}
fi


# change pwd hook
autojump_chpwd() {
    if [[ -f "${AUTOJUMP_ERROR_PATH}" ]]; then
        autojump --add "$(pwd)" >/dev/null 2>>${AUTOJUMP_ERROR_PATH} &!
    else
        autojump --add "$(pwd)" >/dev/null &!
    fi
}

typeset -gaU chpwd_functions
chpwd_functions+=autojump_chpwd


# default autojump command
j() {
    if [[ ${1} == -* ]] && [[ ${1} != "--" ]]; then
        autojump ${@}
        return
    fi

    setopt localoptions noautonamedirs
    local output="$(autojump ${@})"
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

    setopt localoptions noautonamedirs
    local output="$(autojump ${@})"
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
                echo "Unknown operating system: ${OSTYPE}" 1>&2
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
