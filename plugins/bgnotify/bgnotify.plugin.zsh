#!/usr/bin/env zsh

## Setup

[[ -o interactive ]] || return # don't load on non-interactive shells
[[ -z "$SSH_CLIENT" && -z "$SSH_TTY" ]] || return # don't load on a SSH connection

zmodload zsh/datetime # faster than `date`


## Zsh Hooks

function bgnotify_begin {
  bgnotify_timestamp=$EPOCHSECONDS
  bgnotify_lastcmd="${1:-$2}"
}

function bgnotify_end {
  {
    local exit_status=$?
    local elapsed=$(( EPOCHSECONDS - bgnotify_timestamp ))

    # check time elapsed
    [[ $bgnotify_timestamp -gt 0 ]] || return
    [[ $elapsed -ge $bgnotify_threshold ]] || return

    # check if Terminal app is not active
    [[ $(bgnotify_appid) != "$bgnotify_termid" ]] || return

    printf '\a' # beep sound
    bgnotify_formatted "$exit_status" "$bgnotify_lastcmd" "$elapsed"
  } always {
    bgnotify_timestamp=0
  }
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec bgnotify_begin
add-zsh-hook precmd bgnotify_end


## Functions

# allow custom function override
(( ${+functions[bgnotify_formatted]} )) || \
function bgnotify_formatted {
  local exit_status=$1
  local cmd="$2"

  # humanly readable elapsed time
  local elapsed="$(( $3 % 60 ))s"
  (( $3 < 60 )) || elapsed="$((( $3 % 3600) / 60 ))m $elapsed"
  (( $3 < 3600 )) || elapsed="$(( $3 / 3600 ))h $elapsed"

  if [[ $1 -eq 0 ]]; then
    bgnotify "#win (took $elapsed)" "$2"
  else
    bgnotify "#fail (took $elapsed)" "$2"
  fi
}

# for macOS, output is "app ID, window ID" (com.googlecode.iterm2, 116)
function bgnotify_appid {
  if (( ${+commands[osascript]} )); then
    osascript -e 'tell application (path to frontmost application as text) to get the {id, id of front window}' 2>/dev/null
  elif (( ${+commands[xprop]} )); then
    xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | cut -d' ' -f5
  else
    echo $EPOCHSECONDS
  fi
}

function bgnotify {
  # $1: title, $2: message
  if (( ${+commands[terminal-notifier]} )); then # macOS
    local term_id="${bgnotify_termid%%,*}" # remove window id
    if [[ -z "$term_id" ]]; then
      case "$TERM_PROGRAM" in
      iTerm.app) term_id='com.googlecode.iterm2' ;;
      Apple_Terminal) term_id='com.apple.terminal' ;;
      esac
    fi

    if [[ -z "$term_id" ]]; then
      terminal-notifier -message "$2" -title "$1" &>/dev/null
    else
      terminal-notifier -message "$2" -title "$1" -activate "$term_id" -sender "$term_id" &>/dev/null
    fi
  elif (( ${+commands[growlnotify]} )); then # macOS growl
    growlnotify -m "$1" "$2"
  elif (( ${+commands[notify-send]} )); then # GNOME
    notify-send "$1" "$2"
  elif (( ${+commands[kdialog]} )); then # KDE
    kdialog --title "$1" --passivepopup  "$2" 5
  elif (( ${+commands[notifu]} )); then # cygwin
    notifu /m "$2" /p "$1"
  fi
}

## Defaults

# notify if command took longer than 5s by default
bgnotify_threshold=${bgnotify_threshold:-5}

# bgnotify_appid is slow in macOS and the terminal ID won't change, so cache it at startup
bgnotify_termid="$(bgnotify_appid)"
