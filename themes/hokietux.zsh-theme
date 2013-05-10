# Color shortcuts
R=$fg[red]
G=$fg[green]
M=$fg[magenta]
RB=$fg_bold[red]
YB=$fg_bold[yellow]
BB=$fg_bold[blue]

if [ "$(whoami)" = "root" ]; then
    PROMPTCOLOR="%{$RB%}" PREFIX="-!-";
else
    PROMPTCOLOR="" PREFIX="---";
fi

local return_code="%(?..%{$RB%}%? ↵%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}±(%{$fg_bold[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[red]%}⚡%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg_bold[yellow]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✓%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

PROMPT='[%{$fg_bold[green]%}%~%{$fg_no_bold[white]%}]%{$fg_bold[red]%}➜$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%} $ '
RPROMPT='${return_code}[%{$fg_no_bold[yellow]%}%h%{$reset_color%}][%*]'

