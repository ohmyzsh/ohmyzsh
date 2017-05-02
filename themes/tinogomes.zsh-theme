# tinogomes theme: Inspired over dst theme

# This theme shows rvm_prompt and git_prompt or hg_prompt.

# Format:
# <login>@<host>:<pwd> <rvm_prompt> <git_prompt><hg_prompt>
# $ _


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[green]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[green]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function prompt_char {
    if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

function prompt_hg_info {
	hg branch >/dev/null 2>/dev/null && echo " %{$fg[green]%}($(hg branch))%{$reset_color%}" && return
	echo ""
}

#RVM settings
local RVM_PROMPT=''

if [[ -s ~/.rvm/scripts/rvm ]] ; then
    RVM_PROMPT='%{$fg[cyan]%}$(rvm_prompt_info)%{$reset_color%}'
fi

PROMPT='
%{$fg[yellow]%}%n%{$reset_color%}@%{$fg[cyan]%}%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%} '$RVM_PROMPT'$(git_prompt_info)$(prompt_hg_info)
%_$(prompt_char) '
