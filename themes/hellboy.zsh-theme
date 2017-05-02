
# C O L O R
HT_COLOR1="%{$fg[cyan]%}"
HT_COLOR1_B="%{$fg_bold[cyan]%}"
HT_COLOR1_DARK="%{$fg[blue]%}"
HT_COLOR1_DARK_B="%{$fg_bold[blue]%}"

HT_COLOR2="%{$fg[green]%}"
HT_COLOR2_B="%{$fg_bold[green]%}"

HT_COLOR3="%{$fg[red]%}"
HT_COLOR3_B="%{$fg_bold[red]%}"

HT_COLOR_BACK="%{$fg[white]%}"
HT_COLOR_BACK_B="%{$fg_bold[white]%}"

HT_RESET_COLOR="%{$reset_color%}"

# T I M E
HT_TIME_="%(?.${HT_COLOR1}.${HT_COLOR3})%*%{$reset_color%}"

# H O S T N A M E  &  U S E R N A M E
HT_USER_="$HT_COLOR1_B%n"

typeset -A host_repr
host_repr=('hellboys-MacBookAir' "${HT_COLOR1}Air" 'hellboys-macpro' "${HT_COLOR1}Pro")
HT_HOST_="${host_repr[$(hostname)]:-$(hostname)}%{$reset_color%}"

HT_USERHOST_="$HT_USER_$HT_COLOR_BACK@$HT_HOST_$HT_RESET_COLOR"

# G I T
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[grey]%}[%{$reset_color%}%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[grey]%}]%{$fg[yellow]%}⚡%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[grey]%}] "

# P R O M P T
PROMPT='$HT_TIME_ $HT_USERHOST_%{$fg_bold[green]%}%P %{$fg[green]%}%c %{$fg_bold[cyan]%}$(git_prompt_info)%{$reset_color%}'
