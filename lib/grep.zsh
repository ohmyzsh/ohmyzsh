# see if we already cached the grep alias in past day
_grep_alias_cache=("$ZSH_CACHE_DIR"/grep_alias.zsh(Nm-24))
if (( $#_grep_alias_cache )); then
  source "$ZSH_CACHE_DIR"/grep_alias.zsh
else
  # is x grep argument available?
  grep-flag-available() {
    echo | grep $1 "" >/dev/null 2>&1
  }

  GREP_OPTIONS=""

  # color grep results
  if grep-flag-available --color=auto; then
    GREP_OPTIONS+=" --color=auto"
  fi

  # ignore VCS folders (if the necessary grep flags are available)
  VCS_FOLDERS="{.bzr,CVS,.git,.hg,.svn}"

  if grep-flag-available --exclude-dir=.cvs; then
    GREP_OPTIONS+=" --exclude-dir=$VCS_FOLDERS"
  elif grep-flag-available --exclude=.cvs; then
    GREP_OPTIONS+=" --exclude=$VCS_FOLDERS"
  fi

  # export grep settings
  alias grep="grep $GREP_OPTIONS"
  echo "alias grep=\"grep $GREP_OPTIONS\"" > "$ZSH_CACHE_DIR"/grep_alias.zsh

  # clean up
  unset GREP_OPTIONS
  unset VCS_FOLDERS
  unfunction grep-flag-available
fi
unset _grep_alias_cache
