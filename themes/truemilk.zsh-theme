if [ $UID -eq 0 ];
	then NCOLOR="red";
else
	NCOLOR="green";
fi

local return_code="%(?..%{$fg[red]%}<%?>%{$reset_color%})"

PROMPT='%{$terminfo[bold]$fg[$NCOLOR]%}%n%{$reset_color%} %{$terminfo[bold]$fg[blue]%}%~%{$reset_color%} $ '
RPROMPT='${return_code} %{$fg[yellow]%}$(git_prompt_info)%{$reset_color%} <$(~/.rvm/bin/rvm-prompt i v g)>'

ZSH_THEME_GIT_PROMPT_PREFIX="<git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=">"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
