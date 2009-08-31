# get the name of the branch we are on
function git_prompt_info() {
  if [[ -d .git ]]; then
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    branch=${ref#refs/heads/}
    CURRENT_BRANCH="git:(%{$fg[red]%}${branch}%{$fg[blue]%})%{$reset_color%}$(parse_git_dirty)"
  else
    CURRENT_BRANCH=''
  fi

  echo $CURRENT_BRANCH
}

parse_git_dirty () {
  [[ $(git status | tail -n1) != "nothing to commit (working directory clean)" ]] && echo " %{$fg[yellow]%}✗%{$reset_color%}"
}
