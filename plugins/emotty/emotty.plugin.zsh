# ------------------------------------------------------------------------------
#          FILE: emotty.plugin.zsh
#   DESCRIPTION: Return an emoji for the current $TTY number.
#        AUTHOR: Alexis Hildebrandt (afh[at]surryhill.net)
#       VERSION: 1.0.0
#       DEPENDS: emoji plugin
#       
# There are different sets of emoji characters available, to choose a different
# set export emotty_set to the name of the set you would like to use, e.g.:
# % export emotty_set=nature
# ------------------------------------------------------------------------------

typeset -gAH _emotty_sets
local _emotty_plugin_dir="${0:h}"
source "$_emotty_plugin_dir/emotty_stellar_set.zsh"
source "$_emotty_plugin_dir/emotty_floral_set.zsh"
source "$_emotty_plugin_dir/emotty_zodiac_set.zsh"
source "$_emotty_plugin_dir/emotty_nature_set.zsh"
source "$_emotty_plugin_dir/emotty_emoji_set.zsh"
source "$_emotty_plugin_dir/emotty_love_set.zsh"
unset _emotty_plugin_dir

emotty_default_set=emoji

function emotty() {
  # Use emotty set defined by user, fallback to default
  local emotty=${_emotty_sets[${emotty_set:-$emotty_default_set}]}
  # Parse $TTY number, normalizing it to an emotty set index
  (( tty = (${TTY##/dev/tty} % ${#${=emotty}}) + 1 ))
  local character_name=${${=emotty}[tty]}
  echo "${emoji[${character_name}]}${emoji2[emoji_style]}"
}

function display_emotty() {
  local name=${1:-$emotty_set}
  echo $name
  for i in ${=_emotty_sets[$name]}; do
    printf "${emoji[$i]}${emoji2[emoji_style]}  "
  done
  print
  for i in ${=_emotty_sets[$name]}; do
    print "${emoji[$i]}${emoji2[emoji_style]}  = $i"
  done
}
