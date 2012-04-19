# https://github.com/adamransom zsh theme

function _prompt_char() {
  echo "%{$fg[blue]%}➜%{$reset_color%}"
}

function _ssh_prompt() {
  [[ -n "${SSH_CONNECTION}" ]] && "%n%{$fg_bold[blue]%}@%{$fg_bold[cyan]%}%m%{$fg_bold[green]%}"
}

function _collapse_pwd {
  echo $(pwd | sed -e "s,^$HOME,~,")
}

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg_bold[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$bg[black]%}%{$fg_bold[green]%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$reset_color%}%{$bg[black]%}%{$fg[red]%}✘%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$reset_color%}%{$bg[black]%}%{$fg[green]%}✔%{$reset_color%}"

PROMPT='%{$reset_color%}
%{%K{black}%B%F{green}%}$(_ssh_prompt)%{%b%F{yellow}%K{black}%}$(_collapse_pwd)%{%B%F{green}%}$(git_prompt_info)%E%{$reset_color%}
%{%K{black}%}$(_prompt_char)%{%K{black}%} %#%{$reset_color%} '
