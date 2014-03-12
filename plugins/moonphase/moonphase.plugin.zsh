# -----------------------------------------------------------------------------
#          FILE: moonphase.plugin.zsh
#   DESCRIPTION: The current moon phase for your terminal prompt. Uses a very 
#                simple calculation based upon a known new moon date. Sorry
#                time travelers, this won't work before 1970. 
#                Just drop '$(printmoon)' into your PROMPT where you want the
#                moon emoji to appear.
#        AUTHOR: Sean Carolan (scarolan[at]gmail.com)
#       VERSION: 1.0.0
# -----------------------------------------------------------------------------

function printmoon() {
  # Accepts a time in days between 0 and 29.53
  # Defaults to the current moon phase
  if (($+1)); then
    phase=$1
  else
    phase=$(calcphase $(date +%s))
  fi

  #echo "Phase is $phase"

  if [[ $phase -gt 0 ]] && [[ $phase -lt 1 ]]; then
    moon="🌑 "
  elif [[ $phase -gt 1 ]] && [[ $phase -lt 7.38 ]]; then
    moon="🌒 "
  elif [[ $phase -gt 7.38 ]] && [[ $phase -lt 8.38 ]]; then
    moon="🌓 " 
  elif [[ $phase -gt 8.38 ]] && [[ $phase -lt 14.77 ]]; then
    moon="🌔 " 
  elif [[ $phase -gt 14.77 ]] && [[ $phase -lt 15.77 ]]; then
    moon="🌕 "
  elif [[ $phase -gt 15.77 ]] && [[ $phase -lt 22.15 ]]; then
    moon="🌖 "
  elif [[ $phase -gt 22.15 ]] && [[ $phase -lt 23.15 ]]; then
    moon="🌗 " 
  elif [[ $phase -gt 23.15 ]] && [[ $phase -lt 24.15 ]]; then
    moon="🌗 "
  elif [[ $phase -gt 24.15 ]] && [[ $phase -lt 29.53 ]]; then
    moon="🌘 "
  fi
  echo $moon
}

function calcphase() {
  # Accepts a Unix epoch date, in seconds.
  target_date=$1
  # Fixed lunar phase in seconds
  lp=2551443
  # This is the date of a known new moon: January 7, 1970 20:35 GMT
  new_moon=592500
  (( phase=(($target_date - $new_moon) % $lp) / (24.0 * 3600) ))
  echo $phase
}
