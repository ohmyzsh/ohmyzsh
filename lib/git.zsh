# get the name of the branch we are on
function git_prompt_info() {
  local type=${1:-$branch} # ; [[ -n "$type" ]] || type='branch'

  branch=$(current_branch) || return
  d_branch="$branch"
  case $type in
    *abbr*)
	     d_branch=${branch/master/M}
	     ;;
  esac

  d_commit='';

  echo "$ZSH_THEME_GIT_PROMPT_PREFIX${d_branch}$(parse_git_dirty)$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

parse_git_dirty () {
  if [[ $((git status 2> /dev/null) | tail -n1) != "nothing to commit (working directory clean)" ]]; then
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi
}

#
# Will return the current branch name
# Usage example: git pull origin $(current_branch)
#
function current_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

#
# current branch for display.  Abbreviate master to M.  
# Other substitutions are possible.
# TODO: 
#   * allow to enable/disable translation of master to M.  
#   * enable argument to git_prompt_info control what is displayed 
#      (eg: M=535516, ala git-prompt project for bash)
function current_branch_for_display() {
  branch=$(current_branch) || return
  echo ${branch/master/M}    # master abbreviated to M.
}
