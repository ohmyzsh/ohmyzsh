# ------------------------------------------------------------------------
# Jack Li oh-my-zsh theme
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

# Format for git_prompt_ahead()
ZSH_THEME_GIT_PROMPT_AHEAD=" %{$RED%}(!)"

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" %{$WHITE%}[%{$YELLOW%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$WHITE%}]"

# Prompt format
PROMPT='
%{$RED%}[%T][zsh]%{$RESET_COLOR%} %{$GREEN_BOLD%}%n%{$WHITE%}: %{$YELLOW%}%~%u%{$RESET_COLOR%}
%{$GREEN%}$%{$RESET_COLOR%} '
RPROMPT='%{$GREEN_BOLD%}$(current_branch)$(git_prompt_short_sha)%{$RESET_COLOR%}'
