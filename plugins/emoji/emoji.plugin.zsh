# emoji plugin
#
# Makes emoji support available within ZSH
#
# This plugin provides support for working with emoji characters in zsh using human-readable
# identifiers. It provides global variables which map emoji names to the actual
# characters, and some anmed groupings of emoji. It also provides associated functions 
# for displaying them.
#
# Global variables:
#   $emoji          - Maps emoji names to characters
#   $emoji2         - Auxiliary and combining characters
#   $emoji_flags    - Maps country names to flag characters (using region-indicators)
#   $emoji_skintone - Skin tone modifiers (from Unicode 8.0)
#   $emoji_groups   - Named groups of emoji. Keys are group names; values are whitespace-separated 
#                       lists of character names
#
# Functions:
#   random_emoji   - Prints a random emoji character
#   display_emoji  - Displays emoji, along with their names
#
# The emoji names and codes are sourced from Unicode Technical Report #51, which provides
# information on emoji support in Unicode. It can be found at http://www.unicode.org/reports/tr51/index.html.
#
# The group definitions are added by this OMZ plugin. They are not based on external definitions.
#
# The emoji in the main $emoji map are standalone character sequences which can all be output on their
# own, without worrying about combining effects. The values may actually be multi-code-point sequences, 
# instead of a single code point, and may include combining characters in those sequences. But they're
# arranged so their effects do not extend beyond that sequence.
#
# Usage and Examples:
#
# To output a specific emoji, use:
#    $> echo $emoji[<name>]
# E.g.: 
#    $> echo $emoji[mouse_face]
#
# To output a random emoji, use:
#    $> random_emoji
# To output a random emoji from a particular group, use:
#    $> random_emoji <group>
# E.g.:
#    $> random_emoji fruits
#    $> random_emoji animals
#    $> random_emoji vehicles
#    $> random_emoji faces
# The valid group names can be found with `echo ${(k)emoji_groups}`
#
# To list all available emoji with their names, use:
#    $> display_emoji
#    $> display_emoji fruits
#    $> display_emoji animals
#    $> display_emoji vehicles
#    $> display_emoji faces
#
# To use emoji in a prompt:
#    PROMPT="$emoji[penguin]  > ""
#    PROMPT='$(random_emoji fruits)  > '
#    surfer=$emoji[surfer]
#    PROMPT="$surfer  > "
#
#
# TODO: Move doco to a README
# TODO: Factor out parsing from generation in update_emoji.pl
# TODO: Incorporate CLDR data for ordering and groupings
# TODO: Short :bracket: style names (from gemoji)
# TODO: Country codes for flags
# TODO: ZWJ combining function?

_omz_emoji_plugin_dir="${0:h}"

() {

local LC_ALL=en_US.UTF-8

typeset -gAH emoji_groups
typeset -gAH emoji_con
typeset -gAH emoji2
typeset -gAH emoji_skintone

source "$_omz_emoji_plugin_dir/emoji-char-definitions.zsh"
unset _omz_emoji_plugin_dir

# These additional emoji are not in the definition file, but are useful in conjunction with it

# This is a combinin character that can be placed after any other character to surround
# it in a "keycap" symbol.
# The digits 0-9 are already in the emoji table as keycap_digit_<N>, keycap_ten, etc. 
# It's unclear whether this should be in the $emoji array, because those characters are all ones
# which can be displayed on their own.
#emoji[combining_enclosing_keycap]="\U20E3"

emoji[regional_indicator_symbol_letter_d_regional_indicator_symbol_letter_e]=$'\xF0\x9F\x87\xA9\xF0\x9F\x87\xAA'
emoji[regional_indicator_symbol_letter_g_regional_indicator_symbol_letter_b]=$'\xF0\x9F\x87\xAC\xF0\x9F\x87\xA7'
emoji[regional_indicator_symbol_letter_c_regional_indicator_symbol_letter_n]=$'\xF0\x9F\x87\xA8\xF0\x9F\x87\xB3'
emoji[regional_indicator_symbol_letter_j_regional_indicator_symbol_letter_p]=$'\xF0\x9F\x87\xAF\xF0\x9F\x87\xB5'
emoji[regional_indicator_symbol_letter_k_regional_indicator_symbol_letter_r]=$'\xF0\x9F\x87\xB0\xF0\x9F\x87\xB7'
emoji[regional_indicator_symbol_letter_f_regional_indicator_symbol_letter_r]=$'\xF0\x9F\x87\xAB\xF0\x9F\x87\xB7'
emoji[regional_indicator_symbol_letter_e_regional_indicator_symbol_letter_s]=$'\xF0\x9F\x87\xAA\xF0\x9F\x87\xB8'
emoji[regional_indicator_symbol_letter_i_regional_indicator_symbol_letter_t]=$'\xF0\x9F\x87\xAE\xF0\x9F\x87\xB9'
emoji[regional_indicator_symbol_letter_u_regional_indicator_symbol_letter_s]=$'\xF0\x9F\x87\xBA\xF0\x9F\x87\xB8'
emoji[regional_indicator_symbol_letter_r_regional_indicator_symbol_letter_u]=$'\xF0\x9F\x87\xB7\xF0\x9F\x87\xBA'

# Nonstandard alias names
emoji[vulcan_salute]=$'\U1F596'


# Emoji combining and auxiliary characters

# "Variation Selectors" for controlling text vs emoji style presentation
# These apply to the immediately preceding character
emoji2[text_style]=$'\UFE0E'
emoji2[emoji_style]=$'\UFE0F'
# Joiner that indicates a single combined-form glyph (ligature) should be used
emoji2[zero_width_joiner]=$'\U200D'
# Skin tone modifiers
emoji2[emoji_modifier_fitzpatrick_type_1_2]=$'\U1F3FB'
emoji2[emoji_modifier_fitzpatrick_type_3]=$'\U1F3FC'
emoji2[emoji_modifier_fitzpatrick_type_4]=$'\U1F3FD'
emoji2[emoji_modifier_fitzpatrick_type_5]=$'\U1F3FE'
emoji2[emoji_modifier_fitzpatrick_type_6]=$'\U1F3FF'
# Various other combining characters. (Incomplete list; I selected ones that sound useful)
emoji2[combining_enclosing_circle]=$'\U20DD'
emoji2[combining_enclosing_square]=$'\U20DE'
emoji2[combining_enclosing_diamond]=$'\U20DF'
emoji2[combining_enclosing_circle_backslash]=$'\U20E0'
emoji2[combining_enclosing_screen]=$'\U20E2'
emoji2[combining_enclosing_keycap]=$'\U20E3'
emoji2[combining_enclosing_upward_pointing_triangle]=$'\U20E4'

# Easier access to skin tone modifiers
emoji_skintone[1_2]=$'\U1F3FB'
emoji_skintone[3]=$'\U1F3FC'
emoji_skintone[4]=$'\U1F3FD'
emoji_skintone[5]=$'\U1F3FE'
emoji_skintone[6]=$'\U1F3FF'

# Emoji groups
# These are stored in a single associative array, $emoji_groups, to avoid cluttering up the global
# namespace, and to allow adding additional group definitions at run time.
# The keys are the group names, and the values are whitespace-separated lists of emoji character names.
#
# These extra local arrays are used to allow more convenient formatting of the source code.

emoji_groups[fruits]="
  tomato
  aubergine
  grapes
  melon
  watermelon
  tangerine
  banana
  pineapple
  red_apple
  green_apple
  peach
  cherries
  strawberry
  lemon
  pear
"

emoji_groups[vehicles]="
  airplane
  rocket
  railway_car
  high_speed_train
  high_speed_train_with_bullet_nose
  bus
  ambulance
  fire_engine
  police_car
  taxi
  automobile
  recreational_vehicle
  delivery_truck
  ship
  speedboat
  bicycle
  helicopter
  steam_locomotive
  train
  light_rail
  tram
  oncoming_bus
  trolleybus
  minibus
  oncoming_police_car
  oncoming_taxi
  oncoming_automobile
  articulated_lorry
  tractor
  monorail
  mountain_railway
  suspension_railway
  mountain_cableway
  aerial_tramway
  rowboat
  bicyclist
  mountain_bicyclist
  sailboat
"

emoji_groups[animals]="
  snail
  snake
  horse
  sheep
  monkey
  chicken
  boar
  elephant
  octopus
  spiral_shell
  bug
  ant
  honeybee
  lady_beetle
  fish
  tropical_fish
  blowfish
  turtle
  hatching_chick
  baby_chick
  front_facing_baby_chick
  bird
  penguin
  koala
  poodle
  bactrian_camel
  dolphin
  mouse_face
  cow_face
  tiger_face
  rabbit_face
  cat_face
  dragon_face
  spouting_whale
  horse_face
  monkey_face
  dog_face
  pig_face
  frog_face
  hamster_face
  wolf_face
  bear_face
  panda_face
  rat
  mouse
  ox
  water_buffalo
  cow
  tiger
  leopard
  rabbit
  cat
  dragon
  crocodile
  whale
  ram
  goat
  rooster
  dog
  pig
  dromedary_camel
"

emoji_groups[faces]="
  grinning_face_with_smiling_eyes
  face_with_tears_of_joy
  smiling_face_with_open_mouth
  smiling_face_with_open_mouth_and_smiling_eyes
  smiling_face_with_open_mouth_and_cold_sweat
  smiling_face_with_open_mouth_and_tightly_closed_eyes
  winking_face
  smiling_face_with_smiling_eyes
  face_savouring_delicious_food
  relieved_face
  smiling_face_with_heart_shaped_eyes
  smirking_face
  unamused_face
  face_with_cold_sweat
  pensive_face
  confounded_face
  face_throwing_a_kiss
  kissing_face_with_closed_eyes
  face_with_stuck_out_tongue_and_winking_eye
  face_with_stuck_out_tongue_and_tightly_closed_eyes
  disappointed_face
  angry_face
  pouting_face
  crying_face
  persevering_face
  face_with_look_of_triumph
  disappointed_but_relieved_face
  fearful_face
  weary_face
  sleepy_face
  tired_face
  loudly_crying_face
  face_with_open_mouth_and_cold_sweat
  face_screaming_in_fear
  astonished_face
  flushed_face
  dizzy_face
  face_with_medical_mask
"

}

# Prints a random emoji character
#
#  random_emoji [group]
#
function random_emoji() {
  local group=$1
  local names
  if [[ -z "$group" || "$group" == "all" ]]; then
  	names=(${(k)emoji})
  else
  	names=(${=emoji_groups[$group_name]})
  fi
  local list_size=$#names
  local random_index=$(( ( RANDOM % $list_size ) + 1 ))
  local name=${names[$random_index]}
  echo ${emoji[$name]}
}

# Displays a listing of emoji with their names
#
# display_emoji [group]
#
function display_emoji() {
  local group=$1
  local names
  if [[ -z "$group" || "$group" == "all" ]]; then
  	names=(${(k)emoji})
  else
    names=(${=emoji_groups[$group]})
  fi
  # The extra spaces in output here are a hack for readability, since some
  # terminals treat these emoji chars as single-width.
  for i in $names; do
    printf '%s  ' "$emoji[$i]"
  done
  print
  for i in $names; do
    echo "${emoji[$i]}  = $i"
  done
}


