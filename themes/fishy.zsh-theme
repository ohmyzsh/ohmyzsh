# ZSH Theme emulating the Fish shell's default prompt.

local user_color='green'; [ $UID -eq 0 ] && user_color='red'
PROMPT='%n@%m %{$fg[$user_color]%}%~%{$reset_color%}%(!.#.>) '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='%(?..%{$fg[red]%}%? ↵%{$reset_color%})$(vcs_prompt_info)'

ZSH_THEME_VCS_PROMPT_PREFIX=" %{$fg[cyan]%}"
ZSH_THEME_VCS_PROMPT_SUFFIX="%{$reset_color%}"
