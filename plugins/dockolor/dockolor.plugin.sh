dockolor_has_awk() {
  if command -v awk >/dev/null 2>&1; then
    echo true
  else
    echo false
  fi
}

dockolor_colorize() {
docker ps "$@" --no-trunc | awk '
  BEGIN {
    RED = "\033[0;31m"
    GREEN = "\033[0;32m"
    YELLOW = "\033[1;33m"
    RESET = "\033[0m"
  }

  # skip the first line because it containt header
  # reminder, NR > built-in var in awk
  NR == 1 {
    print $0
    next
  }

  # set the color in fc of the status
  {
    line = $0
    lower = tolower(line)
    if (lower ~ /up/ || lower ~ /running/) {
      color = GREEN
    } else if (lower ~ /paused/) {
      color = YELLOW
    } else if (lower ~ /exited/ || lower ~ /dead/) {
      color = RED
    } else {
      color = RESET
    }
    printf "%s%s%s\n", color, line, RESET
  }'
}

dockolor_dps() {
  if [ "$(dockolor_has_awk)" = false ]; then
    echo "You have installed dockolor but you don't have awk installed"
    docker ps "$@" --no-trunc
  else
    dockolor_colorize "$@"
  fi
}

# main function
dockolor() {
  dockolor_dps "$@"
}

# if the user have the docker plugin loaded
# we remove the alias
# and replace it with the colored version of it
if alias dps >/dev/null 2>&1; then
  unalias dps
fi

if alias dpsa >/dev/null 2>&1; then
  unalias dpsa
fi

dps() {
  dockolor_dps "$@"
}

dpsa() {
  dockolor_dps -a "$@"
}
