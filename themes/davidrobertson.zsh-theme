# ------------------------------------------------------------------------
# David Robertson's oh-my-zsh theme (basically a hybrid of the default robbyrussell theme and juanghurtado theme)
# (Needs Git plugin for current_branch method)
# ------------------------------------------------------------------------


# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
RESET_COLOR=$reset_color

# Format for git_prompt_info()
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""

# Format for parse_git_dirty()
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$RED%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$GREEN%}✓"

# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED=" %{$RED%}Unmerged"
ZSH_THEME_GIT_PROMPT_DELETED=" %{$RED%}Deleted"
ZSH_THEME_GIT_PROMPT_RENAMED=" %{$YELLOW%}Renamed"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$YELLOW%}Modified"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$GREEN%}Added"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$WHITE%}Untracked"

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}⇑"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$WHITE%}[%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$WHITE%}]"

# Prompt format
PROMPT='%{$fg_bold[red]%}➜ %{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
RPROMPT='%{$GREEN_BOLD%}$(current_branch)$(git_prompt_short_sha)$(git_prompt_status)%{$RESET_COLOR%}'
