# Risto Theme
#
# Requires the svn plugin
#
PROMPT='%{$fg[green]%}%n@%m:%{$fg[blue]%}%2~ $(svn_prompt_info)$(git_prompt_info)%{$reset_color%}%(!.#.%%) '
RPROMPT='%{$fg_bold[red]%}$(rvm-prompt)%{$reset_color%}%'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[red]%}›%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[green]%}✓"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[yellow]%}∗"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_SVN_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_SVN_PROMPT_SUFFIX="›%{$reset_color%}"

