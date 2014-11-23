# dogenpunk.zsh-theme

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%}"

PROMPT='%{$fg[blue]%}[%n@%m%{$reset_color%}%{$fg_bold[white]%}:%{$reset_color%}%{$fg[cyan]%}%~]:%{$reset_color%}%{$fg[red]%}[$(git_prompt_short_sha)%{$reset_color|$(git_prompt_info)%{$fg[red]%}]%{$reset_color
 $(prompt_char) '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[green]%}git%{$reset_color%}@%{$bg[white]%}%{$fg[black]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

RPROMPT='${return_status}$(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[green]%}±%{$reset_color%}" && return
  echo "%{$fg[cyan]%}◯ %{$reset_color%}"
}
