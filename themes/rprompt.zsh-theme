# Right-prompt theme for minimum clutter by Chris Leishman <chris@leishman.org>
#
# See screenshot at http://ompldr.org/vOXE5Yw

local host='%{$fg[magenta]%}%m%{$reset_color%}'
local pwd='%{$fg[blue]%}%(4~|../|)%3~%{$reset_color%}'
local rvm='%{$fg[green]%}‹$(rvm-prompt i v g)›%{$reset_color%}'
local jobs='%(1j|%{$fg[green]%}[%j]%{$reset_color%}|)'
local git_branch='$(git_prompt_status)%{$reset_color%}$(git_prompt_info)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="%%%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT="${jobs}%# "
RPROMPT="${host}:${pwd}${git_branch}"

export LSCOLORS="exdxgxgxfxGxCxBxGxExDx"
export LS_COLORS="di=34:ln=33:so=36:pi=36:ex=35:bd=1:cd=1:su=1:sg=1:tw=1:ow=1:"
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
