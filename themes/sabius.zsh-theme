prompt_end() {
  # Adds the input to a new line prepended by a >
  if [[ -n $CURRENT_BG ]]; then
      print -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
      print -n "%{%k%}"
  fi

  print -n "%{%f%}%{$fg[blue]"
  CURRENT_BG=''

  #Adds the new line and ➜ as the start character.
  printf "\n> "
}

custom_git_branch() {
  # Gets the current Git branch name and strips any additional formatting.
  local branch_name=$(git branch --show-current 2>/dev/null)
  echo $branch_name
}

git_changes_summary() {
  local staged=$(git diff --cached --numstat | wc -l | tr -d ' ')
  local unstaged=$(git diff --numstat | wc -l | tr -d ' ')
  local untracked=$(git ls-files --others --exclude-standard | wc -l | tr -d ' ')
  local summary=""

  if [ "$staged" -ne "0" ]; then
      summary="%{$fg[green]%}S:$staged"
  fi

  # Combining unstaged and untracked counts for the total number of changes not staged for commit
  local total_unstaged=$((unstaged + untracked))

  if [ "$total_unstaged" -ne "0" ]; then
      if [ -n "$summary" ]; then
          summary="$summary "
      fi
      summary="${summary}%{$fg[red]%}U:$total_unstaged"
  fi

  echo $summary
}

custom_git_prompt() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local git_status="$(git status --porcelain=v1 2>/dev/null)"
    local branch=$(custom_git_branch)
    if [[ -n $git_status ]]; then
      # Repository is dirty or has changes
      echo "%{$fg[blue]%}on %{$fg[yellow]%}${branch} $(git_changes_summary)"
    else
      # Repository is clean
      echo "%{$fg[blue]%}on %{$fg[yellow]%}${branch}"
    fi
  fi
}

PROMPT="%(?:%{$fg[green]%}%1{➜%}:%{$fg[red]%}%1{➜%})%{$reset_color%} %2~% "
PROMPT+=' %{$fg[green]%}$(custom_git_prompt)%b$(prompt_end)%{$reset_color%}'
