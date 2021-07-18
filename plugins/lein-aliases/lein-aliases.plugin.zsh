__LEIN_ALIASES_DIR="${0:A:h}"

function _lein_aliases() {
    unset _LEIN_ALIASES_STR
    unset _LEIN_ALIASES

    local ret=1 state
    _arguments ':aliases:->aliases' && ret=0

    case $state in
      aliases)
        _LEIN_ALIASES_STR=$(_read_lein_aliases)
        _LEIN_ALIASES=("${(@s:;:)${_LEIN_ALIASES_STR}}")
        _describe -t _LEIN_ALIASES 'leiningen aliases' _LEIN_ALIASES && ret=0
        _include_lein_commands_if_exists
        ;;
      *) _files
    esac

    return ret
}

compdef _lein_aliases lein

function _read_lein_aliases() {
    unset __LEIN_ALIASES_STR

    local lein_aliases="$__LEIN_ALIASES_DIR/lein-aliases.py"
    __LEIN_ALIASES_STR=$(python ${lein_aliases} 2>/dev/null)
    echo $__LEIN_ALIASES_STR
}

function _include_lein_commands_if_exists() {
    if whence -w _lein > /dev/null; then
      _lein
    fi
}
