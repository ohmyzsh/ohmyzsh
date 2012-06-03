LHOST=$(scutil --get LocalHostName)
PROMPT='$FG[030][$FG[079]%n@$LHOST$FG[030]][$FG[043]%t$FG[030] $(git_prompt_info)$FG[116]$(rvm_prompt_info)$FG[030]]$reset_color
$FG[030][$FG[079]%~$FG[030]]$reset_color
$ '
# git theming
ZSH_THEME_GIT_PROMPT_PREFIX="$fg_bold[red]($fg_bold[white]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg_bold[red])"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$fg_bold[cyan]*"
