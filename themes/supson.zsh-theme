function venv {
    [ $VIRTUAL_ENV ] && echo '['`basename $VIRTUAL_ENV`']'
}

function git_status {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
     echo "$(parse_git_dirty)"
  else
     echo "%{$fg_bold[cyan]%}¯\_(ツ)_/¯"
  fi
}

function git_branch {
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX$(command git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' )$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT=' $(git_status) %{$fg_bold[green]%}%3~ » '
RPROMPT='%{$fg_bold[magenta]%}$(venv)$(git_branch)%{$fg_bold[green]%}%D{%l:%M:%S}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}(╯°□°)╯︵ ┻━┻"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}┬─┬ノ( ゜-゜ノ)"
