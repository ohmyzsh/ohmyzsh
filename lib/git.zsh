# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
parse_git_dirty() {
  if [[ -n $(git status -s --ignore-submodules=dirty 2> /dev/null) ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(git log origin/$(current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
git_prompt_status() {
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""
  if [ "${INDEX#?? }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if [ "${INDEX#A  }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif [ "${INDEX#M  }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if [ "${INDEX# M }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif [ "${INDEX#AM }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif [ "${INDEX# T }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if [ "${INDEX#R  }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if [ "${INDEX# D }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif [ "${INDEX#AD }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if [ "${INDEX#UU }" != "$INDEX" ]; then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  echo $STATUS
}
