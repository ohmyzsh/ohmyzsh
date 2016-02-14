# Ewancoder theme
# Based on fino theme

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo "±" && return
  echo '○'
}

local current_dir='${PWD/#$HOME/~}'
local git_info='$(git_prompt_info)'
local prompt_char='$(prompt_char)'

if [[ $UID -ne 0 ]]; then
    usercolor="040"
else
    usercolor="001"
fi

PROMPT="╭─%{$FG[$usercolor]%}%n%{$reset_color%} %{$FG[239]%}at%{$reset_color%} %{$FG[033]%}$HOST%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}${current_dir}%{$reset_color%} %{$FG[239]%}${git_info}
╰─${prompt_char}%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX="$FG[239]on $terminfo[bold]$FG[255]"
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[202] ✘✘✘"
ZSH_THEME_GIT_PROMPT_CLEAN="$FG[040] ✔ $reset_color"
