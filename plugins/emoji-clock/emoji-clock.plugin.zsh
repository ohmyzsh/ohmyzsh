# ------------------------------------------------------------------------------
#          FILE: emoji-clock.plugin.zsh
#   DESCRIPTION: The current time with half hour accuracy as an emoji symbol.
#                Inspired by Andre Torrez' "Put A Burger In Your Shell"
#                http://notes.torrez.org/2013/04/put-a-burger-in-your-shell.html
#        AUTHOR: Alexis Hildebrandt (afh[at]surryhill.net)
#       VERSION: 1.0.0
# -----------------------------------------------------------------------------

function emoji-clock() {
  hour=$(date -v '+15M' '+%I')
  minutes=$(date -v '+15M' '+%M')
  case $hour in
    01) clock="🕐"; [ $minutes -ge 30 ] && clock="🕜";;
    02) clock="🕑"; [ $minutes -ge 30 ] && clock="🕝";;
    03) clock="🕒"; [ $minutes -ge 30 ] && clock="🕞";;
    04) clock="🕓"; [ $minutes -ge 30 ] && clock="🕟";;
    05) clock="🕔"; [ $minutes -ge 30 ] && clock="🕠";;
    06) clock="🕕"; [ $minutes -ge 30 ] && clock="🕡";;
    07) clock="🕖"; [ $minutes -ge 30 ] && clock="🕢";;
    08) clock="🕗"; [ $minutes -ge 30 ] && clock="🕣";;
    09) clock="🕘"; [ $minutes -ge 30 ] && clock="🕤";;
    10) clock="🕙"; [ $minutes -ge 30 ] && clock="🕥";;
    11) clock="🕚"; [ $minutes -ge 30 ] && clock="🕦";;
    12) clock="🕛"; [ $minutes -ge 30 ] && clock="🕧";;
     *) clock="⌛";;
  esac
  echo $clock
}
