# Open folder in ForkLift.app or ForkLift2.app from console
# Author: Adam Strzelecki nanoant.com, modified by Bodo Tasche bitboxer.de
#         Updated to support ForkLift 2 and ForkLift 3 by Johan Kaving
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

  try
    tell application "Finder"
        set forkLift3 to name of application file id "com.binarynights.ForkLift-3"
    end tell
  on error err_msg number err_num
    set forkLift3 to null
  end try
  try
    tell application "Finder"
        set forkLift2 to name of application file id "com.binarynights.ForkLift2"
    end tell
  on error err_msg number err_num
    set forkLift2 to null
  end try
  try
    tell application "Finder"
        set forkLift to name of application file id "com.binarynights.ForkLift"
    end tell
  on error err_msg number err_num
    set forkLift to null
  end try

  if forkLift3 is not null and application forkLift3 is running then
    tell application forkLift3
        activate
        set forkLiftVersion to version
    end tell
  else if forkLift2 is not null and application forkLift2 is running then
    tell application forkLift2
        activate
        set forkLiftVersion to version
    end tell
  else if forkLift is not null and application forkLift is running then
    tell application forkLift
        activate
        set forkLiftVersion to version
    end tell
  else
    if forkLift3 is not null then
        set appName to forkLift3
    else if forkLift2 is not null then
        set appName to forkLift2
    else if forkLift is not null then
        set appName to forkLift
    end if
    
    tell application appName
        activate
        set forkLiftVersion to version
    end tell
    repeat until application appName is running
        delay 1
    end repeat
    tell application appName
        activate
    end tell
  end if

  tell application "System Events"
    tell application process "ForkLift"
        try
            set topWindow to window 1
        on error
            keystroke "n" using command down
            set topWindow to window 1
        end try
        keystroke "g" using {command down, shift down}
        if forkLiftVersion starts with "3" then
            tell pop over of list of group of splitter group of splitter group of topWindow
                set value of text field 1 to "$PWD"
            end tell
        else
            tell sheet 1 of topWindow
                set value of text field 1 to "$PWD"
            end tell
        end if
        keystroke return
    end tell
  end tell
END
}
