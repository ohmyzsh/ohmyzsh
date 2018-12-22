# https://github.com/robbyrussell/oh-my-zsh/wiki/themes
# based on nerbirhos theme and default kali linux bash
# choose between # and $
function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

# choose color of user@host
local user_color='green'; [ $UID -eq 0 ] && user_color='red'

#HOST_PROMPT_="%{$fg_bold[$user_color]%}$USER@$HOST%{$reset_color%}%{$fg[white]%}:%{$fg_bold[blue]%}%~"

#GIT_PROMPT="%{$fg_bold[cyan]%}\$(git_prompt_info)%{$fg_bold[cyan]%} % %{$reset_color%}"

# end with # or $
#CHAR_PROMPT="%{$fg[white]%}$(prompt_char)%{$reset_color%} "

#PROMPT="$HOST_PROMPT_$GIT_PROMPT_$CHAR_PROMPT"
PROMPT="%{$fg_bold[$user_color]%}$USER@$HOST%{$reset_color%}%{$fg[white]%}:%{$fg_bold[blue]%}%~%{$fg_bold[cyan]%}\$(git_prompt_info)%{$fg_bold[cyan]%}%{$reset_color%}%{$fg_bold[white]%}$(prompt_char)%{$reset_color%} "


ZSH_THEME_GIT_PROMPT_PREFIX=" git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%})%{$fg_bold[red]%}✗%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})%{$fg_bold[green]%}✔%{$reset_color%} "
