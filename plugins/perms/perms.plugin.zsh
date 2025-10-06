# Some useful commands for setting permissions.
#
# Rory Hardy [GneatGeek]
# Andrew Janke [apjanke]

### Aliases

# Set all files' permissions to 644 recursively in a directory
function set644 {
	find "${@:-.}" -type f ! -perm 644 -print0 | xargs -0 chmod 644
}

# Set all directories' permissions to 755 recursively in a directory
function set755 {
	find "${@:-.}" -type d ! -perm 755 -print0 | xargs -0 chmod 755
}

### Functions

# resetperms - fix permissions on files and directories, with confirmation
# Returns 0 on success, nonzero if any errors occurred
function resetperms {
  local opts confirm target exit_status chmod_opts use_slow_mode
  zparseopts -E -D -a opts -help -slow v+=chmod_opts
  if [[ $# > 1 || -n "${opts[(r)--help]}" ]]; then
    cat <<EOF
Usage: resetperms [-v] [--help] [--slow] [target]

  target  is the file or directory to change permissions on. If omitted,
          the current directory is taken to be the target.

  -v      enables verbose output (may be supplied multiple times)

  --slow  will use a slower but more robust mode, which is effective if
          directories themselves have permissions that forbid you from
          traversing them.

EOF
    exit_status=$(( $# > 1 ))
    return $exit_status
  fi

  if [[ $# -eq 0 ]]; then
    target="."
  else
    target="$1"
  fi
  if [[ -n ${opts[(r)--slow]} ]]; then use_slow=true; else use_slow=false; fi

  # Because this requires confirmation, bail in noninteractive shells
  if [[ ! -o interactive ]]; then
    echo "resetperms: cannot run in noninteractive shell"
    return 1
  fi

  echo "Fixing perms on $target?"
  printf '%s' "Proceed? (y|n) "
  read confirm
  if [[ "$confirm" != y ]]; then
    # User aborted
    return 1
  fi

  # This xargs form is faster than -exec chmod <N> {} \; but will encounter
  # issues if the directories themselves have permissions such that you can't
  # recurse in to them. If that happens, just rerun this a few times.
  exit_status=0;
  if [[ $use_slow == true ]]; then
    # Process directories first so non-traversable ones are fixed as we go
    find "$target" -type d ! -perm 755 -exec chmod $chmod_opts 755 {} \;
    if [[ $? -ne 0 ]]; then exit_status=$?; fi
    find "$target" -type f ! -perm 644 -exec chmod $chmod_opts 644 {} \;
    if [[ $? -ne 0 ]]; then exit_status=$?; fi
  else
    find "$target" -type d ! -perm 755 -print0 | xargs -0 chmod $chmod_opts 755
    if [[ $? -ne 0 ]]; then exit_status=$?; fi
    find "$target" -type f ! -perm 644 -print0 | xargs -0 chmod $chmod_opts 644
    if [[ $? -ne 0 ]]; then exit_status=$?; fi
  fi
  echo "Complete"
  return $exit_status
}

function fixperms {
  print -ru2 "fixperms has been deprecated. Use resetperms instead"
  return 1
}
