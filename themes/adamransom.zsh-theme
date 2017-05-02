# https://github.com/adamransom zsh theme

function _prompt_char() {
  echo "%{$fg[blue]%}➜%{$reset_color%}"
}

function _ssh_prompt() {
  [[ -n "${SSH_CONNECTION}" ]] && echo "%{$fg_bold[green]%}%n@%m%{$reset_color%} "
}

function _collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

precmd()
{
  print -rP '
$(_ssh_prompt)%{$fg[yellow]%}$(_collapse_pwd)$(git_prompt_info)%{$reset_color%}'
}

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[green]%}on %{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}%{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$reset_color%}%{$fg[green]%}✔%{$reset_color%}"

PROMPT='$(_prompt_char) %#%{$reset_color%} '
