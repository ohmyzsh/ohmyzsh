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
    [[ $bgnotify_timestamp -gt 0 ]] || return 0
    [[ $elapsed -ge $bgnotify_threshold ]] || return 0

    # check if Terminal app is not active
    [[ $(bgnotify_appid) != "$bgnotify_termid" ]] || return 0

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

  [[ $bgnotify_bell = true ]] && printf '\a' # beep sound
  if [[ $exit_status -eq 0 ]]; then
    bgnotify "#win (took $elapsed)" "$cmd"
  else
    bgnotify "#fail (took $elapsed)" "$cmd"
  fi
}

function bgnotify_appid {
  if (( ${+commands[osascript]} )); then
    osascript -e "tell application id \"$(bgnotify_programid)\"  to get the {id, frontmost, id of front window, visible of front window}" 2>/dev/null
  elif [[ -n $WAYLAND_DISPLAY ]] && (( ${+commands[swaymsg]} )); then # wayland+sway
    local app_id=$(bgnotify_find_sway_appid)
    [[ -n "$app_id" ]] && echo "$app_id" || echo $EPOCHSECONDS
  elif [[ -z $WAYLAND_DISPLAY ]] && [[ -n $DISPLAY ]] && (( ${+commands[xprop]} )); then
    xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | cut -d' ' -f5
  else
    echo $EPOCHSECONDS
  fi
}


function bgnotify_find_sway_appid {
  # output is "app_id,container_id", for example "Alacritty,1694"
  # see example swaymsg output: https://github.com/ohmyzsh/ohmyzsh/files/13463939/output.json
  if (( ${+commands[jq]} )); then
    swaymsg -t get_tree | jq '.. | select(.type?) | select(.focused==true) | {app_id, id} | join(",")'
  else
    swaymsg -t get_tree | awk '
      BEGIN { Id = ""; Appid = ""; FocusNesting = -1; Nesting = 0 }
      {
        # Enter a block
        if ($0 ~ /.*{$/) Nesting++

        # Exit a block. If Nesting is now less than FocusNesting, we have the data we are looking for
        if ($0 ~ /^[[:blank:]]*}.*/) { Nesting--; if (FocusNesting > 0 && Nesting < FocusNesting) exit 0 }

        # Save the Id, it is potentially what we are looking for
        if ($0 ~ /^[[:blank:]]*"id": [0-9]*,?$/)    { sub(/^[[:blank:]]*"id": /, "");      sub(/,$/,  ""); Id = $0 }

        # Save the Appid, it is potentially what we are looking for
        if ($0 ~ /^[[:blank:]]*"app_id": ".*",?$/)  { sub(/^[[:blank:]]*"app_id": "/, ""); sub(/",$/, ""); Appid = $0 }

        # Window is focused, this nesting block contains the Id and Appid we want!
        if ($0 ~ /^[[:blank:]]*"focused": true,?$/) { FocusNesting = Nesting }
      }
      END {
        if (Appid != "" && Id != "" && FocusNesting != -1) print Appid "," Id
        else print ""
      }'
  fi
}

function bgnotify_programid {
  case "$TERM_PROGRAM" in
    iTerm.app) echo 'com.googlecode.iterm2' ;;
    Apple_Terminal) echo 'com.apple.terminal' ;;
  esac
}

function bgnotify {
  local title="$1"
  local message="$2"
  local icon="$3"
  if (( ${+commands[terminal-notifier]} )); then # macOS
    local term_id=$(bgnotify_programid)
    terminal-notifier -message "$message" -title "$title" ${=icon:+-appIcon "$icon"} ${=term_id:+-activate "$term_id"} &>/dev/null
  elif (( ${+commands[growlnotify]} )); then # macOS growl
    growlnotify -m "$title" "$message"
  elif (( ${+commands[notify-send]} )); then
    notify-send "$title" "$message" ${=icon:+--icon "$icon"}
  elif (( ${+commands[kdialog]} )); then # KDE
    kdialog --title "$title" --passivepopup  "$message" 5
  elif (( ${+commands[notifu]} )); then # cygwin
    notifu /m "$message" /p "$title" ${=icon:+/i "$icon"}
  fi
}

## Defaults

# enable terminal bell on notify by default
bgnotify_bell=${bgnotify_bell:-true}

# notify if command took longer than 5s by default
bgnotify_threshold=${bgnotify_threshold:-5}

# bgnotify_appid is slow in macOS and the terminal ID won't change, so cache it at startup
bgnotify_termid="$(bgnotify_appid)"
