# Fino-time theme by Aexander Berezovsky (http://berezovsky.me) based on Fino by Max Masnick (http://max.masnick.me)

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo '⠠⠵' && return
    echo '○'
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || hostname -s
}

function bat {
  echo `battery_time_remaining`
}

local rvm_ruby='‹$(rvm-prompt i v g)›%{$reset_color%}'
local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local pc='$(prompt_char)'


# with host
# PROMPT="╭─ $reset_color%}%{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%}${git_info} %{$FG[239]%}using%{$FG[243]%} ${rvm_ruby}%{$FG[239]%} at %{$reset_color%}%t%{$FG[239]%}%{$reset_color%}
# ╰─$(virtualenv_info)${pc} "

PROMPT="╭─ $reset_color%}%{$FG[033]%}%{$terminfo[bold]$FG[033]%}${current_dir}%{$reset_color%}${git_info} %{$FG[243]%}${rvm_ruby}%{$FG[239]%} at %{$reset_color%}%t%{$FG[239]%}%{$reset_color%}
╰─$(virtualenv_info)${pc} "
RPROMPT='$(bat)'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$FG[202]%}✘"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$FG[040]%}✔"
