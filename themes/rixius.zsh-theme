# name in folder (github)
# ± if in github repo, or ≥ if otherwise Time in 24-hour format is on right.
function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
function prompt_char {
    echo -n "%{$bg[white]%}%{$fg[red]%}"
    git branch >/dev/null 2>/dev/null && echo "±%{$reset_color%}" && return
    echo "≥%{$reset_color%}"
}
RIXIUS_PRE="%{$bg[white]%}%{$fg[red]%}"

PROMPT='
%{$RIXIUS_PRE%}%n%{$reset_color%} in %{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(git_prompt_info)
$(prompt_char) '
RPROMPT='%{$RIXIUS_PRE%}%T%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RIXIUS_PRE%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$RIXIUS_PRE%}√%{$reset_color%}"
