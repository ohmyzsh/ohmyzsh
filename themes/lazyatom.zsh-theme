git_prompt_info() {
  branch=$(git symbolic-ref HEAD 2> /dev/null) || return
  git_status="$(git status 2> /dev/null)"
  state=""
  case $git_status in
    *Changed\ but\ not\ updated*)
      state="%{$fg[red]%}⚡"
    ;;;
    *Untracked\ files*)
      state="%{$fg[red]%}⚡"
    ;;;
  esac
  
  remote=""
  case $git_status in
    *Your\ branch\ is\ ahead*)
      remote="%{$fg[yellow]%}↑"
    ;;;
    
    *Your\ branch\ is\ behind*)
      remote="%{$fg[yellow]%}↓"
    ;;;
    
    "Your branch and")
      remote="%{$fg[yellow]%}"
    ;;;
  esac
  echo " %{$fg[yellow]%}(${branch#refs/heads/})${remote}${state}"
}

function oh_my_zsh_theme_precmd() {
  local previous_return_value=$?;
  prompt="%{$fg[light_gray]%}%c%{$fg[yellow]%}$(git_prompt_info)%{$fg[white]%}"
  if test $previous_return_value -eq 0
  then
    export PROMPT="%{$fg[green]%}➜  %{$fg[white]%}${prompt}%{$fg[green]%} $%{$fg[white]%} "
  else
    export PROMPT="%{$fg[red]%}➜  %{$fg[white]%}${prompt}%{$fg[red]%} $%{$fg[white]%} "
  fi
}