# get the name of the branch we are on
function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  branch=${ref#refs/heads/}

  if [[ -d .git ]]; then
    CURRENT_BRANCH="%{$fg[red]%}git:(%{$fg[green]${branch}%{$fg[red])"
  else
    CURRENT_BRANCH=''
  fi


  #echo "%{$fg[red]%}git:(%{$fg[green]$CURRENT_BRANCH%{$fg[red])"
  echo $CURRENT_BRANCH
}

parse_git_dirty () {
  [[ $(git status | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "%{$fg[white] ♻ "
}
