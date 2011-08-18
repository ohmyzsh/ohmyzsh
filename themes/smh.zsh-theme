
ZSH_THEME_GIT_PROMPT_PREFIX="|%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""

function smh_rvm_info {
  echo "%{$fg[magenta]%}$(rvm_prompt_info)%{$reset_color%}"
}

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL%{$reset_color%}
)
%{$fg[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%} [$(smh_rvm_info)$(git_prompt_info)]
%_ $(prompt_char) '

RPROMPT='%{$fg[green]%}[%*]%{$reset_color%}'

