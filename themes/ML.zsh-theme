
ML_COLOR_BLUE=$'%{\e[1;34m%}'
ML_COLOR_GREEN=$'%{\e[1;32m%}'
ML_COLOR_GREY=$'%{\e[1;30m%}'
ML_COLOR_CYAN=$'%{\e[0;36m%}'
ML_COLOR_YELLOW=$'%{\e[0;33m%}'
ML_COLOR_WHITE=$'%{\e[0;37m%}'
ML_COLOR_RED=$'%{\e[1;31m%}'
ML_COLOR_PINK=$'%{\e[1;35m%}'
ML_COLOR_END=$'%b'

ML_SYMBOL_START="${ML_COLOR_BLUE}[${MY_COLOR_END}"
ML_SYMBOL_END="${ML_COLOR_BLUE}]${MY_COLOR_END}"

ML_SYSTEM="\
${ML_SYMBOL_START}\
${ML_COLOR_GREEN}%n\
${ML_COLOR_GREY}@\
${ML_COLOR_CYAN}%m\
${ML_SYMBOL_END}\
"

ML_PATH="\
${ML_SYMBOL_START}\
${ML_COLOR_WHITE}%~\
${ML_SYMBOL_END}\
"

ML_TIME="\
${ML_SYMBOL_START}\
${ML_COLOR_YELLOW}%D{%a %b %d,%H:%M}\
${ML_SYMBOL_END}\
"

function ML_VCS() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        if [[ -z $(git_prompt_info) ]]; then
            echo "%{$fg[magenta]%}detached-head%{$reset_color%})"
        else
            echo "${ML_SYMBOL_START}${ML_COLOR_PINK}$(git_prompt_info)${ML_COLOR_END}${ML_SYMBOL_END}"
        fi
    fi
}


PROMPT=$'${ML_COLOR_BLUE}┌─${ML_SYSTEM}${ML_PATH}$(ML_VCS)${ML_TIME}
${ML_COLOR_BLUE}└─${ML_SYMBOL_START}${ML_COLOR_RED}$%b${ML_SYMBOL_END}%b '

PS2=$' \e[0;34m%}%B>%{\e[0m%}%b '
