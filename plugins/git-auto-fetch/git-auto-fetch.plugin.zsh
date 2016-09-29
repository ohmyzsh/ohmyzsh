function git_fetch_on_chpwd {
  ([[ -d .git ]] && git fetch --all >! ./.git/FETCH_LOG &)
}
chpwd_functions=(${chpwd_functions[@]} "git_fetch_on_chpwd")
unset git_fetch_on_cpwd
