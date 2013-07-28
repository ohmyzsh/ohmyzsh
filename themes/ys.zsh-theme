# Clean, simple, compatible and meaningful.
# Tested on Linux, Unix and Windows under ANSI colors.
# It is recommended to use with a dark background and the font Inconsolata.
# Colors: black, red, green, yellow, *blue, magenta, cyan, and white.
# 
# http://blog.ysmood.org/2013/03/my-ys-terminal-theme/
# Mar 2013 ys

# Git Info
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"


: <<'FORMAT'
Prompt format:

PRIVILEGES USER@MACHINE in DIRECTORY on git:BRANCH STATE [TIME] L:SHELL_LEVEL N:LINE_NUM
$ 

For example:

% ys@ys-mbp in ~/.oh-my-zsh on git:master x [21:47:42] - 12
$ 

FORMAT

PROMPT="
%{$terminfo[bold]$fg[blue]%}%#%{$reset_color%} \
%{$fg[cyan]%}%n \
%{$fg[white]%}@ \
%{$fg[green]%}%m \
%{$fg[white]%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${git_info} \
%{$fg[white]%}[%*] L:%L N:%i
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
