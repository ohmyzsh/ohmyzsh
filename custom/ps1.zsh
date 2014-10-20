function short_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}
function prompt_sym {
    git branch >/dev/null 2>/dev/null && echo '±' && return
    echo '○'
}

#setopt promptsubst

### The Left Prompt
# Modify the colors and symbols in these variables as desired.
GIT_PROMPT_SYMBOL="%{$fg[blue]%}±"
GIT_PROMPT_PREFIX="%{$fg[green]%} [%{$reset_color%}"
GIT_PROMPT_SUFFIX="%{$fg[green]%}]%{$reset_color%}"
GIT_PROMPT_AHEAD="%{$fg[red]%}ANUM%{$reset_color%}"
GIT_PROMPT_BEHIND="%{$fg[cyan]%}BNUM%{$reset_color%}"
GIT_PROMPT_MERGING="%{$fg_bold[magenta]%}⚡︎%{$reset_color%}"
GIT_PROMPT_UNTRACKED="%{$fg_bold[red]%}u%{$reset_color%}"
GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%}d%{$reset_color%}"
GIT_PROMPT_STAGED="%{$fg_bold[green]%}s%{$reset_color%}"

PROMPT='${ret_status} %{$fg[red]%}%n%{$reset_color%} %{$fg[cyan]%}$(short_pwd)%{$reset_color%}%{$reset_color%}$(git_prompt_info)
$(prompt_sym) '

### The right prompt 
RPROMPT='%{$fg_bold[yellow]%}($(rvm-prompt i v g))%{$reset_color%} $(battery_pct_prompt)$(battery_level_gauge)'

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""
