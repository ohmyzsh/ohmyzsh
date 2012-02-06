# ------------------------------------------------------------------------------
#          FILE:  gentoo-advanced.zsh-theme
#   DESCRIPTION:  Gentoo's bashrc clone theme for oh-my-zsh.
#        AUTHOR:  Sergio Conde Gómez (skgsergio@gmail.com)
#       VERSION:  1.0.0
# ------------------------------------------------------------------------------

# Return Code
return_code="%(?..%{$fg_bold[red]%}[Err: %?] %{$reset_color%})"

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[red]%}!"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$fg_bold[red]%}/"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$fg_bold[red]%}-"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$fg_bold[blue]%}~"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg_bold[yellow]%}~"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg_bold[green]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg_bold[white]%}?"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$fg[white]%}[%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$fg[white]%}]"

# Prompt format
PROMPT='%{$fg_bold[green]%}%n@%m%{$fg[white]%} %{$fg_bold[blue]%}%~%u%{$reset_color%} %{$fg_bold[blue]%}$%{$reset_color%} '
RPROMPT='${return_code}%{$fg_bold[green]%}$(current_branch)$(parse_git_dirty)$(git_prompt_ahead)$(git_prompt_short_sha)$(git_prompt_status)%{$reset_color%}'