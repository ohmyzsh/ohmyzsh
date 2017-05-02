# ZSH Theme - Preview: http://cl.ly/image/0w0s301H0T1M
# Thanks lukerandall upon whose theme this is based

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
CYAN=$fg[cyan]

RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
CYAN_BOLD=$fg_bold[cyan]

RESET_COLOR=$reset_color

# The return code of the last-run application in red
local return_code="%(?..%{$RED%}%? ↵%{$RESET_COLOR%})"

function my_git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  SHORT_SHA=%{$CYAN%}$(git_prompt_short_sha)%{$RESET_COLOR%}
  GIT_STATUS=$(git_prompt_status)
  [[ -n $GIT_STATUS ]] && GIT_STATUS="$GIT_STATUS"
  echo "%{$GREEN%}$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}:%{$RESET_COLOR%}$SHORT_SHA$GIT_STATUS%{$GREEN%}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT='[%n@%m %2~$(my_git_prompt_info)%{$RESET_COLOR%}]%# '
# RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"

ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$YELLOW%}%%"
ZSH_THEME_GIT_PROMPT_ADDED="%{$YELLOW%}+"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$YELLOW%}*"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$YELLOW%}~"
ZSH_THEME_GIT_PROMPT_DELETED="%{$YELLOW%}!"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$YELLOW%}?"

