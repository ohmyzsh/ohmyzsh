function tab() {
  osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell
EOF
}

# Functions for opening/finding/selecting things in OS X Finder

function finder() {
    if [[ $# -eq 0 ]]; then
        open $PWD
    elif [[ $# -eq 1 ]]; then
        open $1
    else
        for dir in $argv; do
            open $dir
        done
    fi
}