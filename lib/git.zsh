# lib/git.zsh - Various functions for incorporating git status info 
# into the zsh PROMPT.


# Constructs the git info section of the prompt
# This prompt section includes the current branch and a short clean/dirty indicator
function git_prompt_info() {
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

# A simple clean/dirty status check
# Outputs a brief clean/dirty/timeout string that indicates whether the repo has uncommitted changes.
# This is in contrast to git_prompt_info, which provides a
# lengthier status string with more possible indicators.
# This quick test does not require the full output of `git status`
function git_prompt_dirty() {
  local GIT_ARGS STATUS GIT_STATUS_OUT
  # Always use visible error indicator even if theme doesn't define one, to avoid silently
  # looking like a clean directory when we can't get info
  local TIMEDOUT_TXT=${ZSH_THEME_GIT_PROMPT_TIMEDOUT:-???}
  GIT_ARGS=(status '--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      GIT_ARGS+='--ignore-submodules=dirty'
    fi
    if [[ $DISABLE_UNTRACKED_FILES_DIRTY == "true" ]]; then
      GIT_ARGS+='--untracked-files=no'
    fi
  fi
  # Use a serverized git run to timebox `git status` so slow repo access doesn't hang the prompt
  _git_status_timeboxed_oneline
  STATUS=$?
  if [[ $STATUS != 0 ]]; then
    echo $TIMEDOUT_TXT
  elif [[ -n $GIT_STATUS_OUT ]]; then
    echo $ZSH_THEME_GIT_PROMPT_DIRTY
  else
    echo $ZSH_THEME_GIT_PROMPT_CLEAN
  fi
}

# Back-compatibility alias for git_prompt_dirty()
function parse_git_dirty() {
  git_prompt_dirty
}

# A time-boxed serverized invocation of `git status` that gets just the 
# first line of output. This prevents locking up the prompt on slow repos.
# _git_status_timeboxed_one output_var
#  IN: $GIT_ARGS - arguments to pass to git (array)
#  OUT: $GIT_STATUS_OUT - output of the git command
#  RETURN: 0 if git command completed, 1 if timed out or other error occurred
function _git_status_timeboxed_oneline() {
  local SYS_TMPDIR=${${TMPDIR:-$TEMP}:-/tmp}
  if [[ ! -d $SYS_TMPDIR ]]; then
    return 1
  fi
  local OMZ_TMPDIR=$SYS_TMPDIR/oh-my-zsh
  if [[ ! -d $OMZ_TMPDIR ]]; then
    if ! mkdir -p $OMZ_TMPDIR; then
      return 1
    fi
  fi
  local GIT_FIFO=$OMZ_TMPDIR/omz-prompt-git.$$
  # Clean up any leftover from previous aborted run
  [[ -f $GIT_FIFO ]] && rm -f $GIT_FIFO
  if ! mkfifo $GIT_FIFO; then
    return 1
  fi
  command git $GIT_ARGS >$GIT_FIFO 2>/dev/null &
  local GIT_PID=$!
  # Use dummy "__unset__" to distinguish timeouts from empty output
  local STATUS=__unset__
  read -t $ZSH_THEME_SCM_CHECK_TIMEOUT STATUS <$GIT_FIFO

  rm $GIT_FIFO
  if [[ $STATUS == __unset__ ]]; then
    # Variable didn't get set = read timeout
    # Get rid of that git run if it's still going
    kill -s KILL $GIT_PID &>/dev/null
    GIT_STATUS_OUT=''
    return 1
  elif [[ -z $STATUS ]]; then
    GIT_STATUS_OUT=''
    return 0
  else
    # Get rid of that git run if it's still going
    kill -s KILL $GIT_PID &>/dev/null
    GIT_STATUS_OUT="$STATUS"
    return 0
  fi
}

# Gets the difference between the local and remote branches
function git_remote_status() {
  remote=${$(command git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
  if [[ -n ${remote} ]] ; then
    ahead=$(command git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    behind=$(command git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

    if [ $ahead -eq 0 ] && [ $behind -gt 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
    elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
    elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]; then
      echo "$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
    fi
  fi
}

# Checks if there are commits ahead from remote
function git_prompt_ahead() {
  if $(echo "$(command git log @{upstream}..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    echo "$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
}

# Gets the number of commits ahead from remote
function git_commits_ahead() {
  if $(echo "$(command git log @{upstream}..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    COMMITS=$(command git log @{upstream}..HEAD | grep '^commit' | wc -l | tr -d ' ')
    echo "$ZSH_THEME_GIT_COMMITS_AHEAD_PREFIX$COMMITS$ZSH_THEME_GIT_COMMITS_AHEAD_SUFFIX"
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

# Get the status of the working tree
git_prompt_status() {
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
# Prints 1 if installed version > input version
# Prints -1 if installed version < input version
# Prints 0 if installed version = input version
# Always returns 0
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
