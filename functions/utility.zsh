# Lists the ten most used commands.
function history-stat() {
  history | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

# Makes a directory and changes to it.
function mkdcd() {
  mkdir -p "$@"
  cd "$argv[-1]"
}
compdef _mkdir mkdcd

# Changes to a directory and lists its contents.
function cdll() {
  builtin cd "$@"
  ll
}
compdef _cd cdll

# Pushes an entry onto the directory stack and lists its contents.
function pushdll() {
  builtin pushd "$@"
  ll
}
compdef _cd pushdll

# Pops an entry off the directory stack and lists its contents.
function popdll() {
  builtin popd "$@"
  ll
}
compdef _cd popdll

# Gets ownership.
function gown() {
  sudo chown -R "${USER}" "${1:-.}"
}

# Reloads ~/.zshrc.
function reload() {
  local zshrc="$HOME/.zshrc"
  if [[ -n "$1" ]]; then
    zshrc="$1"
  fi
  source "$zshrc"
}

# Provides a simple calculator.
function calc() {
  echo "scale=4; $@" | bc -l
}

# Displays human readable disk usage statistics.
function duh() {
  (( $# == 0 )) && set -- *
  if [[ "$OSTYPE" == linux* ]]; then
    du -khsc "$@" | sort -h -r
  else
    du -kcs "$@" | awk '{ printf "%9.1fM    %s\n", $1 / 1024, $2 } ' | sort -n -r
  fi
}
compdef _du duh

# Prints columns 1 2 3 ... n.
function slit() {
  awk "{ print $(for n; do echo -n "\$$n,"; done | sed 's/,$//') }"
}

# Displays user owned process status.
function pmine() {
  ps "$@" -u "$USER" -o pid,%cpu,%mem,command
}
compdef _ps pmine

# Finds files and executes a command on them.
function findexec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Serves a directory via HTTP.
function httpserve() {
  python -m SimpleHTTPServer "$@"
}

