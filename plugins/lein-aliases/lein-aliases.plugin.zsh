__LEIN_ALIASES_DIR="${0:A:h}"

function _lein_aliases() {
    local ret=1 state
    _arguments ':aliases:->aliases' && ret=0

    case $state in
      aliases)
        local LEIN_ALIASES=("${(@s:;:)$(_read_lein_aliases)}")
        _describe -t LEIN_ALIASES 'leiningen aliases' LEIN_ALIASES && ret=0
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
    _LEIN_ALIASES_STR=$(python ${lein_aliases} 2>/dev/null)
    echo $_LEIN_ALIASES_STR
}

function _include_lein_commands_if_exists() {
    if whence -w _lein_commands > /dev/null; then
      _lein_commands
    fi
}
