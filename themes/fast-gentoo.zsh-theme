function prompt_char {
	if [ $UID -eq 0 ]; then echo "#"; else echo $; fi
}

git_branch() {
  local branch=$(git rev-parse --abbrev-ref HEAD 2>&1)
  if [[ $branch == 'fatal: not a git repository (or any of the parent directories): .git' ]]; then
    echo "";
  else
    echo "(${branch})"
  fi
}

PROMPT='%(!.%{$fg_bold[red]%}.%{$fg_bold[green]%}%n@)%m %{$fg_bold[blue]%}%(!.%1~.%~) $(git_branch | xargs) $(prompt_char)%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=") "
