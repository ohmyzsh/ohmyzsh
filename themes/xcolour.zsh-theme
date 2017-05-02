# Matt Singleton's oh-my-zsh theme

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    svn info >/dev/null 2>/dev/null && echo 'ϟ' && return
    echo '$'
}

PROMPT='%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}
$(git_prompt_info)$(svn_prompt_info)$(prompt_char) %{$reset_color%}'
RPROMPT='%D{%r}'

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX="("
ZSH_THEME_SVN_PROMPT_SUFFIX=") "
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN="%{$fg[green]%}✔%{$reset_color%}"
