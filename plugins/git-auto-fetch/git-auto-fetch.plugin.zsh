function git-fetch-on-chpwd {
  (`git rev-parse --is-inside-work-tree 2>/dev/null` &&
  dir=`git rev-parse --git-dir` &&
  [[ ! -f $dir/NO_AUTO_FETCH ]] &&
  git fetch --all &>! $dir/FETCH_LOG &)
}

function git-auto-fetch {
  `git rev-parse --is-inside-work-tree 2>/dev/null` || return
  guard="`git rev-parse --git-dir`/NO_AUTO_FETCH"

  (rm $guard 2>/dev/null &&
    echo "${fg_bold[green]}enabled${reset_color}") ||
  (touch $guard &&
    echo "${fg_bold[red]}disabled${reset_color}")
}

chpwd_functions+=(git-fetch-on-chpwd)
git-fetch-on-chpwd
unset git-fetch-on-chpwd
