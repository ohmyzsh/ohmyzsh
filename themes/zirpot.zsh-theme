local ret_status="%(?:%{$FX[bold]$FG[113]$FX[bold]%}➜ :%{$fg_bold[red]%}➜ %s)"
PROMPT='%{$FX[bold]$FG[243]$FX[bold]%}[%*] %h %{$reset_color%}% %{$FX[bold]$FG[113]$FX[bold]%}%~ %{$reset_color%}%{$(git_prompt_info)$(git_prompt_status)
${ret_status}% %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" git:%{$FX[bold]$FG[117]$FX[bold]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX=" %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%} ✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%} ✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
ZSH_THEME_GIT_PROMPT_ADDED=" %{$fg_bold[green]%}+%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_MODIFIED=" %{$fg_bold[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" %{$fg_bold[yellow]%}?%{$reset_color%}"
