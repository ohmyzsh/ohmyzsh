# Outputs current branch info in prompt format
function git_prompt_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# Checks if working tree is dirty
function parse_git_dirty() {
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

# Gets the difference between the local and remote branches
function git_remote_status() {
    local remote ahead behind git_remote_status git_remote_status_detailed
    remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]]; then
        ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}"
        elif [[ $behind -gt 0 ]] && [[ $ahead -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        elif [[ $ahead -gt 0 ]] && [[ $behind -gt 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
            git_remote_status_detailed="$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE$((ahead))%{$reset_color%}$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE$((behind))%{$reset_color%}"
        fi

        if [[ -n $ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX$remote$git_remote_status_detailed$ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX"
        fi

        echo $git_remote_status
    fi
}

# Outputs the name of the current branch
# Usage example: git pull origin $(git_current_branch)
# Using '--quiet' with 'symbolic-ref' will not cause a fatal error (128) if
# it's not a symbolic ref, but in a Git repo.
function git_current_branch() {
  local ref
  ref=$(command git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret != 0 ]]; then
    [[ $ret == 128 ]] && return  # no git repo.
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  fi
  echo ${ref#refs/heads/}
}


# Gets the number of commits ahead from remote
function git_commits_ahead() {
  if $(echo "$(command git log @{upstream}..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    local COMMITS=$(command git log @{upstream}..HEAD | grep '^commit' | wc -l | tr -d ' ')
    echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$COMMITS$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
  fi
}

# Outputs if current branch is ahead of remote
function git_prompt_ahead() {
  if [[ -n "$(command git rev-list origin/$(git_current_branch)..HEAD 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Outputs if current branch is behind remote
function git_prompt_behind() {
  if [[ -n "$(command git rev-list HEAD..origin/$(git_current_branch) 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
}

# Outputs if current branch exists on remote or not
function git_prompt_remote() {
  if [[ -n "$(command git show-ref origin/$(git_current_branch) 2> /dev/null)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_EXISTS"
  else
    echo "$ZSH_THEME_GIT_PROMPT_REMOTE_MISSING"
  fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  local SHA=$(command git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  local SHA=$(command git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Get the status of the working tree
function git_prompt_status() {
  local INDEX STATUS
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNTRACKED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^A  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  elif $(echo "$INDEX" | grep '^M  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_ADDED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ M ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^AM ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  elif $(echo "$INDEX" | grep '^ T ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_MODIFIED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^R  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_RENAMED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^ D ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^D  ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  elif $(echo "$INDEX" | grep '^AD ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DELETED$STATUS"
  fi
  if $(command git rev-parse --verify refs/stash >/dev/null 2>&1); then
    STATUS="$ZSH_THEME_GIT_PROMPT_STASHED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^UU ' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_UNMERGED$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## .*ahead' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## .*behind' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## .*diverged' &> /dev/null); then
    STATUS="$ZSH_THEME_GIT_PROMPT_DIVERGED$STATUS"
  fi
  echo $STATUS
}

# Compares the provided version of git to the version installed and on path
# Outputs -1, 0, or 1 if the installed version is less than, equal to, or
# greater than the input version, respectively.
function git_compare_version() {
  local INPUT_GIT_VERSION=$1;
  local INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${(s/./)INPUT_GIT_VERSION});
  INSTALLED_GIT_VERSION=($(command git --version 2>/dev/null));
  INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]});

  for i in {1..3}; do
    if [[ $INSTALLED_GIT_VERSION[$i] -gt $INPUT_GIT_VERSION[$i] ]]; then
      echo 1
      return 0
    fi
    if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
      echo -1
      return 0
    fi
  done
  echo 0
}

# This is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")
# Clean up the namespace slightly by removing the checker function
unset -f git_compare_version
