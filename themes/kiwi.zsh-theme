(( $+functions[battery_pct_prompt] )) || function battery_pct_prompt { }

PROMPT='%{$fg_bold[green]%}┌[%{$fg_bold[cyan]%}kiwish-4.2%{$fg_bold[green]%}]-(%{$fg_bold[white]%}%2~%{$fg_bold[green]%})-$(git_prompt_info)$(svn_prompt_info)$(battery_pct_prompt)
└> % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$reset_color%}%{$fg[white]%}git:%{$fg_bold[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[green]%}]-"

ZSH_THEME_SVN_PROMPT_PREFIX="[%{$reset_color%}%{$fg[white]%}svn:%{$fg_bold[white]%}/"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$fg_bold[green]%}]-"
