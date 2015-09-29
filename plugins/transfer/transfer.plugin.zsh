# From https://transfer.sh/
# Modified by Gabriel Kaam <gabriel@kaam.fr>

function transfer() {
  if [[ $# -eq 0 ]]; then
    cat<<EOF
No arguments specified. Usage:
transfer /tmp/test.md
cat /tmp/test.md | transfer test.md
EOF
    return 1
  fi

  basefile=$(omz_urlencode "${1:t}")

  if tty -s; then
    url=$(curl --progress-bar --upload-file "$1" "https://transfer.sh/$basefile")
  else
    url=$(curl --progress-bar --upload-file "-" "https://transfer.sh/$basefile")
  fi

  echo $url
}

alias transfer=transfer
