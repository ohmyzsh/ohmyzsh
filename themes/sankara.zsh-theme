if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[$NCOLOR]%}%n%{$fg[green]%}@%m%{$reset_color%} %~ \
%{$fg[red]%}%(!.#.»)%{$reset_color%} '
RPROMPT='%{$fg[red]%}«%{$reset_color%} $(git_prompt_info) %F{blue} %F{green}%D{%L:%M} %F{yellow}%D{%p}%f'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}±%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="⚡"

export GREP_COLOR='1;35'
