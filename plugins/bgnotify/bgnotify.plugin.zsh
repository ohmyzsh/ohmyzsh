#!/usr/bin/env zsh

## setup ##

[[ -o interactive ]] || return #interactive only!
zmodload zsh/datetime || { print "can't load zsh/datetime"; return } # faster than date()
autoload -Uz add-zsh-hook || { print "can't add zsh hook!"; return }

(( ${+bgnotify_threshold} )) || bgnotify_threshold=5 #default 10 seconds


## definitions ##

<<<<<<< HEAD
if ! (type bgnotify_formatted | grep -q 'function'); then
  function bgnotify_formatted {
    ## exit_status, command, elapsed_time
    [ $1 -eq 0 ] && title="#win (took $3 s)" || title="#fail (took $3 s)"
    bgnotify "$title" "$2"
  }
fi

currentWindowId () {
  if hash osascript 2>/dev/null; then #osx
    osascript -e 'tell application (path to frontmost application as text) to id of front window' 2&> /dev/null || echo "0"
  elif hash notify-send 2>/dev/null; then #ubuntu!
    xprop -root | awk '/NET_ACTIVE_WINDOW/ { print $5; exit }'
=======
if ! (type bgnotify_formatted | grep -q 'function'); then ## allow custom function override
  function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && bgnotify "#win (took $elapsed)" "$2" || bgnotify "#fail (took $elapsed)" "$2"
  }
fi

currentAppId () {
  if (( $+commands[osascript] )); then
    osascript -e 'tell application (path to frontmost application as text) to id' 2>/dev/null
  fi
}

currentWindowId () {
  if hash osascript 2>/dev/null; then #osx
    osascript -e 'tell application (path to frontmost application as text) to id of front window' 2&> /dev/null || echo "0"
  elif (hash notify-send 2>/dev/null || hash kdialog 2>/dev/null); then #ubuntu!
    xprop -root 2> /dev/null | awk '/NET_ACTIVE_WINDOW/{print $5;exit} END{exit !$5}' || echo "0"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  else
    echo $EPOCHSECONDS #fallback for windows
  fi
}

<<<<<<< HEAD
bgnotify () {
  if hash terminal-notifier 2>/dev/null; then #osx
    terminal-notifier -message "$2" -title "$1"
  elif hash growlnotify 2>/dev/null; then #osx growl
    growlnotify -m "$1" "$2"
  elif hash notify-send 2>/dev/null; then #ubuntu!
    notify-send "$1" "$2"
=======
bgnotify () { ## args: (title, subtitle)
  if hash terminal-notifier 2>/dev/null; then #osx
    local term_id="$bgnotify_appid"
    if [[ -z "$term_id" ]]; then
      case "$TERM_PROGRAM" in
      iTerm.app) term_id='com.googlecode.iterm2' ;;
      Apple_Terminal) term_id='com.apple.terminal' ;;
      esac
    fi

    ## now call terminal-notifier, (hopefully with $term_id!)
    if [[ -z "$term_id" ]]; then
      terminal-notifier -message "$2" -title "$1" >/dev/null
    else
      terminal-notifier -message "$2" -title "$1" -activate "$term_id" -sender "$term_id" >/dev/null
    fi
  elif hash growlnotify 2>/dev/null; then #osx growl
    growlnotify -m "$1" "$2"
  elif hash notify-send 2>/dev/null; then #ubuntu gnome!
    notify-send "$1" "$2"
  elif hash kdialog 2>/dev/null; then #ubuntu kde!
    kdialog --title "$1" --passivepopup  "$2" 5
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  elif hash notifu 2>/dev/null; then #cygwyn support!
    notifu /m "$2" /p "$1"
  fi
}


## Zsh hooks ##

bgnotify_begin() {
  bgnotify_timestamp=$EPOCHSECONDS
<<<<<<< HEAD
  bgnotify_lastcmd=$1
=======
  bgnotify_lastcmd="${1:-$2}"
  bgnotify_appid="$(currentAppId)"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  bgnotify_windowid=$(currentWindowId)
}

bgnotify_end() {
  didexit=$?
  elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))
  past_threshold=$(( elapsed >= bgnotify_threshold ))
  if (( bgnotify_timestamp > 0 )) && (( past_threshold )); then
<<<<<<< HEAD
    if [ $(currentWindowId) != "$bgnotify_windowid" ]; then
=======
    if [[ $(currentAppId) != "$bgnotify_appid" || $(currentWindowId) != "$bgnotify_windowid" ]]; then
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
      print -n "\a"
      bgnotify_formatted "$didexit" "$bgnotify_lastcmd" "$elapsed"
    fi
  fi
  bgnotify_timestamp=0 #reset it to 0!
}

<<<<<<< HEAD
add-zsh-hook preexec bgnotify_begin
add-zsh-hook precmd bgnotify_end
=======
## only enable if a local (non-ssh) connection
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  add-zsh-hook preexec bgnotify_begin
  add-zsh-hook precmd bgnotify_end
fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
