# Theme with full path names and hostname
# Handy if you work on different servers all the time;
PROMPT='%{$fg_bold[green]%}%n@%M%{$reset_color%}:%{$fg_bold[blue]%}%/%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[yellow]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}) %{$reset_color%}%(!.#.$)"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[yellow]%}) %{$reset_color%}%(!.#.$)"
