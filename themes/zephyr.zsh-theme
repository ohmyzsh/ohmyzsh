# /|/ Code by Andrew Davies:  "Zephyr"
# 
# name in folder (github).  github branch shown when in git directory, also shows `*`
# to indicate dirty repo.
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
ZEPHYR_PRE="%{$fg[white]%}"
function prompt_char {
    echo -n "%{$ZEPHYR_PRE%}"
    git branch >/dev/null 2>/dev/null && echo "╘╡%{$reset_color%}" && return
    echo "└╼%{$reset_color%}"
}
function close_git {
    git branch >/dev/null 2>/dev/null && echo "│"
}
function open_git {
    git branch >/dev/null 2>/dev/null && echo "├─┤" && return
    echo "│"
}

PROMPT='
%{$ZEPHYR_PRE%}┌┤%m├─┤%{$reset_color%}%{$fg[blue]%}$(collapse_pwd)%{$ZEPHYR_PRE%}$(open_git)%{$reset_color%}$(git_prompt_info)%{$ZEPHYR_PRE%}$(close_git)%{$reset_color%}
$(prompt_char) '
RPROMPT='%{$ZEPHYR_PRE%}%T%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$ZEPHYR_PRE%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$ZEPHYR_PRE%}%{$reset_color%}"
