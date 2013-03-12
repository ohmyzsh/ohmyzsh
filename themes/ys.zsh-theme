# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows.
# It is recommanded to use with a dark background and the font Inconsolata.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
#
# Oct 2012 ys

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"

PROMPT="
# %{$fg[green]%}%n%{$reset_color%} %{$fg[white]%}at%{$reset_color%} %{$fg[cyan]%}$(box_name)%{$reset_color%} %{$fg[white]%}in%{$reset_color%} %{$terminfo[bold]$fg[yellow]%}${current_dir}%{$reset_color%}${git_info} %{$fg[white]%}[%*]%{$reset_color%}
%{$fg[red]%}$ %{$reset_color%}"
