function ssh_username_hostname() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    echo "%{$fg_bold[green]%}%n@%m "
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}X%{$fg[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})"

local current_dir="%{$fg[blue]%}%~ "
local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%}%? )%# "

PROMPT='$(ssh_username_hostname)${current_dir}$(git_prompt_info)${ret_status}%{$reset_color%}'
