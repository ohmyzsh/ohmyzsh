# ZSH Theme - Preview: http://dl.dropbox.com/u/1552408/Screenshots/2010-04-08-oh-my-zsh.png

if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[$NCOLOR]%}%n%{$fg[green]%}@%m%{$reset_color%} %~ \
$(vcs_prompt_info)\
%{$fg[red]%}%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

ZSH_THEME_VCS_PROMPT_PREFIX="%{$fg[green]%}±%{$fg[yellow]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_VCS_PROMPT_CLEAN=""
ZSH_THEME_VCS_PROMPT_DIRTY="⚡"

