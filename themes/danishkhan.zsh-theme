
PROMPT='$fg_bold[blue][ $fg[red]%t $fg_bold[blue]] $fg_bold[blue] [ $fg[red]%n@%m:%~$(git_prompt_info)$fg[yellow]$(rvm_prompt_info)$fg_bold[blue] ]$reset_color
$(prompt_char)  '

# Git Theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg_bold[green]("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_CLEAN=" ✔"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$fg[green]%}"

# Repository Types
function prompt_char {
    git branch >/dev/null 2>/dev/null && echo %{$fg_bold[green]%}'±' && return
    hg root >/dev/null 2>/dev/null && echo '☿' && return
    echo %{$fg_bold[cyan]%}'☁'
}