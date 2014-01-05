# get the name of the branch we are on
function git_prompt_info() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}


# Checks if working tree is dirty
parse_git_dirty() {
  [[ GIT_HIDE == 'true' ]] && return
  if git_is_clean; then
    echo $ZSH_THEME_GIT_PROMPT_CLEAN
  else
    echo $ZSH_THEME_GIT_PROMPT_DIRTY
  fi
}

git_is_clean() {
  [[ $(command git status -s $GIT_STATUS_OPTIONS 2> /dev/null) == '' ]]
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(command git rev-parse --short HEAD 2> /dev/null) && \
    echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(command git rev-parse HEAD 2> /dev/null) && \
    echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# get the difference between the local and remote branches
git_remote_status() {
  local val
  local remote
  local return_str
  remote=${1:=$(command git status --porcelain -b 2> /dev/null | head -1)}

  for val in ahead behind diverged; do
    echo $remote | grep "##.*$val" &>/dev/null && \
      return_str+=$(eval echo \$ZSH_THEME_GIT_PROMPT_$val:u)
  done
  echo $return_str
}

# provides an associative array with instructions
# used by grep in git_prompt_status
git_prompt_status_setup() {
  declare -Ag ZSH_THEME_GIT_PROMPT_MOD_MAP
  # need to shield the vars with quotes, because they might
  # be empty strings!
  ZSH_THEME_GIT_PROMPT_MOD_MAP=(
    "\?\?" "$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    "A" "$ZSH_THEME_GIT_PROMPT_ADDED"
    "[MT]" "$ZSH_THEME_GIT_PROMPT_MODIFIED"
    "D" "$ZSH_THEME_GIT_PROMPT_DELETED"
    "UU" "$ZSH_THEME_GIT_PROMPT_UNMERGED"
  )
}

has_stashed_commits() {
  command git rev-parse --verify refs/stash &>/dev/null
}

# Get the status of the working tree
git_prompt_status() {
  local key
  local index
  local remote_line
  local status_syms
  local return_str=''
  index=$(command git status --porcelain -b 2> /dev/null)
  remote_line=$(echo $index | head -1)
  status_syms=$(echo $index | awk '{ print $1 }')

  for key in ${(k)ZSH_THEME_GIT_PROMPT_MOD_MAP}; do
    echo $status_syms | grep -E "$key" &>/dev/null && \
      return_str+=$ZSH_THEME_GIT_PROMPT_MOD_MAP[$key]
  done

  return_str+=$(git_remote_status $remote_line)
  has_stashed_commits && return_str+=$ZSH_THEME_GIT_PROMPT_STASHED

  echo $return_str
}

#compare the provided version of git to the version installed and on path
#prints 1 if installed version > input version
#prints -1 otherwise
function is_recent_git_version() {
  local not_recent_git
  local installed_git
  not_recent_git=(1 7 2);
  installed_git=($(command git --version 2>/dev/null));
  installed_git=(${(s/./)installed_git[3]});

  for i in {1..3}; do
    if [[ $installed_git[$i] -gt $not_recent_git[$i] ]]; then
      return 0
    fi
  done
  return 1
}

function set_git_status_options() {
  GIT_STATUS_OPTIONS=''
  if is_recent_git_version; then
    GIT_STATUS_OPTIONS+='--ignore-submodules=dirty'
  fi
  if [[ $DISABLE_UNTRACKED_FILES_DIRTY == 'true' ]]; then
    GIT_STATUS_OPTIONS+=' -uno'
  fi
}

function check_git_show_status() {
  if [[ $(command git config --get oh-my-zsh.hide-status) != "1" ]]; then
    # no need to set options if status is hidden anyway
    set_git_status_options
  else
    GIT_HIDE='true'
  fi
}
#this is unlikely to change so make it all statically assigned
check_git_show_status
git_prompt_status_setup

