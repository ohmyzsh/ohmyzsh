# -----------------------------------------------------------------------------
# FILE: chi.zsh-theme
# DESCRIPTION: oh-my-zsh theme file.
# AUTHOR: Akinjide Bankole
#   TWITTER: (https://twitter.com/JideBhanks)
#   GITHUB: (https://github.com/andela-abankole)
# VERSION: 0.1
# SCREENSHOT: Available on Repo
# REPOSITORY: https://github.com/andela-abankole/chi
# -----------------------------------------------------------------------------

# ########## SYSTEM VARIABLE FOR HOME DIR ###########

function get_pwd() {
  echo "${PWD/#$HOME/~}"
}

# ########## GIT STATUS AND BATTERY INFORMATION ###########

function put_spacing() {
  local git=$(git_prompt_info)
  if [ ${#git} != 0 ]; then
      ((git=${#git} - 10))
  else
      git=0
  fi

  local termwidth
  (( termwidth = ${COLUMNS} - 3 - ${#HOST} - ${#$(get_pwd)} - ${git} ))

  local spacing=""
  for i in {1..$termwidth}; do
      spacing="${spacing} "
  done
  echo $spacing
}

# ########## GIT VARIABLES ###########

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$ZSH_THEME_GIT_PROMPT_SUFFIXS"
}

function prompt_char {
  git branch >/dev/null 2>/dev/null && echo '○' && return
  echo '>'
}

# ########## PROMPT VARIABLE ###########

PROMPT='
%{$fg[green]%}$(get_pwd)%{$reset_color%} 🕕  %{$fg[green]%}%*%{$reset_color%}$(put_spacing)$(git_prompt_info)
$(prompt_char) '

# ########## ZSH GIT THEME VARIABLES ###########

ZSH_THEME_GIT_PROMPT_PREFIX="git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]✹"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[white]"