# Open the current directory in a Finder window
alias ofd='open_command $PWD'

function _omz_osx_get_frontmost_app() {
  local the_app=$(
    osascript 2>/dev/null <<EOF
      tell application "System Events"
        name of first item of (every process whose frontmost is true)
      end tell
EOF
  )
  echo "$the_app"
}

function tab() {
  # Must not have trailing semicolon, for iTerm compatibility
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_osx_get_frontmost_app)

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

  else
    echo "tab: unsupported terminal app: $the_app"
    false

  fi
}

function vsplit_tab() {
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_osx_get_frontmost_app)

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

  else
    echo "$0: unsupported terminal app: $the_app" >&2
    false

  fi
}

function split_tab() {
  local command="cd \\\"$PWD\\\"; clear"
  (( $# > 0 )) && command="${command}; $*"

  local the_app=$(_omz_osx_get_frontmost_app)

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

  else
    echo "$0: unsupported terminal app: $the_app" >&2
    false

  fi
}

function pfd() {
  osascript 2>/dev/null <<EOF
    tell application "Finder"
      return POSIX path of (target of window 1 as alias)
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

function quick-look() {
  (( $# > 0 )) && qlmanage -p $* &>/dev/null &
}

function man-preview() {
  man -t "$@" | open -f -a Preview
}
compdef _man man-preview

function vncviewer() {
  open vnc://$@
}

# iTunes control function
function itunes music() {
	local APP_NAME=Music

	autoload is-at-least
	if is-at-least 10.15 $(sw_vers -productVersion); then
		if [[ $0 = itunes ]]; then
			echo >&2 The itunes function name is deprecated. Use \`music\' instead.
			return 1
		fi
	else
		APP_NAME=iTunes
	fi

	local opt=$1
	local playlist=$2
	shift
	case "$opt" in
		launch|play|pause|stop|rewind|resume|quit)
			;;
		mute)
			opt="set mute to true"
			;;
		unmute)
			opt="set mute to false"
			;;
		next|previous)
			opt="$opt track"
			;;
		vol)
			local new_volume volume=$(osascript -e "tell application \"$APP_NAME\" to get sound volume")
			if [[ $# -eq 0 ]]; then
				echo "Current volume is ${volume}."
				return 0
			fi
			case $1 in
				up) new_volume=$((volume + 10 < 100 ? volume + 10 : 100)) ;;
				down) new_volume=$((volume - 10 > 0 ? volume - 10 : 0)) ;;
				<0-100>) new_volume=$1 ;;
				*) echo "'$1' is not valid. Expected <0-100>, up or down."
				   return 1 ;;
			esac
			opt="set sound volume to ${new_volume}"
			;;
		playlist)
			# Inspired by: https://gist.github.com/nakajijapan/ac8b45371064ae98ea7f
			if [[ ! -z "$playlist" ]]; then
				osascript -e "tell application \"$APP_NAME\"" -e "set new_playlist to \"$playlist\" as string" -e "play playlist new_playlist" -e "end tell" 2>/dev/null;
				if [[ $? -eq 0 ]]; then
					opt="play"
				else
					opt="stop"
				fi
			else
				opt="set allPlaylists to (get name of every playlist)"
			fi
			;;
		playing|status)
			local state=`osascript -e "tell application \"$APP_NAME\" to player state as string"`
			if [[ "$state" = "playing" ]]; then
				currenttrack=`osascript -e "tell application \"$APP_NAME\" to name of current track as string"`
				currentartist=`osascript -e "tell application \"$APP_NAME\" to artist of current track as string"`
				echo -E "Listening to $fg[yellow]$currenttrack$reset_color by $fg[yellow]$currentartist$reset_color";
			else
				echo "$APP_NAME is" $state;
			fi
			return 0
			;;
		shuf|shuff|shuffle)
			# The shuffle property of current playlist can't be changed in iTunes 12,
			# so this workaround uses AppleScript to simulate user input instead.
			# Defaults to toggling when no options are given.
			# The toggle option depends on the shuffle button being visible in the Now playing area.
			# On and off use the menu bar items.
			local state=$1

			if [[ -n "$state" && ! "$state" =~ "^(on|off|toggle)$" ]]
			then
				print "Usage: $0 shuffle [on|off|toggle]. Invalid option."
				return 1
			fi

			case "$state" in
				on|off)
					# Inspired by: https://stackoverflow.com/a/14675583
					osascript 1>/dev/null 2>&1 <<-EOF
					tell application "System Events" to perform action "AXPress" of (menu item "${state}" of menu "Shuffle" of menu item "Shuffle" of menu "Controls" of menu bar item "Controls" of menu bar 1 of application process "iTunes" )
EOF
					return 0
					;;
				toggle|*)
					osascript 1>/dev/null 2>&1 <<-EOF
					tell application "System Events" to perform action "AXPress" of (button 2 of process "iTunes"'s window "iTunes"'s scroll area 1)
EOF
					return 0
					;;
			esac
			;;
		""|-h|--help)
			echo "Usage: $0 <option>"
			echo "option:"
			echo "\tlaunch|play|pause|stop|rewind|resume|quit"
			echo "\tmute|unmute\tcontrol volume set"
			echo "\tnext|previous\tplay next or previous track"
			echo "\tshuf|shuffle [on|off|toggle]\tSet shuffled playback. Default: toggle. Note: toggle doesn't support the MiniPlayer."
			echo "\tvol [0-100|up|down]\tGet or set the volume. 0 to 100 sets the volume. 'up' / 'down' increases / decreases by 10 points. No argument displays current volume."
			echo "\tplaying|status\tShow what song is currently playing in Music."
			echo "\tplaylist [playlist name]\t Play specific playlist"
			echo "\thelp\tshow this message and exit"
			return 0
			;;
		*)
			print "Unknown option: $opt"
			return 1
			;;
	esac
	osascript -e "tell application \"$APP_NAME\" to $opt"
}

# Spotify control function
source ${ZSH}/plugins/osx/spotify

# Show/hide hidden files in the Finder
alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Remove .DS_Store files recursively in a directory, default .
function rmdsstore() {
	find "${@:-.}" -type f -name .DS_Store -delete
}
