ZSH_THEME_GIT_PROMPT_PREFIX="$fg[cyan]($fg[green]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg[cyan])$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY=" $fg[red]✗$reset_color"
ZSH_THEME_GIT_PROMPT_CLEAN=" $fg[green]✔$reset_color"

PROMPT='$(git_prompt_info) $fg[cyan]%c '
