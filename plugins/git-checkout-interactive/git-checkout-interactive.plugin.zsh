#######################################
#       git checkout interactive      #
#######################################

function git-checkout-interactive() {
  local ITEMS_TO_SHOW=10
  # Get all branches sorted by committer date, along with their last commit hash
  local branches
  branches=$(git for-each-ref --count="$ITEMS_TO_SHOW" --sort=-committerdate --format='%(refname:short) %(objectname:short)' refs/heads/)

  # Parse branches
  local branch_list=()
  local current_branch
  current_branch=$(git rev-parse --abbrev-ref HEAD)
  if [[ "$current_branch" == "" ]]; then
    return 0
  fi
  while read -r branch hash; do
    if [[ "$branch" == "$current_branch" ]]; then
      echo "On branch $branch \n"
    else
      branch_list+=("$branch ($hash)")
    fi
  done <<< "$branches"

  if (( ${#branch_list} == 0 )); then
    echo "No other branches available."
    return 0
  else
    echo "Select a branch to switch to:\n"
  fi

  # Display menu
  local i=1
  for branch in "${branch_list[@]}"; do
    echo "($i) $branch"
    ((i++))
  done
  echo -n "\nPlease enter your choice: "
  
  # Handle user input
  while :; do
    local choice
    read -r choice
    if (( choice > 0 && choice <= ${#branch_list[@]} )); then
      local selected_branch="${branch_list[$((choice))]}"
      local target_branch="${selected_branch//->}"
      target_branch="${target_branch%% *}"
      git checkout "$target_branch"
      break
    else
      break
    fi
  done
}

alias gci="git-checkout-interactive || return 0"
