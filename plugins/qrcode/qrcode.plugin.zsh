# Imported and improved from https://qrcode.show/, section SHELL FUNCTIONS

_qrcode_show_message() {
  echo "Type or paste your text, add a new blank line, and press ^d"
}

qrcode () {
  local input="$*"
  [ -z "$input" ] && _qrcode_show_message && local input="@/dev/stdin"
  curl -d "$input" https://qrcode.show
}

qrsvg () {
  local input="$*"
  [ -z "$input" ] && _qrcode_show_message && local input="@/dev/stdin"
  curl -d "$input" https://qrcode.show -H "Accept: image/svg+xml"
}
