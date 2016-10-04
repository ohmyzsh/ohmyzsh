function git_fetch_on_chpwd {
  ([[ -d .git ]] && [[ ! -f ".git/NO_AUTO_FETCH" ]] && git fetch --all &>! .git/FETCH_LOG &)
}

function git-auto-fetch {
  [[ ! -d .git ]] && return
  if [[ -f ".git/NO_AUTO_FETCH" ]]; then
    rm ".git/NO_AUTO_FETCH" && echo "disabled"
  else
    touch ".git/NO_AUTO_FETCH" && echo "enabled"
  fi
}
chpwd_functions+=(git_fetch_on_chpwd)
git_fetch_on_chpwd
unset git_fetch_on_chpwd
