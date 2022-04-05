# emoji plugin
#
# Makes emoji support available within ZSH
#
# See the README for documentation.

# Handle $0 according to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

_omz_emoji_plugin_dir="${0:h}"

() {

local LC_ALL=en_US.UTF-8

typeset -gAH emoji_skintone

source "$_omz_emoji_plugin_dir/emoji-char-definitions.zsh"
unset _omz_emoji_plugin_dir

# These additional emoji are not in the definition file, but are useful in conjunction with it

# This is a combining character that can be placed after any other character to surround
# it in a "keycap" symbol.
# The digits 0-9 are already in the emoji table as keycap_digit_<N>, keycap_ten, etc. 
# It's unclear whether this should be in the $emoji array, because those characters are all ones
# which can be displayed on their own.

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

# Easier access to skin tone modifiers
emoji_skintone[1_2]=$'\U1F3FB'
emoji_skintone[3]=$'\U1F3FC'
emoji_skintone[4]=$'\U1F3FD'
emoji_skintone[5]=$'\U1F3FE'
emoji_skintone[6]=$'\U1F3FF'
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
	names=(${=emoji_groups[$group]})
  fi
  local list_size=${#names}
  [[ $list_size -eq 0 ]] && return 1
  local random_index=$(( ( RANDOM % $list_size ) + 1 ))
  local name=${names[$random_index]}
  if [[ "$group" == "flags" ]]; then 
    echo ${emoji_flags[$name]}
  else 
    echo ${emoji[$name]}
  fi
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
  local counter=1
  for i in $names; do
    if [[ "$group" == "flags" ]]; then 
      printf '%s  ' "$emoji_flags[$i]"
    else 
      printf '%s  ' "$emoji[$i]" 
    fi
    # New line every 20 emoji, to avoid weirdnesses
    if (($counter % 20 == 0)); then
      printf "\n" 
    fi
    let counter=$counter+1
  done
  print
  for i in $names; do
    if [[ "$group" == "flags" ]]; then 
      echo "${emoji_flags[$i]}  = $i"
    else 
      echo "${emoji[$i]}  = $i"
    fi
  done
}


