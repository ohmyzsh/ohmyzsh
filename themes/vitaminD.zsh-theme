function zle-line-init zle-keymap-select {
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

bindkey -v

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg_bold[magenta]%}•"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[magenta]%}∆"

ZSH_THEME_VI_MODE_COMMAND="%{$fg[yellow]%}#%{$reset_color%}"
ZSH_THEME_VI_MODE_INSERT="%{$fg_bold[yellow]%}$%{$reset_color%}"

vi_mode_prompt_info () {
  if [[ ${KEYMAP} = 'vicmd' ]]
  then
    echo $ZSH_THEME_VI_MODE_COMMAND
  else
    echo $ZSH_THEME_VI_MODE_INSERT
  fi
}

PROMPT='$(git_prompt_info)$(vi_mode_prompt_info) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'

function directory_list() {
  if [[ $PWD = $HOME ]]
  then
    echo "%{$fg[green]%}~%{$reset_color%} ${return_code} "
  else
    echo "%{$fg_bold[green]%}${PWD%/*}/%{$reset_color%}%{$fg[green]%}${PWD##*/}%{$reset_color%} ${return_code} "
  fi
}

RPS1='$(directory_list)'
