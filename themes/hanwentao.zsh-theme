function ssh_username_hostname() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    echo "%{$fg_bold[green]%}%n@%m "
  fi
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}git:(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}X%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"

local current_dir="%{$fg_bold[blue]%}%~ "
local ret_status="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%}%? )%# "

PROMPT='%s$(ssh_username_hostname)${current_dir}$(git_prompt_info)${ret_status}%{$reset_color%}'
