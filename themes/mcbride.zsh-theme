function dirStack(){
	OUT='';
	NUM=1;
	for X in $(dirs | cut -d ' ' -f2-10); do
		OUT="$OUT$1%B$NUM:%b$1$X ";
		(( NUM=NUM+1 ))
	done
	echo $OUT;
}

ZSH_THEME_GIT_PROMPT_ADDED=""
ZSH_THEME_GIT_PROMPT_MODIFIED=""
ZSH_THEME_GIT_PROMPT_DELETED=""
ZSH_THEME_GIT_PROMPT_RENAMED=""
ZSH_THEME_GIT_PROMPT_UNMERGED=""
ZSH_THEME_GIT_PROMPT_UNTRACKED=""

ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[yellow]%}↑"
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[green]%}✔"

local user_color='blue'
local back="${BG[237]}"
test $UID -eq 0 && user_color='red'

PROMPT='$(dirStack %{$back%})
%{$back%}%B%!%b%{$back%} %{$fg_bold[$user_color]%}%~%{$reset_color%}'\
'%{$back%} $(git_prompt_status)%{$reset_color%}'\
'%{$back%}%{$fg_bold[magenta]%}$(git_prompt_info)%{$reset_color%}'\
'%{$back%}$(git_prompt_ahead)%{$reset_color%}'\
'%{$back%}%(!.#.>)%{$reset_color%} '

PROMPT2='%{$fg[red]%}%_ %{$reset_color%}'
PROMPT3='%{$fg[red]%}... %{$reset_color%}'
RPROMPT='%(?..%{$fg_bold[red]%}exit %?%{$reset_color%})'\
' %{$FG[186]%}(%D %*)%{$reset_color%}'
