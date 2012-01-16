PROMPT='${SMILEY} %{$fg[magenta]%}%n%{$reset_color%}[at]%{$fg[yellow]%}%m%{$reset_color%}%{$reset_color%} $(prompt_char) '

RPROMPT='in %{$fg[green]%}${PWD/#$HOME/~}%{$reset_color%}'

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo '○'
}


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

SMILEY="%(?,%{$fg[green]%}✔%{$reset_color%},%{$fg[red]%}✘%{$reset_color%})"