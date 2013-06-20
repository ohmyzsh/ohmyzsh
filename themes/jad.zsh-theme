#
# A simple prompt that shows user, hostname, directory, git status (with
# emoji!), time, and command number.
#
# Adopted from http://ysmood.org/wp/2013/03/my-ys-terminal-theme/ 
#

function host_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[white]%}on%{$reset_color%} git:%{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}☀"

# Prompt format: \n # USER@HOST DIRECTORY on git:BRANCH \n TIME [COMMAND] \n $ 
PROMPT="
%{$fg[cyan]%}%n@$(host_name) \
%{$fg[white]%}\
%{$fg[yellow]%}${current_dir}%{$reset_color%}\
${git_info}
%{$fg[white]%}%* \
%{$fg[white]%}[%h] \
%(!.#.$) %{$reset_color%}"
