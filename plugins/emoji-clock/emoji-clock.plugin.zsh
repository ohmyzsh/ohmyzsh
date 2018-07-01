# ------------------------------------------------------------------------------
#          FILE: emoji-clock.plugin.zsh
#   DESCRIPTION: The current time with half hour accuracy as an emoji symbol.
#                Inspired by Andre Torrez' "Put A Burger In Your Shell"
#                http://notes.torrez.org/2013/04/put-a-burger-in-your-shell.html
#        AUTHOR: Alexis Hildebrandt (afh[at]surryhill.net)
#       VERSION: 2.0.0
# ------------------------------------------------------------------------------

function emoji-clock() {
  # The emoji clockface definitions are copied from the
  # emoji plugin to avoid introducing a requirement to it.
  # Should dependency tracking or dependency management
  # find its way into oh-my-zsh a dependency on the emoji
  # plugin can be specified and the local emoji_clockface
  # definitions below can be removed.
  typeset -AH emoji_clockface
  emoji_clockface[clock_face_one_oclock]=$'\U1F550'
  emoji_clockface[clock_face_two_oclock]=$'\U1F551'
  emoji_clockface[clock_face_three_oclock]=$'\U1F552'
  emoji_clockface[clock_face_four_oclock]=$'\U1F553'
  emoji_clockface[clock_face_five_oclock]=$'\U1F554'
  emoji_clockface[clock_face_six_oclock]=$'\U1F555'
  emoji_clockface[clock_face_seven_oclock]=$'\U1F556'
  emoji_clockface[clock_face_eight_oclock]=$'\U1F557'
  emoji_clockface[clock_face_nine_oclock]=$'\U1F558'
  emoji_clockface[clock_face_ten_oclock]=$'\U1F559'
  emoji_clockface[clock_face_eleven_oclock]=$'\U1F55A'
  emoji_clockface[clock_face_twelve_oclock]=$'\U1F55B'
  emoji_clockface[clock_face_one_thirty]=$'\U1F55C'
  emoji_clockface[clock_face_two_thirty]=$'\U1F55D'
  emoji_clockface[clock_face_three_thirty]=$'\U1F55E'
  emoji_clockface[clock_face_four_thirty]=$'\U1F55F'
  emoji_clockface[clock_face_five_thirty]=$'\U1F560'
  emoji_clockface[clock_face_six_thirty]=$'\U1F561'
  emoji_clockface[clock_face_seven_thirty]=$'\U1F562'
  emoji_clockface[clock_face_eight_thirty]=$'\U1F563'
  emoji_clockface[clock_face_nine_thirty]=$'\U1F564'
  emoji_clockface[clock_face_ten_thirty]=$'\U1F565'
  emoji_clockface[clock_face_eleven_thirty]=$'\U1F566'
  emoji_clockface[clock_face_twelve_thirty]=$'\U1F567'

  # Shift the current time by 15 minutes, so that the oclock face is shown
  # from "45 to "15 and the thirty face is shown from "15 to "30
  (( minutes = $(print -P '%D{%M}') + 15 ))
  (( hour = $(print -P '%D{%L}') + minutes / 60 ))
  # Make sure minutes and hours don't exceed 60 nor 12 respectively
  (( minutes %= 60 )); (( hour %= 12 ))

  hourhands="twelve one two three four five six seven eight nine ten eleven"
  hourhand=${${=hourhands}[((hour+1))]}
  if [ $minutes -ge 30 ]; then minutehand="thirty" else minutehand="oclock" fi
  echo $emoji_clockface[clock_face_${hourhand}_${minutehand}]
}
