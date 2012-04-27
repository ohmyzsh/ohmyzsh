# diff color for root shell
if [ $UID -eq 0 ]; then 
        NCOLOR="red"
        PCOLOR="red" 
else 
        NCOLOR="green" 
        PCOLOR="green"
fi

# diff color for host if on SSH session
if [[ -n "${SSH_CLIENT}"  ||  -n "${SSH2_CLIENT}" ]]; then 
        HCOLOR="yellow"; else HCOLOR="green"; fi

PROMPT='%{$fg[cyan]%}[%{$reset_color%}%{$fg[$NCOLOR]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[$HCOLOR]%}%m%{$reset_color%}%{$fg[cyan]%}]%{$reset_color%}%{$fg[cyan]%}[%{$reset_color%}%{$fg[blue]%}%B%c/%b%{$reset_color%}%{$fg[cyan]%}]%{$reset_color%}%{$fg[$PCOLOR]%}%#%{$reset_color%} '

RPROMPT='$(git_prompt_info)'

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_no_bold[yellow]%}%B"
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%{$fg_bold[blue]%})%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}✗"

export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:';
