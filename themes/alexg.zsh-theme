# ZSH Theme - alexg
# Based on 'gallifrey' theme to look like 
# git-prompt (http://volnitsky.com/project/git-prompt/)
#
# note: %F and %K dont work correctly on non-color terminals

local return_code="%(?,,%{$fg[red]%}%? ↵%{$reset_color%})"
local prompt_char="%B%(!,#,»)%b"
local who_where="%(!,%{$fg[magenta]%}%n@%m,%{$fg[blue]%}%m)%{$reset_color%}"

PROMPT='$(git_prompt_info abbr)%1(l, ,)$who_where %{$fg[cyan]%}%2~ %{$reset_color%}$prompt_char '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"
