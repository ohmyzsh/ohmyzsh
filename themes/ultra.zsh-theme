function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '○'
}

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

PROMPT='%{$fg[blue]%}✿ %{$reset_color%}[%m]-[${PWD/#$HOME/~}] $(prompt_char) %{$reset_color%}$(git_prompt_info) %{$fg[green]%}➜ %{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="|%{$fg[green]%}"

ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}|"

ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}[✹]%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}(⦿)%{$reset_color%}"
