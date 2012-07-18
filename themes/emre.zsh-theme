function get_ip() {
  ifconfig en0 |
  grep -oP "(?<=inet ).*?(?= )"
}

PROMT_NAME_COLOR="%{$fg_bold[green]%}"
PROMT_DIRECTORY_COLOR="%{$fg_bold[blue]%}"
PROMT_COLOR="%{$fg_bold[yellow]%}"

PROMPT=$'\
${PROMT_NAME_COLOR}%n@$(get_ip) %{$reset_color%}${PROMT_DIRECTORY_COLOR}%~%{$reset_color%}\
${PROMT_COLOR}%D{%R} $(git_prompt_info)>%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=" "
