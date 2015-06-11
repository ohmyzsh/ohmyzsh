ZSH_THEME_GIT_PROMPT_PREFIX=" [ Git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""
local ret_status="%(?:%{$fg_bold[green]%}» %{$reset_color%}:%{$fg_bold[red]%}» %{$reset_color%}"
local face_status="%(?:%{$fg_bold[green]%}ヾ(●´∀｀*)ノ :%{$fg_bold[red]%}Σ( ° Д °||%)︴)"
 
function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}
 
PROMPT='%(?,,%{$fg[red]%}FAIL : $?%{$reset_color%})
《 %{$fg_bold[blue]%}%~%{$reset_color%} 》%{$fg[magenta]%}%n%{$reset_color%} @ %{$fg[yellow]%}%m%{$reset_color%}$(git_prompt_info)
%_$(prompt_char)${ret_status}'
 
RPROMPT='${face_status}%{$reset_color%}[%*]'
