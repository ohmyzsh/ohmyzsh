# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# Checks if working tree is dirty
parse_git_dirty() {
  if [[ -n $(git status -s 2> /dev/null) ]]; then
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
  local indicators line untracked added modified renamed deleted
  while IFS=$'\n' read line; do
    if [[ "$line" =~ '^\?\? ' ]]; then
      [[ -n $untracked ]] && continue || untracked='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_UNTRACKED}${indicators}"
    fi
    if [[ "$line" =~ '^(((A|M|D|T) )|(AD|AM|AT|MM)) ' ]]; then
      [[ -n $added ]] && continue || added='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_ADDED}${indicators}"
    fi
    if [[ "$line" =~ '^(( (M|T))|(AM|AT|MM)) ' ]]; then
      [[ -n $modified ]] && continue || modified='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_MODIFIED}${indicators}"
    fi
    if [[ "$line" =~ '^R  ' ]]; then
      [[ -n $renamed ]] && continue || renamed='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_RENAMED}${indicators}"
    fi
    if [[ "$line" =~ '^( D|AD) ' ]]; then
      [[ -n $deleted ]] && continue || deleted='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_DELETED}${indicators}"
    fi
    if [[ "$line" =~ '^UU ' ]]; then
      [[ -n $unmerged ]] && continue || unmerged='yes'
      indicators="${ZSH_THEME_GIT_PROMPT_UNMERGED}${indicators}"
    fi
  done < <(git status --porcelain 2> /dev/null)
  echo $indicators
}
