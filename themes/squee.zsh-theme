LHOST=$(scutil --get LocalHostName)
PROMPT='$fg_bold[magenta][$fg[white]%t$fg_bold[magenta]]$fg_bold[magenta] [$fg[white]%n@$LHOST$fg_bold[magenta]]
[$fg[white]%~$(git_prompt_info)$fg[white]$(rvm_prompt_info)$fg_bold[magenta]]$reset_color
$ '
# git theming                                                                                                                                                                   
ZSH_THEME_GIT_PROMPT_PREFIX=" $fg_bold[red]($fg_bold[white]"
ZSH_THEME_GIT_PROMPT_SUFFIX="$fg_bold[red])"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$fg_bold[cyan]*"
