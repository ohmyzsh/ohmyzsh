
PROMPT='$fg_bold[blue][ $fg[red]%n@%m: $fg[cyan]%~ $fg[green]$(git_prompt_info)$fg_bold[blue] ]
$fg_bold[yellow]⚡$reset_color '

# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg[green]("
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg[green])"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$fg_bold[red] ✗"
