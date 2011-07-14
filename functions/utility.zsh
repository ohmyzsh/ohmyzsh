function history-stat() {
  history | awk '{print $2}' | sort | uniq -c | sort -rn | head
}

function mkdcd() {
  mkdir -p "$1"
  cd "$1"
}

function cdll() {
  if [[ -n "$1" ]]; then
    builtin cd "$1"
    ls -lFhA
  else
    ls -lFhA
  fi
}

function pushdll() {
  if [[ -n "$1" ]]; then
    builtin pushd "$1"
    ls -lFhA
  else
    ls -lFhA
  fi
}

function popdll() {
  builtin popd
  ls -lFhA
}

function gown() {
  sudo chown -R "${USER}" "${1:-.}"
}

function reload() {
  local zshrc="$HOME/.zshrc"
  if [[ -n "$1" ]]; then
    zshrc="$1"
  fi
  source "$zshrc"
}

function calc() {
  echo "scale=4; $@" | bc -l
}

function pmine() {
  ps "$@" -u "$USER" -o pid,%cpu,%mem,command
}

function findexec() {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" {} \;
}

function httpserve() {
  python -m SimpleHTTPServer "$@"
}

