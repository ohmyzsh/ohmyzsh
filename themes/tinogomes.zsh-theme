# tinogomes theme: based over dst

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function prompt_char {
    if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

#RVM settings
local RVM_PROMPT=''

if [[ -s ~/.rvm/scripts/rvm ]] ; then
    RVM_PROMPT='%{$fg[cyan]%}$(rvm_prompt_info)%{$reset_color%}'
fi

PROMPT='
%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%} '$RVM_PROMPT' $(git_prompt_info)
%_$(prompt_char) '
