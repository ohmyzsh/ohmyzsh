# -----------------------------------------------------------------------------
#          FILE: 	daringfireball.zsh-theme
#   DESCRIPTION: 	oh-my-zsh theme file.
#        AUTHOR: 	Stevan C Wing (stevancw@gmail.com)
#       VERSION: 	0.1
#	 DEPENDANCIES:	daringfireball terminal settings
#									(http://bit.ly/daringfireball)
#
#									*Based on the robbyrussell theme*
# -----------------------------------------------------------------------------

PROMPT='%{$fg_bold[white]%}✪ %{$fg_bold[white]%}%p %{$fg[white]%}%c %{$fg_bold[white]%}$(git_prompt_info)%{$fg_bold[green]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[red]%}∆%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"