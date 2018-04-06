function _prompt_char() {
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    echo ' '
  fi
}

PROMPT='%F{red}[%B%F{220}%n%F{green}@%F{39}%m %F{5}%1~%F{red}$(_prompt_char)$(git_prompt_info)%F{red}%b]%f%# '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
