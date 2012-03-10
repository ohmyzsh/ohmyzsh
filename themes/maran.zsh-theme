# Theme with full path names and hostname
# Handy if you work on different servers all the time;
PROMPT='%{$fg[cyan]%}%n%{$reset_color%}@%{$fg[yellow]%}%M:%{$fg[green]%}%/%{$reset_color%}%{$fg[cyan]%}$(svn_prompt_info)%{$reset_color%}$(git_prompt_info)%(!.#.%{$fg[yellow]%}$%{$reset_color%}) '

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[cyan]%}git:("
ZSH_THEME_GIT_PROMPT_SUFFIX=")%{$reset_color%}"

ZSH_THEME_SVN_PROMPT_PREFIX=" svn:("
ZSH_THEME_SVN_PROMPT_SUFFIX=")"
ZSH_THEME_SVN_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_CLEAN=""
