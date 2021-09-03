# -*- sh -*- vim:set ft=sh ai et sw=4 sts=4:
# Simple bash themes
PROMPT='%{$fg[green]%}%n@%m.dev:%{$fg_bold[blue]%}%2~ $(git_prompt_info)%{$reset_color%}%(!.#.$) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
