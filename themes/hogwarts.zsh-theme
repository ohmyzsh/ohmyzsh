# =======================================
# Hogwarts Zsh Theme
# Author: TheWinterShadow
# A colorful two-line prompt inspired by Hogwarts houses.
# Shows user@host, time, path, git branch/status, and tmux/screen info.
# =======================================

# Enable prompt substitution (needed for $(...) and colors)
setopt PROMPT_SUBST

# Hogwarts House Colors (ANSI)
user_color="%F{196}"       # Scarlet (Gryffindor)
host_color="%F{34}"         # Emerald (Slytherin)
screen_color="%F{226}"      # Gold (Hufflepuff)
time_color="%F{226}"        # Gold (Hufflepuff)
path_color="%F{27}"         # Ravenclaw Blue
git_branch_color="%F{196}"  # Scarlet
git_status_color="%F{250}"  # Light Gray
reset_color="%f"

# Git branch name
parse_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ -n $branch ]]; then
    echo "${git_branch_color}git:${branch}${reset_color}"
  fi
}

# Git ahead/behind
parse_git_arrows() {
  git rev-parse --is-inside-work-tree &>/dev/null || return
  local ahead behind
  ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null)
  behind=$(git rev-list --count HEAD..@{u} 2>/dev/null)

  if [[ $ahead -gt 0 || $behind -gt 0 ]]; then
    local arrows=""
    [[ $ahead -gt 0 ]] && arrows+="↑${ahead} "
    [[ $behind -gt 0 ]] && arrows+="↓${behind}"
    echo "${git_status_color}${arrows}${reset_color}"
  fi
}

# Git clean/dirty
parse_git_dirty() {
  local git_changes
  git_changes=$(git status --porcelain 2>/dev/null)
  if [[ -n $git_changes ]]; then
    echo "%F{196}✗%f"   # Red ✗ for dirty
  else
    echo "%F{34}✓%f"    # Green ✓ for clean
  fi
}

# Screen/Tmux session indicator
current_session() {
  if [[ -n "$STY" ]]; then
    echo "${screen_color}[screen:${STY}]${reset_color}"
  elif [[ -n "$TMUX" ]]; then
    echo "${screen_color}[tmux:$(tmux display-message -p '#S')]${reset_color}"
  fi
}

# First line prompt
PROMPT="%{$user_color%}%n%{$reset_color%}@%{$host_color%}%m%{$reset_color%} \
\$(current_session) \
%{$time_color%}[%*]%{$reset_color%} \
%{$path_color%}%~%{$reset_color%} \
\$(parse_git_branch) \$(parse_git_arrows) \$(parse_git_dirty)
"

# Second line input prompt
PROMPT+="%(?.%F{34}.%F{196})❯%f "

# No right prompt
RPROMPT=''
