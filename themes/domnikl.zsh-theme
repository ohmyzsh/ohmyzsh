# Hey ho - let's go!

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"

# am I root? show me!
IAM=""
if [ "$UID" = "0" ]; then
	IAM="%{$fg[red]%}root|%{$reset_color%}"
fi

PROMPT='$IAM%{$fg[cyan]%}%1~%{$reset_color%}%{$fg[red]%}|%{$reset_color%}$(git_prompt_info)%{$fg[cyan]%}⇒%{$reset_color%} '

# ls colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS='Gxdxhxhxbxegedabagacad'
