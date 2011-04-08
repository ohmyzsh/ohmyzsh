# Theme with full path names and hostname
# Handy if you work on different servers all the time;
PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%M:%{$fg[green]%}%/%{$reset_color%} $(vcs_prompt_info) %(!.#.$) '

ZSH_THEME_VCS_PROMPT_PREFIX=" %{$fg[cyan]%}"'$(vcs_name)'"("
ZSH_THEME_VCS_PROMPT_SUFFIX=")%{$reset_color%}"
