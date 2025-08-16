# Quantum Theme For ZSH

# 🎨 Colors
local dir_color="%{$fg_bold[cyan]%}"
local branch_name_color="%{$fg_bold[yellow]%}"
local detached_color="%{$fg_bold[red]%}"
local arrow_color="%{$fg_bold[green]%}"
local reset="%{$reset_color%}"

# 📁 Current folder name
function quantum_dir_name() {
  if [[ "$PWD" == "$HOME" ]]; then
    echo "${dir_color}~${reset}"
  elif [[ "$PWD" == "/" ]]; then
    echo "${dir_color}/${reset}"
  else
    echo "${dir_color}${PWD##*/}${reset}"
  fi
}

# 🌿 Git branch (symbol + name only if on branch)
function quantum_git_info() {
  git rev-parse --is-inside-work-tree &>/dev/null || return

  local ref=$(git symbolic-ref --quiet HEAD 2>/dev/null)

  if [[ -n "$ref" ]]; then
    # On a branch
    local branch=${ref##refs/heads/}
    echo " ${arrow_color}»${reset} ${branch_name_color} ${branch}${reset}"
  else
    # Detached HEAD
    local commit=$(git rev-parse --short HEAD 2>/dev/null)
    echo " ${arrow_color}»${reset} ${detached_color}${commit}${reset}"
  fi
}

# 🚀 Prompt
PROMPT='$(quantum_dir_name)$(quantum_git_info) ${arrow_color}»${reset} '
