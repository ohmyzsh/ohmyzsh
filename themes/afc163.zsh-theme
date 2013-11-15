PROMPT='%{$fg_bold[green]%}➼ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c%{$fg_bold[grey]%}$(package_version)%{$fg_bold[grey]%} %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:❨%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}❩ %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}❩"

function package_version() {
  if [ -f ./package.json ]; then
    echo "@"$(grep '"version"' ./package.json | head -n 1 | awk -F'"' '{print $4}')
  fi
}
