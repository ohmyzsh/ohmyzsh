# From https://transfer.sh/
# Modified by Gabriel Kaam <gabriel@kaam.fr>

function transfer() {
  if [[ $# -eq 0 ]]; then
    cat >&2 <<EOF
No arguments specified.

Usage: transfer /tmp/test.md
cat /tmp/test.md | transfer test.md

Learn more: https://transfer.sh/
EOF
    return 1
  fi

  local basefile url infile="$1"

  basefile=$(omz_urlencode "${infile:t}")

  if [[ -z $infile ]]; then
    infile="-"
  fi

  url=$(curl --progress-bar --upload-file "$infile" "https://transfer.sh/$basefile")

  echo $url
}

alias transfer=transfer
