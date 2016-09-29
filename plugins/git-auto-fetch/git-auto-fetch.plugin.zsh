function git_fetch_on_chpwd {
  ([[ -d .git ]] && git fetch --all &>! ./.git/FETCH_LOG &)
}
chpwd_functions+=(git_fetch_on_chpwd)
git_fetch_on_chpwd
