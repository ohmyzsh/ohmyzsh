# Inspired by many other themes
PROMPT='[%*] %{$fg[cyan]%}%n%{$fg[magenta]%}➜%{$fg[green]%}%3~$(git_prompt_info)%{$reset_color%}» '

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}✗%{$fg[blue]%})"

# LS colors, made with http://geoff.greer.fm/lscolors/
export LSCOLORS="Gxfxcxdxbxegedabagacad"
export LS_COLORS="di=1;;40:ln=35;40:so=32;40:pi=33;40:ex=31;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
