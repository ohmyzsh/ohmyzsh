# Yay! High voltage and arrows!

prompt_setup_pygmalion(){
<<<<<<< HEAD
=======
  setopt localoptions extendedglob

>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}"
  ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
  ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡%{$reset_color%}"
  ZSH_THEME_GIT_PROMPT_CLEAN=""

  base_prompt='%{$fg[magenta]%}%n%{$reset_color%}%{$fg[cyan]%}@%{$reset_color%}%{$fg[yellow]%}%m%{$reset_color%}%{$fg[red]%}:%{$reset_color%}%{$fg[cyan]%}%0~%{$reset_color%}%{$fg[red]%}|%{$reset_color%}'
  post_prompt='%{$fg[cyan]%}⇒%{$reset_color%}  '

<<<<<<< HEAD
  base_prompt_nocolor=$(echo "$base_prompt" | perl -pe "s/%\{[^}]+\}//g")
  post_prompt_nocolor=$(echo "$post_prompt" | perl -pe "s/%\{[^}]+\}//g")

  precmd_functions+=(prompt_pygmalion_precmd)
}

prompt_pygmalion_precmd(){
  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=$(echo "$gitinfo" | perl -pe "s/%\{[^}]+\}//g")
  local exp_nocolor="$(print -P \"$base_prompt_nocolor$gitinfo_nocolor$post_prompt_nocolor\")"
  local prompt_length=${#exp_nocolor}

  local nl=""

  if [[ $prompt_length -gt 40 ]]; then
    nl=$'\n%{\r%}';
  fi
  PROMPT="$base_prompt$gitinfo$nl$post_prompt"
}

prompt_setup_pygmalion


=======
  base_prompt_nocolor=${base_prompt//\%\{[^\}]##\}}
  post_prompt_nocolor=${post_prompt//\%\{[^\}]##\}}

  autoload -U add-zsh-hook
  add-zsh-hook precmd prompt_pygmalion_precmd
}

prompt_pygmalion_precmd(){
  setopt localoptions nopromptsubst extendedglob

  local gitinfo=$(git_prompt_info)
  local gitinfo_nocolor=${gitinfo//\%\{[^\}]##\}}
  local exp_nocolor="$(print -P \"${base_prompt_nocolor}${gitinfo_nocolor}${post_prompt_nocolor}\")"
  local prompt_length=${#exp_nocolor}

  PROMPT="${base_prompt}\$(git_prompt_info)${post_prompt}"
}

prompt_setup_pygmalion
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
