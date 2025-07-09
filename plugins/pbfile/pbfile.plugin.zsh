# Check if running on macOS
if [[ "$OSTYPE" != darwin* ]]; then
  return
fi

function pbfile() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: pbfile <file>"
    return 1
  fi
  
  if [[ ! -e "$1" ]]; then
    echo "File not found: $1"
    return 1
  fi
  
  osascript -e "tell application \"Finder\" to set the clipboard to (POSIX file \"$(realpath "$1")\")"
  echo "Copied $1 to pasteboard"
}
