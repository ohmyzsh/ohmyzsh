_printable_len () {
  # Erroneously includes non-printables like colors
  #print "${#${(%):-$1}}"

  # Does not work for dates like %D{%a %b %d, %I:%M:%S%P}
  #local zero='%([BSUbfksu]|([FB]|){*})'
  #print "${#${(S%%)1//$~zero/}}"

  print "$(print -nP "$1" | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" | wc -c)" # wc -c is necessary because ${#$(print -n)} is 1
}

precmd () {
  local retval="$?"
  #local before_wd="%(?::%K{red}%?%k%K{blue} %k)%K{blue}%n@%m:" # "$? $(whoami)@$(hostname):" # Throws off line length
  local before_wd="$([[ "$retval" != 0 ]] && print "%K{red}$retval%k%K{blue} %k")%K{blue}%n@%m:" # "$? $(whoami)@$(hostname):"
  local after_wd="$(git_prompt_info)$(virtualenv_prompt_info)"
  local right="%D{%a %b %d, %I:%M:%S%P}" # "$(date)"
  local space_remaining="$(( $COLUMNS - $(_printable_len "$before_wd") - $(_printable_len "$after_wd") - $(_printable_len "$right") ))"
  local wd="%$(( $space_remaining - 1 ))<…<%~%<<" # last (( $space_remaining - 1 )) characters

  print -P "\r%B%F{white}$before_wd$wd%f%b%K{blue}$after_wd${(r:(( $space_remaining - $(_printable_len "$wd") )):)}%F{white}$right%f%k"
}

zmodload zsh/mathfunc
_lastcolumns="$COLUMNS"
TRAPWINCH () {
  print -n '\r' && tput el # go to beginning of line and erase the rest of it
  for (( line = 0; line < ceil(float($_lastcolumns)/COLUMNS); line++ )); do
    tput cuu1 && tput el # go up a line and erase it
  done

  precmd
  print -nP "$PROMPT"

  _lastcolumns="$COLUMNS"
}

ZSH_THEME_GIT_PROMPT_PREFIX=" ("
ZSH_THEME_GIT_PROMPT_SUFFIX=")"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='%(!.%F{red}.%F{green})%B%#%b%f '
