function get_path {
	regex="\/([^\/]+)$"
	if [[ ${PWD} =~ $regex ]]; then
			title $match
	fi
}

POEKS_TIME="%{$FG[027]%}%T%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[117]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$FG[117]%} %{$reset_color%}"
GIT_DIRTY_COLOR=$FG[205]
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$GIT_DIRTY_COLOR%}♺"

PROMPT='$(get_path) $POEKS_TIME %{$FG[033]%}$(rvm_prompt_info)%{$reset_color%} %{$FG[039]%}%c%{$reset_color%}$(git_prompt_info) 
$ '
