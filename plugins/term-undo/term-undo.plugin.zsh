# ~/.zsh_undo   →   add to ~/.zshrc:   source ~/.zsh_undo
autoload -Uz add-zsh-hook

typeset -gi UNDO_HEADROOM=${UNDO_HEADROOM:-15}   # rows kept free below the prompt
typeset -gi _u_n=0 _u_ran=0 _u_isundo=0 _u_R0=0 _u_cmdrows=1 _u_PH=2 _u_plen=4
typeset -gi _u_blank_cur=0 _u_blank_run=0 _u_PH_run=2 _u_cmdrows_run=1
typeset -gi _u_last_ok=0 _u_last_rows=0
typeset -g  _u_cmd='' _u_last_cmd=''

# --- cursor row, without echo garbage ------------------------------------
_u_row() {
  emulate -L zsh
  [[ -t 0 && $TERM != dumb ]] || return 1
  local fd old c buf=
  { exec {fd}</dev/tty } 2>/dev/null || return 1
  old=$(stty -g <&$fd) || { exec {fd}<&-; return 1 }
  stty -echo -icanon <&$fd
  print -rn -- $'\e[6n' >/dev/tty
  while read -rsk1 -t 0.3 -u $fd c; do
    [[ $c == R ]] && break
    buf+=$c
  done
  stty $old <&$fd
  exec {fd}<&-
  buf=${buf##*$'\e['}
  [[ $buf == <->';'<-> ]] || return 1
  REPLY=${buf%%;*}
}

# --- prompt height and width of its last line ------------------------------
_u_prompt_geom() {
  emulate -L zsh -o extendedglob
  local p=$PS1 nl
  [[ -o promptsubst ]] && p=${(e)p}
  p=${(%)p}
  p=${p//$'\e'\[[0-9;]#m/}
  nl=${p//[^$'\n']/}
  _u_PH=$(( ${#nl} + 1 ))
  _u_plen=${#${p##*$'\n'}}
}

# --- rows taken by the typed command (wrapping included) ---------------------
_u_cmd_rows() {
  emulate -L zsh
  local line w n=0 first=1
  for line in "${(@f)1}"; do
    w=${#line}
    (( first )) && { (( w += _u_plen )); first=0 }
    (( n += w > 0 ? (w - 1) / COLUMNS + 1 : 1 ))
  done
  REPLY=$n
}

_u_preexec() {
  emulate -L zsh
  _u_ran=1
  _u_cmd=$1
  _u_blank_run=$_u_blank_cur
  _u_prompt_geom
  _u_PH_run=$_u_PH
  _u_cmd_rows "$1"
  _u_cmdrows=$REPLY
  _u_cmdrows_run=$REPLY
  _u_R0=0
  _u_row && _u_R0=$REPLY
  [[ ${1//[[:space:]]/} == (undo|back) ]] && _u_isundo=1
}

_u_precmd() {
  emulate -L zsh
  (( _u_n++ ))
  local R1=0
  _u_row && R1=$REPLY

  if (( _u_ran )); then
    if (( ! _u_isundo )); then
      _u_last_cmd=$_u_cmd
      # R1 == LINES means the screen scrolled and the count is unreliable
      if (( _u_R0 > 0 && R1 >= _u_R0 && R1 < LINES )); then
        _u_last_ok=1
        _u_last_rows=$(( _u_blank_run + _u_PH_run - 1 + _u_cmdrows_run + R1 - _u_R0 ))
      else
        _u_last_ok=0
      fi
    fi
  else
    _u_last_cmd=''        # empty Enter / Ctrl-C: geometry unknown
  fi
  _u_ran=0 _u_isundo=0

  # Kali prints a blank line before every prompt except the first
  if [[ $NEWLINE_BEFORE_PROMPT == yes ]] && (( _u_n > 1 )); then
    _u_blank_cur=1
  else
    _u_blank_cur=0
  fi

  # keep free rows below the prompt so small outputs never scroll the screen
  if (( R1 > 0 && LINES - R1 < UNDO_HEADROOM )); then
    repeat $UNDO_HEADROOM print -rn -- $'\n'
    print -rn -- $'\e['$UNDO_HEADROOM$'A'
  fi
}

undo() {
  emulate -L zsh
  [[ -n $_u_last_cmd ]] || { print -u2 "undo: nothing to undo"; return 1 }
  local cmd=$_u_last_cmd up
  _u_last_cmd=''
  _u_prompt_geom
  up=$(( _u_last_rows + _u_PH - 1 + _u_cmdrows ))
  if (( _u_last_ok && _u_R0 > 0 && up < _u_R0 )); then
    print -rn -- $'\e['$up$'A\r\e[J'     # erase exactly the failed block
  else
    print -rn -- $'\e[H\e[2J'            # fallback: block scrolled / too big
  fi
  print -z -- $cmd                       # next prompt starts with the command
}
alias back=undo

# Alt+u: same path as typing "undo", no ZLE cursor guessing
_u_widget() {
  [[ -n $_u_last_cmd ]] || { zle -M "undo: nothing to restore"; return }
  BUFFER=undo
  zle accept-line
}
zle -N _u_widget
bindkey '^[u' _u_widget

# keep undo/back out of history
_u_nohist() { [[ ${1%%$'\n'} == (undo|back) ]] && return 1; return 0 }
add-zsh-hook zshaddhistory _u_nohist
add-zsh-hook preexec _u_preexec
add-zsh-hook precmd  _u_precmd
