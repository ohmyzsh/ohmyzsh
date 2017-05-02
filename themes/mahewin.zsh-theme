PROMPT='%{$fg_bold[blue]%}%n%{$reset_color%}%{$fg_bold[magenta]%}@%{$reset_color%}%{$fg_bold[yellow]%}%M  %{$reset_color%}$(perlbrew_set) %{$fg_bold[white]%}♜
\
%{$fg_no_bold[blue]%}%~%{$reset_color%}$(git_prompt_info) $(git_prompt_status) %{$reset_color%}'
RPROMPT='[%{$fg_no_bold[blue]%}%t%{$reset_color%} %{$fg_no_bold[yellow]%}%D%{$reset_color%}]'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[yellow]%}☁%{$reset_color%} %{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ±"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ☀"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✚" #
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ⚡"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖" #
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ♒"



function perlbrew_set() {
    which_perlbrew=$(which perlbrew)
    if [[ "$which_perlbrew" != "perlbrew not found" ]];
    then
        PERLBREW=`perlbrew list | grep '*' | cut -b3-`
    fi
    if [[ -n $PERLBREW ]]; then
        echo "%{$fg_bold[cyan]%}$PERLBREW%{$reset_color%}"
fi
}

