##
#   Navigate directory history using ALT-LEFT and ALT-RIGHT. ALT-LEFT moves back to directories
#   that the user has changed to in the past, and ALT-RIGHT undoes ALT-LEFT.
#
#   Navigate directory hierarchy using ALT-UP and ALT-DOWN.
#   ALT-UP moves to higher hierarchy (cd ..)
#   ALT-DOWN moves into the first directory found in alphabetical order
#

dirhistory_past=($PWD)
dirhistory_future=()
export dirhistory_past
export dirhistory_future
export DIRHISTORY_SIZE=30

alias cde='dirhistory_cd'

# Pop the last element of dirhistory_past.
# Pass the name of the variable to return the result in.
# Returns the element if the array was not empty,
# otherwise returns empty string.
function pop_past() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_past -gt 0 ]]; then
    typeset -g $1="${dirhistory_past[$#dirhistory_past]}"
    dirhistory_past[$#dirhistory_past]=()
  fi
}

function pop_future() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_future -gt 0 ]]; then
    typeset -g $1="${dirhistory_future[$#dirhistory_future]}"
    dirhistory_future[$#dirhistory_future]=()
  fi
}

# Push a new element onto the end of dirhistory_past. If the size of the array
# is >= DIRHISTORY_SIZE, the array is shifted
function push_past() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_past -ge $DIRHISTORY_SIZE ]]; then
    shift dirhistory_past
  fi
  if [[ $#dirhistory_past -eq 0 || $dirhistory_past[$#dirhistory_past] != "$1" ]]; then
    dirhistory_past+=($1)
  fi
}

function push_future() {
  setopt localoptions no_ksh_arrays
  if [[ $#dirhistory_future -ge $DIRHISTORY_SIZE ]]; then
    shift dirhistory_future
  fi
  if [[ $#dirhistory_future -eq 0 || $dirhistory_futuret[$#dirhistory_future] != "$1" ]]; then
    dirhistory_future+=($1)
  fi
}

# Called by zsh when directory changes
autoload -U add-zsh-hook
add-zsh-hook chpwd chpwd_dirhistory
function chpwd_dirhistory() {
  push_past $PWD
  # If DIRHISTORY_CD is not set...
  if [[ -z "${DIRHISTORY_CD+x}" ]]; then
    # ... clear future.
    dirhistory_future=()
  fi
}

function dirhistory_cd(){
  DIRHISTORY_CD="1"
  cd $1
  unset DIRHISTORY_CD
}

# Move backward in directory history
function dirhistory_back() {
  local cw=""
  local d=""
  # Last element in dirhistory_past is the cwd.

  pop_past cw
  if [[ "" == "$cw" ]]; then
    # Someone overwrote our variable. Recover it.
    dirhistory_past=($PWD)
    return
  fi

  pop_past d
  if [[ "" != "$d" ]]; then
    dirhistory_cd $d
    push_future $cw
  else
    push_past $cw
  fi
}


# Move forward in directory history
function dirhistory_forward() {
  local d=""

  pop_future d
  if [[ "" != "$d" ]]; then
    dirhistory_cd $d
    push_past $d
  fi
}


# Bind keys to history navigation
function dirhistory_zle_dirhistory_back() {
  # Erase current line in buffer
  zle .kill-buffer
  dirhistory_back
  zle .accept-line
}

function dirhistory_zle_dirhistory_future() {
  # Erase current line in buffer
  zle .kill-buffer
  dirhistory_forward
  zle .accept-line
}

zle -N dirhistory_zle_dirhistory_back
zle -N dirhistory_zle_dirhistory_future

for keymap in emacs vicmd viins; do
  # dirhistory_back
  bindkey -M $keymap "\e[3D" dirhistory_zle_dirhistory_back    # xterm in normal mode
  bindkey -M $keymap "\e[1;3D" dirhistory_zle_dirhistory_back  # xterm in normal mode
  bindkey -M $keymap "\e\e[D" dirhistory_zle_dirhistory_back   # Putty
  bindkey -M $keymap "\eO3D" dirhistory_zle_dirhistory_back    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[b" dirhistory_zle_dirhistory_back ;; # Terminal.app
  ghostty) bindkey -M $keymap "^[b" dirhistory_zle_dirhistory_back ;;        # ghostty
  iTerm.app)
    bindkey -M $keymap "^[^[[D" dirhistory_zle_dirhistory_back
    bindkey -M $keymap "^[b" dirhistory_zle_dirhistory_back
    ;;
  esac

  if (( ${+terminfo[kcub1]} )); then
    bindkey -M $keymap "^[${terminfo[kcub1]}" dirhistory_zle_dirhistory_back  # urxvt
  fi

  # dirhistory_future
  bindkey -M $keymap "\e[3C" dirhistory_zle_dirhistory_future    # xterm in normal mode
  bindkey -M $keymap "\e[1;3C" dirhistory_zle_dirhistory_future  # xterm in normal mode
  bindkey -M $keymap "\e\e[C" dirhistory_zle_dirhistory_future   # Putty
  bindkey -M $keymap "\eO3C" dirhistory_zle_dirhistory_future    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[f" dirhistory_zle_dirhistory_future ;; # Terminal.app
  ghostty) bindkey -M $keymap "^[f" dirhistory_zle_dirhistory_future ;;        # ghostty
  iTerm.app)
    bindkey -M $keymap "^[^[[C" dirhistory_zle_dirhistory_future
    bindkey -M $keymap "^[f" dirhistory_zle_dirhistory_future
    ;;
  esac

  if (( ${+terminfo[kcuf1]} )); then
    bindkey -M $keymap "^[${terminfo[kcuf1]}" dirhistory_zle_dirhistory_future # urxvt
  fi
done

#
# HIERARCHY Implemented in this section, in case someone wants to split it to another plugin if it clashes bindings
#

# Move up in hierarchy
function dirhistory_up() {
  cd .. || return 1
}

# Move down in hierarchy
function dirhistory_down() {
  cd "$(find . -mindepth 1 -maxdepth 1 -type d | sort -n | head -n 1)" || return 1
}


# Bind keys to hierarchy navigation
function dirhistory_zle_dirhistory_up() {
  zle .kill-buffer   # Erase current line in buffer
  dirhistory_up
  zle .accept-line
}

function dirhistory_zle_dirhistory_down() {
  zle .kill-buffer   # Erase current line in buffer
  dirhistory_down
  zle .accept-line
}

zle -N dirhistory_zle_dirhistory_up
zle -N dirhistory_zle_dirhistory_down

for keymap in emacs vicmd viins; do
  # dirhistory_up
  bindkey -M $keymap "\e[3A" dirhistory_zle_dirhistory_up    # xterm in normal mode
  bindkey -M $keymap "\e[1;3A" dirhistory_zle_dirhistory_up  # xterm in normal mode
  bindkey -M $keymap "\e\e[A" dirhistory_zle_dirhistory_up   # Putty
  bindkey -M $keymap "\eO3A" dirhistory_zle_dirhistory_up    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[[A" dirhistory_zle_dirhistory_up ;;  # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[A" dirhistory_zle_dirhistory_up ;;     # iTerm2
  ghostty) bindkey -M $keymap "^[[1;3A" dirhistory_zle_dirhistory_up ;;      # ghostty
  esac

  if (( ${+terminfo[kcuu1]} )); then
    bindkey -M $keymap "^[${terminfo[kcuu1]}" dirhistory_zle_dirhistory_up # urxvt
  fi

  # dirhistory_down
  bindkey -M $keymap "\e[3B" dirhistory_zle_dirhistory_down    # xterm in normal mode
  bindkey -M $keymap "\e[1;3B" dirhistory_zle_dirhistory_down  # xterm in normal mode
  bindkey -M $keymap "\e\e[B" dirhistory_zle_dirhistory_down   # Putty
  bindkey -M $keymap "\eO3B" dirhistory_zle_dirhistory_down    # GNU screen

  case "$TERM_PROGRAM" in
  Apple_Terminal) bindkey -M $keymap "^[[B" dirhistory_zle_dirhistory_down ;;  # Terminal.app
  iTerm.app) bindkey -M $keymap "^[^[[B" dirhistory_zle_dirhistory_down ;;     # iTerm2
  ghostty) bindkey -M $keymap "^[[1;3B" dirhistory_zle_dirhistory_down ;;      # ghostty
  esac

  if (( ${+terminfo[kcud1]} )); then
    bindkey -M $keymap "^[${terminfo[kcud1]}" dirhistory_zle_dirhistory_down # urxvt
  fi
done

unset keymap
