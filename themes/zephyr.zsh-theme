# /|/ Code by Stephen
# /|/ "Rixius" Middleton
# 
# name in folder (github)
# ± if in github repo, or ≥ if otherwise Time in 24-hour format is on right.
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
RIXIUS_PRE="%{$fg[white]%}"
function prompt_char {
    echo -n "%{$RIXIUS_PRE%}"
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
%{$RIXIUS_PRE%}┌┤%m├─┤%{$reset_color%}%{$fg[blue]%}$(collapse_pwd)%{$RIXIUS_PRE%}$(open_git)%{$reset_color%}$(git_prompt_info)%{$RIXIUS_PRE%}$(close_git)%{$reset_color%}
$(prompt_char) '
RPROMPT='%{$RIXIUS_PRE%}%T%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$RIXIUS_PRE%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$RIXIUS_PRE%}%{$reset_color%}"
