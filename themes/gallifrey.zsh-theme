# ZSH Theme - Preview: http://img.skitch.com/20091113-qqtd3j8xinysujg5ugrsbr7x1y.jpg
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
local suspended_jobs='%(1j.  %{$fg[yellow]%}${(Mw)#jobstates#suspended:} ↓%{$reset_color%}.)'
local running_jobs='%(1j. %{$fg[green]%}${(Mw)#jobstates#running:} ↻%{$reset_color%}.)'

PROMPT='%{$fg[green]%}%m%{$reset_color%} %2~ $(git_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}${suspended_jobs}${running_jobs}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"
