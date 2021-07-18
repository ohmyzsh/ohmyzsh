# Yay! High voltage and arrows!
# The svn plugin has to be activated for displaying svn prompts

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}⚡ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" "

ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[yellow]%}⚡ %{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=" "

PROMPT='%{$fg[cyan]%}%1~%{$reset_color%}%{$fg[red]%}|%{$reset_color%}$(git_prompt_info)$(svn_prompt_info)%{$fg[cyan]%}⇒%{$reset_color%} '
