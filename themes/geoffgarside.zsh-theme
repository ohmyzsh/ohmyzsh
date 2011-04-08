# PROMPT="[%*] %n:%c $(vcs_prompt_info)%(!.#.$) "
PROMPT='[%*] %{$fg[cyan]%}%n%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}$(vcs_prompt_info) %(!.#.$) '

ZSH_THEME_VCS_PROMPT_PREFIX=" %{$fg[yellow]%}"'$(vcs_name)'"("
ZSH_THEME_VCS_PROMPT_SUFFIX=")%{$reset_color%}"
