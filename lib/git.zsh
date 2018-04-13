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

        if [[ $ahead -eq 0 ]] && [[ $behind -eq 0 ]]; then
            git_remote_status="$ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE"
        elif [[ $ahead -gt 0 ]] && [[ $behind -eq 0 ]]; then
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
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count @{upstream}..HEAD)"
    if [[ "$commits" != 0 ]]; then
      echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$commits$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
    fi
  fi
}

# Gets the number of commits behind remote
function git_commits_behind() {
  if command git rev-parse --git-dir &>/dev/null; then
    local commits="$(git rev-list --count HEAD..@{upstream})"
    if [[ "$commits" != 0 ]]; then
      echo "$ZSH_THEME_GIT_COMMITS_BEHIND_PREFIX$commits$ZSH_THEME_GIT_COMMITS_BEHIND_SUFFIX"
    fi
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
  local SHA
  SHA=$(command git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  local SHA
  SHA=$(command git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

function git_prompt_status() {
  local status_prompt=""

  # A lookup table of each git status encountered
  local -A statuses_seen

  # Maps a git status prefix to an internal constant
  # This cannot use the prompt constants, as they may be empty
  local -A prefix_constant_map=(
    '?? '       'UNTRACKED'
    'A  '       'ADDED'
    'M  '       'ADDED'
    ' M '       'MODIFIED'
    'AM '       'MODIFIED'
    ' T '       'MODIFIED'
    'R  '       'RENAMED'
    ' D '       'DELETED'
    'D  '       'DELETED'
    'UU '       'UNMERGED'
    'ahead'     'AHEAD'
    'behind'    'BEHIND'
    'diverged'  'DIVERGED'
    'stashed'   'STASHED'
  )

  # Maps the internal constant to the prompt theme
  local -A constant_prompt_map=(
    'UNTRACKED' "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    'ADDED'     "$ZSH_THEME_GIT_PROMPT_ADDED"
    'MODIFIED'  "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    'RENAMED'   "$ZSH_THEME_GIT_PROMPT_RENAMED"
    'DELETED'   "$ZSH_THEME_GIT_PROMPT_DELETED"
    'UNMERGED'  "$ZSH_THEME_GIT_PROMPT_UNMERGED"
    'AHEAD'     "$ZSH_THEME_GIT_PROMPT_AHEAD"
    'BEHIND'    "$ZSH_THEME_GIT_PROMPT_BEHIND"
    'DIVERGED'  "$ZSH_THEME_GIT_PROMPT_DIVERGED"
    'STASHED'   "$ZSH_THEME_GIT_PROMPT_STASHED"
  )

  # The order that the prompt displays should be added to the prompt
  local status_constants=(UNTRACKED ADDED MODIFIED RENAMED DELETED STASHED
                          UNMERGED AHEAD BEHIND DIVERGED)

  local status_text=$(command git status --porcelain -b 2> /dev/null)

  # Don't continue on a catastrophic failure
  if [[ $? -eq 128 ]]; then
    return 1
  fi

  if command git rev-parse --verify refs/stash &>/dev/null; then
    statuses_seen[STASHED]=1
  fi

  local status_lines=("${(@f)${status_text}}");

  # If the tracking line exists, get and parse it
  if [[ $status_lines[1] =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
        continue
      fi
      local last_parsed_status=$prefix_constant_map[$match[1]]
      statuses_seen[$last_parsed_status]=$match[2]
    done
    shift status_lines
  fi

  # This not only gives us a status lookup, but the count of each type
  for status_line in ${status_lines}; do
    local status_prefix=${status_line[1, 3]}
    local status_constant=${(v)prefix_constant_map[$status_prefix]}

    if [[ -z $status_constant ]]; then
      continue
    fi
    
    (( statuses_seen[$status_constant]++ ))
  done

  # At this point, the statuses_seen hash contains:
  # - Tracking      => The difference between tracked and current
  # - Modifications => The count of that type of modification
  # - Stash         => Whether or not a stash exists
  # Might be useful for someone?

  for status_constant in $status_constants; do
    if [[ ${+statuses_seen[$status_constant]} -eq 1 ]]; then
      local next_display=$constant_prompt_map[$status_constant]
      status_prompt="$next_display$status_prompt"
    fi
  done

  echo $status_prompt
}


# Compares the provided version of git to the version installed and on path
# Outputs -1, 0, or 1 if the installed version is less than, equal to, or
# greater than the input version, respectively.
function git_compare_version() {
  local INPUT_GIT_VERSION INSTALLED_GIT_VERSION
  INPUT_GIT_VERSION=(${(s/./)1})
  INSTALLED_GIT_VERSION=($(command git --version 2>/dev/null))
  INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]})

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

# Outputs the name of the current user
# Usage example: $(git_current_user_name)
function git_current_user_name() {
  command git config user.name 2>/dev/null
}

# Outputs the email of the current user
# Usage example: $(git_current_user_email)
function git_current_user_email() {
  command git config user.email 2>/dev/null
}

# This is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")
# Clean up the namespace slightly by removing the checker function
unfunction git_compare_version
