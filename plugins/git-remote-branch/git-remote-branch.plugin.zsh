_git_remote_branch() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    if (( CURRENT == 2 )); then
      # first arg: operation
      compadd new push mv rm pull track remote_add remote_rm prune
    elif (( CURRENT == 3 )); then
      # second arg: remote branch name
      compadd --explain `git branch -r | grep -v HEAD | sed "s/.*\///" | sed "s/ //g"`
    elif (( CURRENT == 4 )); then
      # third arg: remote name
      compadd `git remote` --explain `git branch -r | grep -v HEAD | sed "s/.*\///" | sed "s/ //g"`
    fi
  else;
    _files
  fi
}
compdef _git_remote_branch grb
