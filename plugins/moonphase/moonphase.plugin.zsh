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

  if [[ $phase > 0 ]] && [[ $phase < 1 ]]; then
    moon="🌑 "
  elif [[ $phase > 1 ]] && [[ $phase < 7.38 ]]; then
    moon="🌒 "
  elif [[ $phase > 7.38 ]] && [[ $phase < 8.38 ]]; then
    moon="🌓 " 
  elif [[ $phase > 8.38 ]] && [[ $phase < 14.77 ]]; then
    moon="🌔 " 
  elif [[ $phase > 14.77 ]] && [[ $phase < 15.77 ]]; then
    moon="🌕 "
  elif [[ $phase > 15.77 ]] && [[ $phase < 22.15 ]]; then
    moon="🌖 "
  elif [[ $phase > 22.15 ]] && [[ $phase < 23.15 ]]; then
    moon="🌗 " 
  elif [[ $phase > 23.15 ]] && [[ $phase < 24.15 ]]; then
    moon="🌗 "
  elif [[ $phase > 24.15 ]] && [[ $phase < 29.53 ]]; then
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
