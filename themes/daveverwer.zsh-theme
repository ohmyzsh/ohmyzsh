# Copied and modified from the oh-my-zsh theme from geoffgarside
# Red server name, green cwd, blue git status

PROMPT='%{$fg[red]%}%m%{$reset_color%}:%{$fg[green]%}%c%{$reset_color%}$(vcs_prompt_info) %(!.#.$) '

ZSH_THEME_VCS_PROMPT_PREFIX=" %{$fg[blue]%}("
ZSH_THEME_VCS_PROMPT_SUFFIX=")%{$reset_color%}"
