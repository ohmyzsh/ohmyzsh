if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi

local return_code="%(?..%{$fg[red]%}<%?>%{$reset_color%})"

PROMPT='%{$terminfo[bold]$fg[$NCOLOR]%}%n%{$reset_color%} %{$terminfo[bold]$fg[blue]%}%~%{$reset_color%} $ '
RPROMPT='${return_code} %{$fg[yellow]%}$(git_prompt_info)%{$reset_color%} <$(~/.rvm/bin/rvm-prompt i v g)>'

ZSH_THEME_GIT_PROMPT_PREFIX="<git:"
ZSH_THEME_GIT_PROMPT_SUFFIX=">"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
   
# See http://geoff.greer.fm/lscolors/
#export LSCOLORS="gxfxcxdxbxegedabagacad"
#export LS_COLORS="di=36;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
