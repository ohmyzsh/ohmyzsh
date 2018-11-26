#!/usr/bin/env zsh

## setup ##

[[ -o interactive ]] || return #interactive only!
zmodload zsh/datetime || { print "can't load zsh/datetime"; return } # faster than date()
autoload -Uz add-zsh-hook || { print "can't add zsh hook!"; return }

(( ${+bgnotify_threshold} )) || bgnotify_threshold=5 #default 10 seconds


## definitions ##

if ! (type bgnotify_formatted | grep -q 'function'); then ## allow custom function override
  function bgnotify_formatted { ## args: (exit_status, command, elapsed_seconds)
    elapsed="$(( $3 % 60 ))s"
    (( $3 >= 60 )) && elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
    (( $3 >= 3600 )) && elapsed="$(( $3 / 3600 ))h $elapsed"
    [ $1 -eq 0 ] && bgnotify "#win (took $elapsed)" "$2" || bgnotify "#fail (took $elapsed)" "$2"
  }
fi

currentWindowId () {
  if hash osascript 2>/dev/null; then #osx
    osascript -e 'tell application (path to frontmost application as text) to id of front window' 2&> /dev/null || echo "0"
  elif (hash notify-send 2>/dev/null || hash kdialog 2>/dev/null); then #ubuntu!
    xprop -root 2> /dev/null | awk '/NET_ACTIVE_WINDOW/{print $5;exit} END{exit !$5}' || echo "0"
  else
    echo $EPOCHSECONDS #fallback for windows
  fi
}

bgnotify () { ## args: (title, subtitle)
  if hash terminal-notifier 2>/dev/null; then #osx
    [[ "$TERM_PROGRAM" == 'iTerm.app' ]] && term_id='com.googlecode.iterm2';
    [[ "$TERM_PROGRAM" == 'Apple_Terminal' ]] && term_id='com.apple.terminal';
    ## now call terminal-notifier, (hopefully with $term_id!)
    [ -z "$term_id" ] && terminal-notifier -message "$2" -title "$1" >/dev/null ||
    terminal-notifier -message "$2" -title "$1" -activate "$term_id" -sender "$term_id" >/dev/null
  elif hash growlnotify 2>/dev/null; then #osx growl
    growlnotify -m "$1" "$2"
  elif hash notify-send 2>/dev/null; then #ubuntu gnome!
    notify-send "$1" "$2"
  elif hash kdialog 2>/dev/null; then #ubuntu kde!
    kdialog --title "$1" --passivepopup  "$2" 5
  elif hash notifu 2>/dev/null; then #cygwyn support!
    notifu /m "$2" /p "$1"
  fi
}


## Zsh hooks ##

bgnotify_begin() {
  bgnotify_timestamp=$EPOCHSECONDS
  bgnotify_lastcmd="$1"
  bgnotify_windowid=$(currentWindowId)
}

bgnotify_end() {
  didexit=$?
  elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))
  past_threshold=$(( elapsed >= bgnotify_threshold ))
  if (( bgnotify_timestamp > 0 )) && (( past_threshold )); then
    if [ $(currentWindowId) != "$bgnotify_windowid" ]; then
      print -n "\a"
      bgnotify_formatted "$didexit" "$bgnotify_lastcmd" "$elapsed"
    fi
  fi
  bgnotify_timestamp=0 #reset it to 0!
}

## only enable if a local (non-ssh) connection
if [ -z "$SSH_CLIENT" ] && [ -z "$SSH_TTY" ]; then
  add-zsh-hook preexec bgnotify_begin
  add-zsh-hook precmd bgnotify_end
fi
