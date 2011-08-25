


function tab() {
osascript >/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end
    tell application "Terminal"
      activate
      do script with command "cd \"$PWD\"; $*" in window 1
    end tell

EOF
  }



function ntab() {

if [[ $# == 0 ]]; then
      ThisDirectory=$PWD
elif [[ $# == 1 && -d "$1" ]]; then
      ThisDirectory="$@"
else
      print "usage: ntab [directory]"
      return 1
fi


if [[  $TERM_PROGRAM != iTerm.app ]]; then
   
  osascript -e "  tell application \"System Events\"
                      tell process \"Terminal\" to keystroke \"t\" using command down
                      end
                      tell application \"Terminal\"
                          activate
                          do script with command \"cd \\\"$PWD\\\";cd \\\"$ThisDirectory\\\"\" in window 1
                      end tell"
          return 1
else     
    osascript -e "  tell application \"iTerm\"
            	        make new terminal
                	    tell the front terminal 
                		    activate current session
                    		launch session \"Default Session\"
                    		tell the current session
                    			write text \"cd \\\"$PWD\\\"; cd \\\"$ThisDirectory\\\"\"
                    		end tell
                    	end tell
                    end tell
                tell application \"iTerm\"
                	activate
                end tell  "
    
fi

    }
