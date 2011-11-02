# dpree.zsh-theme
# Preview: http://gyazo.com/28e31261bf74230f04f31afd4140d361.png

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg[green]%}%~%{$reset_color%} %{$fg[red]%}$(rbenv version-name)%{$reset_color%} $(git_prompt_short_sha)$(git_prompt_info) %{$reset_color%} '
RPS1="${return_code}"

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[blue]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[yellow]%}⚡%{$reset_color%}"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE="%{$fg[grey]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="|%{$reset_color%}"

# Format for git_time_since_commit()
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[blue]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[green]%}"

# Right column
# RPROMPT='%{$fg[grey]%}$USER@$HOST%{$reset_color%}'
