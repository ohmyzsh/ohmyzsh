#autoload -U colors && colors
PROMPT='%B%F{$parens_col}%{$fg_bold[green]%}(%(?:%{$fg_bold[yellow]%}^_^:%{$fg_bold[red]%}X_X)%{$fg_bold[green]%}) - (%{$fg[white]%}%n@%m%{$fg_bold[green]%}) - (%{$fg_bold[white]%}jobs:%(0j.%j.)%{$fg_bold[green]%}) - (%{$fg_bold[white]%}%~%{$fg_bold[green]%}) - (%{$reset_color%}$(git_prompt_info)%{$fg_bold[white]%}%T%{$fg_bold[green]%})
----> %{$fg[white]%}%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}%{$fg_bold[green]%}) - ("
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""


case $TERM in
     xterm*)
	precmd () {print -Pn "\e]0;%n@%m: %~\a"}
     ;;
esac
