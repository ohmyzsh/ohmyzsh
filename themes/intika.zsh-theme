ZSH_THEME_GIT_PROMPT_PREFIX=" (%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%})"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ±%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%} ▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%} ▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%} ♥%{$reset_color%}"

function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg[red]%}#%{$reset_color%}"; else echo $; fi
}

# Line every return
# PROMPT='$FG[237]----------------------------------------------------------------------------------------%{$reset_color%}
PROMPT='[%{$fg[gray]%}%n@%m%{$reset_color%}:$FG[069]%~%{$reset_color%}$(git_prompt_info)]$(prompt_char) '


# %W instead of %D for us
RPROMPT='$FG[059][%D %*]%(?,$FG[022][R-$?],$FG[130][R-$?])$FG[024][!%!]%{$reset_color%}'
