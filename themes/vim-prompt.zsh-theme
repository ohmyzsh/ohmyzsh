function zle-line-init zle-keymap-select {
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}- %{$fg[yellow]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}*%{$fg[yellow]%}"

ZSH_THEME_VI_MODE_COMMAND="%{$fg_bold[magenta]%}<#%{$reset_color%}"
ZSH_THEME_VI_MODE_INSERT="%{$fg_bold[green]%}$>%{$reset_color%}"

vi_mode_prompt_info () {
  if [[ ${KEYMAP} = 'vicmd' ]]
  then
    echo $ZSH_THEME_VI_MODE_COMMAND
  else
    echo $ZSH_THEME_VI_MODE_INSERT
  fi
}

PROMPT='%{$fg[green]%}%c $(git_prompt_info)$(vi_mode_prompt_info) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='%{$fg[blue]%}%~%{$reset_color%} ${return_code} '
