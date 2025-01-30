# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Open in Finder the directories passed as arguments, or the current directory if
# no directories are passed
function ofd {
  if (( ! $# )); then
    open_command $PWD
  else
    open_command $@
  fi
}

# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Bluetooth restart
function btrestart() {
  sudo kextunload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
  sudo kextload -b com.apple.iokit.BroadcomBluetoothHostControllerUSBTransport
}

function _omz_macos_get_frontmost_app() {
  osascript 2>/dev/null <<EOF
    tell application "System Events"
      name of first item of (every process whose frontmost is true)
    end tell
EOF
}

function tab() {
  # Must not have trailing semicolon, for iTerm compatibility
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_macos_get_frontmost_app)

  if [[ "$the_app" == 'Terminal' ]]; then
    # Discarding stdout to quash "tab N of window id XXX" output
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Terminal" to keystroke "t" using command down
      end tell
      tell application "Terminal" to do script "${command}" in front window
EOF
  elif [[ "$the_app" == 'iTerm' ]]; then
    osascript <<EOF
      tell application "iTerm"
        set current_terminal to current terminal
        tell current_terminal
          launch session "Default Session"
          set current_session to current session
          tell current_session
            write text "${command}"
          end tell
        end tell
      end tell
EOF
  elif [[ "$the_app" == 'iTerm2' ]]; then
    osascript <<EOF
      tell application "iTerm2"
        tell current window
          create tab with default profile
          tell current session to write text "${command}"
        end tell
      end tell
EOF
  elif [[ "$the_app" == 'Hyper' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Hyper" to keystroke "t" using command down
      end tell
      delay 1
      tell application "System Events"
        keystroke "${command}"
        key code 36  #(presses enter)
      end tell
EOF

  elif [[ "$the_app" == 'Tabby' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Tabby" to keystroke "t" using command down
      end tell
EOF
  elif [[ "$the_app" == 'ghostty' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Ghostty" to keystroke "t" using command down
      end tell
EOF
  else
    echo "$0: unsupported terminal app: $the_app" >&2
    return 1
  fi
}

function vsplit_tab() {
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_macos_get_frontmost_app)

  if [[ "$the_app" == 'iTerm' ]]; then
    osascript <<EOF
      -- tell application "iTerm" to activate
      tell application "System Events"
        tell process "iTerm"
          tell menu item "Split Vertically With Current Profile" of menu "Shell" of menu bar item "Shell" of menu bar 1
            click
          end tell
        end tell
        keystroke "${command} \n"
      end tell
EOF
  elif [[ "$the_app" == 'iTerm2' ]]; then
    osascript <<EOF
      tell application "iTerm2"
        tell current session of first window
          set newSession to (split vertically with same profile)
          tell newSession
            write text "${command}"
            select
          end tell
        end tell
      end tell
EOF
  elif [[ "$the_app" == 'Hyper' ]]; then
    osascript >/dev/null <<EOF
    tell application "System Events"
      tell process "Hyper"
        tell menu item "Split Vertically" of menu "Shell" of menu bar 1
          click
        end tell
      end tell
      delay 1
      keystroke "${command} \n"
    end tell
EOF
  elif [[ "$the_app" == 'Tabby' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Tabby" to keystroke "D" using command down
      end tell
EOF
  elif [[ "$the_app" == 'ghostty' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Ghostty" to keystroke "D" using command down
      end tell
EOF
  else
    echo "$0: unsupported terminal app: $the_app" >&2
    return 1
  fi
}

function split_tab() {
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_macos_get_frontmost_app)

  if [[ "$the_app" == 'iTerm' ]]; then
    osascript 2>/dev/null <<EOF
      tell application "iTerm" to activate

      tell application "System Events"
        tell process "iTerm"
          tell menu item "Split Horizontally With Current Profile" of menu "Shell" of menu bar item "Shell" of menu bar 1
            click
          end tell
        end tell
        keystroke "${command} \n"
      end tell
EOF
  elif [[ "$the_app" == 'iTerm2' ]]; then
    osascript <<EOF
      tell application "iTerm2"
        tell current session of first window
          set newSession to (split horizontally with same profile)
          tell newSession
            write text "${command}"
            select
          end tell
        end tell
      end tell
EOF
  elif [[ "$the_app" == 'Hyper' ]]; then
    osascript >/dev/null <<EOF
    tell application "System Events"
      tell process "Hyper"
        tell menu item "Split Horizontally" of menu "Shell" of menu bar 1
          click
        end tell
      end tell
      delay 1
      keystroke "${command} \n"
    end tell
EOF
  elif [[ "$the_app" == 'Tabby' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Tabby" to keystroke "d" using command down
      end tell
EOF
  elif [[ "$the_app" == 'ghostty' ]]; then
    osascript >/dev/null <<EOF
      tell application "System Events"
        tell process "Ghostty" to keystroke "d" using command down
      end tell
EOF
  else
    echo "$0: unsupported terminal app: $the_app" >&2
    return 1
  fi
}

function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (insertion location as alias)
    end tell
EOF
}

function pfs() {
  osascript 2>/dev/null <<EOF
    set output to ""
    tell application "Finder" to set the_selection to selection
    set item_count to count the_selection
    repeat with item_index from 1 to count the_selection
      if item_index is less than item_count then set the_delimiter to "\n"
      if item_index is item_count then set the_delimiter to ""
      set output to output & ((item item_index of the_selection as alias)'s POSIX path) & the_delimiter
    end repeat
EOF
}

function cdf() {
  cd "$(pfd)"
}

function pushdf() {
  pushd "$(pfd)"
}

function pxd() {
  dirname $(osascript 2>/dev/null <<EOF
    if application "Xcode" is running then
      tell application "Xcode"
        return path of active workspace document
      end tell
    end if
EOF
)
}

function cdx() {
  cd "$(pxd)"
}

function quick-look() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

function man-preview() {
  [[ $# -eq 0 ]] && >&2 echo "Usage: $0 command1 [command2 ...]" && return 1

  local page
  for page in "${(@f)"$(man -w $@)"}"; do
    command mandoc -Tpdf $page | open -f -a Preview
  done
}
compdef _man man-preview

function vncviewer() {
  open vnc://$@
}

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
  find "${@:-.}" -type f -name .DS_Store -delete
}

# Erases purgeable disk space with 0s on the selected disk
function freespace(){
  if [[ -z "$1" ]]; then
    echo "Usage: $0 <disk>"
    echo "Example: $0 /dev/disk1s1"
    echo
    echo "Possible disks:"
    df -h | awk 'NR == 1 || /^\/dev\/disk/'
    return 1
  fi

  echo "Cleaning purgeable files from disk: $1 ...."
  diskutil secureErase freespace 0 $1
}

_freespace() {
  local -a disks
  disks=("${(@f)"$(df | awk '/^\/dev\/disk/{ printf $1 ":"; for (i=9; i<=NF; i++) printf $i FS; print "" }')"}")
  _describe disks disks
}

compdef _freespace freespace

# Music / iTunes control function
source "${0:h:A}/music"

# Spotify control function
source "${0:h:A}/spotify"
