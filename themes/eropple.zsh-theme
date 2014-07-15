MAIN_COLOR=${EROPPLE_THEME_MAIN_COLOR:=$fg[green]}
SECONDARY_COLOR=${EROPPLE_THEME_SECONDARY_COLOR:=$fg[cyan]}
CAPPER_COLOR=${EROPPLE_THEME_CAPPER_COLOR:=$fg[yellow]}
CAPPER=$

if [[ `id -u $USER` -eq 0 ]]
    then

    MAIN_COLOR=${EROPPLE_THEME_ROOT_MAIN_COLOR:=$fg[red]}
    SECONDARY_COLOR=${EROPPLE_THEME_ROOT_SECONDARY_COLOR:=$fg[yellow]}
    CAPPER_COLOR=${EROPPLE_THEME_CAPPER_COLOR:=$fg[yellow]}
    CAPPER=\#
fi

# PROMPT='[%{$MAIN_COLOR%}%n%{$SECONDARY_COLOR%}@%{$MAIN_COLOR%}%m%{$reset_color%} %{$SECONDARY_COLOR%}%~%{$reset_color%}$(git_prompt_info)%{$reset_color%}]$CAPPER_COLOR$CAPPER%{$reset_color%} '
PROMPT='[%{$MAIN_COLOR%}%n%{$SECONDARY_COLOR%}@%{$MAIN_COLOR%}%m%{$reset_color%} %{$SECONDARY_COLOR%}%~%{$reset_color%}$(git_prompt_info)%{$reset_color%}]%{$CAPPER_COLOR%}$CAPPER%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$MAIN_COLOR%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$MAIN_COLOR%} %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$reset_color%}"

