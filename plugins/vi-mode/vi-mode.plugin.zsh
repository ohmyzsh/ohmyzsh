# Updates editor information when the keymap changes.
function zle-keymap-select() {
  zle reset-prompt
  zle -R
}

# Ensure that the prompt is redrawn when the terminal size changes.
TRAPWINCH() {
  zle && { zle reset-prompt; zle -R }
}

zle -N zle-keymap-select
zle -N edit-command-line


bindkey -v

# allow v to edit the command line (standard behaviour)
autoload -Uz edit-command-line
bindkey -M vicmd 'v' edit-command-line

# allow ctrl-p, ctrl-n for navigate history (standard behaviour)
bindkey '^P' up-history
bindkey '^N' down-history

# allow ctrl-h, ctrl-w, ctrl-? for char and word deletion (standard behaviour)
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word

bindkey -M vicmd 'cc' vi-change-whole-line
bindkey -M vicmd 'dd' kill-whole-line

delete-in() {
  local char lchar rchar lsearch rsearch count
  read -k char
  if [[ "$char" == 'w' ]];then
    zle vi-backward-word
    lsearch="$CURSOR"
    zle vi-forward-word
    rsearch="$CURSOR"
    RBUFFER="$BUFFER[$rsearch+1,${#BUFFER}]"
    LBUFFER="$LBUFFER[1,$lsearch]"
    return
  elif [[ "$char" == '(' || "$char" == ')' ]];then
    lchar='('
    rchar=')'
  elif [[ "$char" == '[' || "$char" == ']' ]];then
    lchar='['
    rchar=']'
  elif [[ "$char" == '{' || "$char" == '}' ]];then
    lchar='{'
    rchar='}'
  else
    lsearch="${#LBUFFER}"
    while (( lsearch > 0 )) && [[ "$LBUFFER[$lsearch]" != "$char" ]]; do
      (( lsearch-- ))
    done
    rsearch=0
    while [[ $rsearch -lt (( ${#RBUFFER} + 1 )) ]] && [[ "$RBUFFER[$rsearch]" != "$char" ]]; do
      (( rsearch++ ))
    done
    RBUFFER="$RBUFFER[$rsearch,${#RBUFFER}]"
    LBUFFER="$LBUFFER[1,$lsearch]"
    return
  fi
  count=1
  lsearch="${#LBUFFER}"
  while (( lsearch > 0 )) && (( count > 0 )); do
    (( lsearch-- ))
    if [[ "$LBUFFER[$lsearch]" == "$rchar" ]];then
      (( count++ ))
    fi
    if [[ "$LBUFFER[$lsearch]" == "$lchar" ]];then
      (( count-- ))
    fi
  done
  count=1
  rsearch=0
  while (( "$rsearch" < ${#RBUFFER} + 1 )) && [[ "$count" > 0 ]]; do
    (( rsearch++ ))
    if [[ $RBUFFER[$rsearch] == "$lchar" ]];then
      (( count++ ))
    fi
    if [[ $RBUFFER[$rsearch] == "$rchar" ]];then
      (( count-- ))
    fi
  done
  RBUFFER="$RBUFFER[$rsearch,${#RBUFFER}]"
  LBUFFER="$LBUFFER[1,$lsearch]"
}
zle -N delete-in
bindkey -M vicmd 'di' delete-in

delete-around() {
  zle delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
}
zle -N delete-around
bindkey -M vicmd 'da' delete-around

change-in() {
  zle delete-in
  zle vi-insert
}
zle -N change-in
bindkey -M vicmd 'ci' change-in

change-around() {
  zle delete-in
  zle vi-backward-char
  zle vi-delete-char
  zle vi-delete-char
  zle vi-insert
}
zle -N change-around
bindkey -M vicmd 'ca' change-around

# if mode indicator wasn't setup by theme, define default
if [[ "$MODE_INDICATOR" == "" ]]; then
  MODE_INDICATOR="%{$fg_bold[red]%}<%{$fg[red]%}<<%{$reset_color%}"
fi

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/$MODE_INDICATOR}/(main|viins)/}"
}

# define right prompt, if it wasn't defined by a theme
if [[ "$RPS1" == "" && "$RPROMPT" == "" ]]; then
  RPS1='$(vi_mode_prompt_info)'
fi
