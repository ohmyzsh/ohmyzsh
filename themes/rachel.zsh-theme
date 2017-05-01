if [ "$(whoami)" = "root" ]; then CARETCOLOR="cyan"; else CARETCOLOR="white"; fi

PROMPT='[%{${fg_bold[red]}%}%*%{$reset_color%}][%{${fg_bold[magenta]}%}%~%{$reset_color%}][%{${fg_bold[green]}%}%n@%m%{$reset_color%}]$(git_prompt_info)
%{${fg_bold[$CARETCOLOR]}%}%%%{${reset_color}%} '

LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=33:so=01;35:bd=33;01:cd=33;01:or=01;05;37;41:mi=01;37;41:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.bz=01;31:*.tz=01;31:*.rpm=01;31:*.cpio=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.png=01;35:*.tif=01;35:'
LSCOLORS='ExGxFxdxCxDxDxcxcxxCxc'
CLICOLOR=1

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""