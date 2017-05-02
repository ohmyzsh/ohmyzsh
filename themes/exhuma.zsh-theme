#
# Features
# ========
#
# * Shows current user-name and host
# * Show the full path of the current working directory
# * Shows the current time
#   While this may not be useful all the time, it sure comes in handy if you
#   forgot to prefix a command with ``time``.
# * When working on a git repo, shows the current branch name and status
#   indicator.
# * Color of some elements changes if you are in a privileged shell.
# * If there are background jobs, the number of jobs is shown in the shell.
#
#
# Theme examples
# ==============
#
# With background jobs
#
# ┌─[16:56:55] michel@BBS-nexus ‹master*›
# └─[1 background job(s)] ~exhuma/work/oh-my-zsh›
#
#
# Without background jobs:
#
# ┌─[16:56:55] michel@BBS-nexus ‹master*›
# └─ ~exhuma/work/oh-my-zsh›
#

#local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"  # TODO: Does not seem to work!
local user_host='%{$terminfo[bold]$fg[blue]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}'
local current_dir='%{$fg[blue]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'
local current_time='[%*]'
local backround_jobs='%(1j.%{$terminfo[bold]$fg[yellow]%}[%j background job(s)]%{$reset_color%} .)'

local ucolor="%(!.%{${fg[red]}%}.%{${fg[green]}%})" # Red if running as root, green if non-root

PROMPT="$ucolor┌─%{$reset_color%}${current_time} ${user_host} ${git_branch} ${backround_jobs}
$ucolor└─%{$reset_color%}${current_dir}$ucolor%(!.#.›) %{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="›%{$reset_color%}"

# vim: filetype=zsh :
