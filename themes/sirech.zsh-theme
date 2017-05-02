# -*- mode: Shell-script-*-
# ZSH Theme
# Based on lukerandall.zsh-theme
# Modified with stuff taken from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

local return_code="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"

PROMPT='%{$fg_bold[green]%}%n@%m%{$reset_color%} %{$fg_bold[cyan]%}%35<..<${PWD/#$HOME/~}%<<%{$reset_color%} $(git_prompt_info)%{$reset_color%}%B»%b '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
