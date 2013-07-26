# Open folder in ForkLift.app from console
# Author: Adam Strzelecki nanoant.com, modified by Bodo Tasche bitboxer.de
#
# Usage:
#   fl [<folder>]
#
# Opens specified directory or current working directory in ForkLift.app
#
# Notes:
# It assumes Shift+Cmd+G launches go to folder panel and Cmd+N opens new
# app window.
#
# https://gist.github.com/3313481
function fl {
  if [ ! -z "$1" ]; then
    DIR=$1
    if [ ! -d "$DIR" ]; then
      DIR=$(dirname $DIR)
    fi
    if [ "$DIR" != "." ]; then
      PWD=`cd "$DIR";pwd`
    fi
  fi
  osascript 2>&1 1>/dev/null <<END
    tell application "ForkLift"
      activate
    end tell
    tell application "System Events"
      tell application process "ForkLift"
        try
          set topWindow to window 1
        on error
          keystroke "n" using command down
          set topWindow to window 1
        end try
        keystroke "g" using {command down, shift down}
        tell sheet 1 of topWindow
          set value of text field 1 to "$PWD"
        	keystroke return
        end tell
      end tell
    end tell
END
}
