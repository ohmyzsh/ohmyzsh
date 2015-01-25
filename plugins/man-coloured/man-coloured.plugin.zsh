# Authors: https://github.com/casaper
#
#### Gets less to display man pages with coloured keywords
#### for better readability.

man() {
    env LESS_TERMCAP_mb=$'\e[01;3m' \
    LESS_TERMCAP_md=$'\e[01;38;5;1m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[38;5;5m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[04;38;5;2m' \
    man "$@"
}
