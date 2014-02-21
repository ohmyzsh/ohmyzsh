# Inspired by ys.zsh-theme, differences are:
# * Show more information about git status
# * Show error code from previous command if it is not 0
# * Less distractive PROMPT 
# Screenshot: https://dl.dropboxusercontent.com/u/114202641/Public/outcold.zsh-theme.png

# Machine name.
function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname
}

# Directory info.
local current_dir='${PWD/#$HOME/~}'

# Git info.
local git_info='$(git_prompt_info)%{$reset_color%}$(git_prompt_status)%{$reset_color%}$(git_remote_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_STASHED="+"

ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=">"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="<"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="<>"
ZSH_THEME_GIT_PROMPT_NO_DIFFERENCE_REMOTE="="

# Prompt format: \n EXIT_CODE_IF_NOT_0 \n # USER @ MACHINE : DIRECTORY \n git:BRANCH STATE $ 
PROMPT="
%{$fg[red]%}%(?..>> exit code = %? <<

)\
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$fg[white]%}%* \
%{$fg[cyan]%}%n \
%{$fg[white]%}@ \
%{$fg[cyan]%}$(box_name)\
%{$fg[white]%}:\
%{$terminfo[bold]$fg[white]%}${current_dir}%{$reset_color%}
${git_info}\
%{$terminfo[bold]$fg[red]%}$ %{$reset_color%}"
