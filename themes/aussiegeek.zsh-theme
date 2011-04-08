
PROMPT='$fg_bold[blue][ $fg[red]%t $fg_bold[blue]] $fg_bold[blue] [ $fg[red]%n@%m:%~$(vcs_prompt_info)$fg[yellow]$(rvm_prompt_info)$fg_bold[blue] ]$reset_color
 $ '
# git theming
ZSH_THEME_VCS_PROMPT_PREFIX="$fg_bold[green]("
ZSH_THEME_VCS_PROMPT_SUFFIX=")"
ZSH_THEME_VCS_PROMPT_CLEAN="✔"
ZSH_THEME_VCS_PROMPT_DIRTY="✗"
