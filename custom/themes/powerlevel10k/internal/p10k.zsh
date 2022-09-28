if [[ $__p9k_sourced != 13 ]]; then
  >&2 print -P ""
  >&2 print -P "[%F{1}ERROR%f]: Corrupted powerlevel10k installation."
  >&2 print -P ""
  if (( ${+functions[antigen]} )); then
    >&2 print -P "If using %Bantigen%b, run the following command to fix:"
    >&2 print -P ""
    >&2 print -P "    %F{2}antigen%f reset"
    if [[ -d ~/.antigen ]]; then
      >&2 print -P ""
      >&2 print -P "If it doesn't help, try this:"
      >&2 print -P ""
      >&2 print -P "    %F{2}rm%f -rf %U~/.antigen%u"
    fi
  else
    >&2 print -P "Try resetting cache in your plugin manager or"
    >&2 print -P "reinstalling powerlevel10k from scratch."
  fi
  >&2 print -P ""
  return 1
fi

if ! autoload -Uz is-at-least || ! is-at-least 5.1; then
  () {
    >&2 echo -E "You are using ZSH version $ZSH_VERSION. The minimum required version for Powerlevel10k is 5.1."
    >&2 echo -E "Type 'echo \$ZSH_VERSION' to see your current zsh version."
    local def=${SHELL:c:A}
    local cur=${${ZSH_ARGZERO#-}:c:A}
    local cur_v="$($cur -c 'echo -E $ZSH_VERSION' 2>/dev/null)"
    if [[ $cur_v == $ZSH_VERSION && $cur != $def ]]; then
      >&2 echo -E "The shell you are currently running is likely $cur."
    fi
    local other=${${:-zsh}:c}
    if [[ -n $other ]] && $other -c 'autoload -Uz is-at-least && is-at-least 5.1' &>/dev/null; then
      local other_v="$($other -c 'echo -E $ZSH_VERSION' 2>/dev/null)"
      if [[ -n $other_v && $other_v != $ZSH_VERSION ]]; then
        >&2 echo -E "You have $other with version $other_v but this is not what you are using."
        if [[ -n $def && $def != ${other:A} ]]; then
          >&2 echo -E "To change your user shell, type the following command:"
          >&2 echo -E ""
          if [[ "$(grep -F $other /etc/shells 2>/dev/null)" != $other ]]; then
            >&2 echo -E "  echo ${(q-)other} | sudo tee -a /etc/shells"
          fi
          >&2 echo -E "  chsh -s ${(q-)other}"
        fi
      fi
    fi
  }
  return 1
fi

builtin source "${__p9k_root_dir}/internal/configure.zsh"
builtin source "${__p9k_root_dir}/internal/worker.zsh"
builtin source "${__p9k_root_dir}/internal/parser.zsh"
builtin source "${__p9k_root_dir}/internal/icons.zsh"

# For compatibility with Powerlevel9k. It's not recommended to use mnemonic color
# names in the configuration except for colors 0-7 as these are standard.
typeset -grA __p9k_colors=(
            black 000               red 001             green 002            yellow 003
             blue 004           magenta 005              cyan 006             white 007
             grey 008            maroon 009              lime 010             olive 011
             navy 012           fuchsia 013              aqua 014              teal 014
           silver 015             grey0 016          navyblue 017          darkblue 018
            blue3 020             blue1 021         darkgreen 022      deepskyblue4 025
      dodgerblue3 026       dodgerblue2 027            green4 028      springgreen4 029
       turquoise4 030      deepskyblue3 032       dodgerblue1 033          darkcyan 036
    lightseagreen 037      deepskyblue2 038      deepskyblue1 039            green3 040
     springgreen3 041             cyan3 043     darkturquoise 044        turquoise2 045
           green1 046      springgreen2 047      springgreen1 048 mediumspringgreen 049
            cyan2 050             cyan1 051           purple4 055           purple3 056
       blueviolet 057            grey37 059     mediumpurple4 060        slateblue3 062
       royalblue1 063       chartreuse4 064    paleturquoise4 066         steelblue 067
       steelblue3 068    cornflowerblue 069     darkseagreen4 071         cadetblue 073
         skyblue3 074       chartreuse3 076         seagreen3 078       aquamarine3 079
  mediumturquoise 080        steelblue1 081         seagreen2 083         seagreen1 085
   darkslategray2 087           darkred 088       darkmagenta 091           orange4 094
       lightpink4 095             plum4 096     mediumpurple3 098        slateblue1 099
           wheat4 101            grey53 102    lightslategrey 103      mediumpurple 104
   lightslateblue 105           yellow4 106      darkseagreen 108     lightskyblue3 110
         skyblue2 111       chartreuse2 112        palegreen3 114    darkslategray3 116
         skyblue1 117       chartreuse1 118        lightgreen 120       aquamarine1 122
   darkslategray1 123         deeppink4 125   mediumvioletred 126        darkviolet 128
           purple 129     mediumorchid3 133      mediumorchid 134     darkgoldenrod 136
        rosybrown 138            grey63 139     mediumpurple2 140     mediumpurple1 141
        darkkhaki 143      navajowhite3 144            grey69 145   lightsteelblue3 146
   lightsteelblue 147   darkolivegreen3 149     darkseagreen3 150        lightcyan3 152
    lightskyblue1 153       greenyellow 154   darkolivegreen2 155        palegreen1 156
    darkseagreen2 157    paleturquoise1 159              red3 160         deeppink3 162
         magenta3 164       darkorange3 166         indianred 167          hotpink3 168
         hotpink2 169            orchid 170           orange3 172      lightsalmon3 173
       lightpink3 174             pink3 175             plum3 176            violet 177
            gold3 178   lightgoldenrod3 179               tan 180        mistyrose3 181
         thistle3 182             plum2 183           yellow3 184            khaki3 185
     lightyellow3 187            grey84 188   lightsteelblue1 189           yellow2 190
  darkolivegreen1 192     darkseagreen1 193         honeydew2 194        lightcyan1 195
             red1 196         deeppink2 197         deeppink1 199          magenta2 200
         magenta1 201        orangered1 202        indianred1 204           hotpink 206
    mediumorchid1 207        darkorange 208           salmon1 209        lightcoral 210
   palevioletred1 211           orchid2 212           orchid1 213           orange1 214
       sandybrown 215      lightsalmon1 216        lightpink1 217             pink1 218
            plum1 219             gold1 220   lightgoldenrod2 222      navajowhite1 223
       mistyrose1 224          thistle1 225           yellow1 226   lightgoldenrod1 227
           khaki1 228            wheat1 229         cornsilk1 230           grey100 231
            grey3 232             grey7 233            grey11 234            grey15 235
           grey19 236            grey23 237            grey27 238            grey30 239
           grey35 240            grey39 241            grey42 242            grey46 243
           grey50 244            grey54 245            grey58 246            grey62 247
           grey66 248            grey70 249            grey74 250            grey78 251
           grey82 252            grey85 253            grey89 254            grey93 255)

# For compatibility with Powerlevel9k.
#
# Type `getColorCode background` or `getColorCode foreground` to see the list of predefined colors.
function getColorCode() {
  eval "$__p9k_intro"
  if (( ARGC == 1 )); then
    case $1 in
      foreground)
        local k
        for k in "${(k@)__p9k_colors}"; do
          local v=${__p9k_colors[$k]}
          print -rP -- "%F{$v}$v - $k%f"
        done
        return 0
        ;;
      background)
        local k
        for k in "${(k@)__p9k_colors}"; do
          local v=${__p9k_colors[$k]}
          print -rP -- "%K{$v}$v - $k%k"
        done
        return 0
        ;;
    esac
  fi
  echo "Usage: getColorCode background|foreground" >&2
  return 1
}

# _p9k_declare <type> <uppercase-name> [default]...
function _p9k_declare() {
  local -i set=$+parameters[$2]
  (( ARGC > 2 || set )) || return 0
  case $1 in
    -b)
      if (( set )); then
        [[ ${(P)2} == true ]] && typeset -gi _$2=1 || typeset -gi _$2=0
      else
        typeset -gi _$2=$3
      fi
      ;;
    -a)
      local -a v=("${(@P)2}")
      if (( set )); then
        eval "typeset -ga _${(q)2}=(${(@qq)v})";
      else
        if [[ $3 != '--' ]]; then
          echo "internal error in _p9k_declare " "${(qqq)@}" >&2
        fi
        eval "typeset -ga _${(q)2}=(${(@qq)*[4,-1]})"
      fi
      ;;
    -i)
      (( set )) && typeset -gi _$2=$2 || typeset -gi _$2=$3
      ;;
    -F)
      (( set )) && typeset -gF _$2=$2 || typeset -gF _$2=$3
      ;;
    -s)
      (( set )) && typeset -g _$2=${(P)2} || typeset -g _$2=$3
      ;;
    -e)
      if (( set )); then
        local v=${(P)2}
        typeset -g _$2=${(g::)v}
      else
        typeset -g _$2=${(g::)3}
      fi
      ;;
    *)
      echo "internal error in _p9k_declare " "${(qqq)@}" >&2
  esac
}

function _p9k_read_word() {
  local -a stat
  zstat -A stat +mtime -- $1 2>/dev/null || stat=(-1)
  local cached=$_p9k__read_word_cache[$1]
  if [[ $cached == $stat[1]:* ]]; then
    _p9k__ret=${cached#*:}
  else
    local rest
    _p9k__ret=
    { read _p9k__ret rest <$1 } 2>/dev/null
    _p9k__ret=${_p9k__ret%$'\r'}
    _p9k__read_word_cache[$1]=$stat[1]:$_p9k__ret
  fi
  [[ -n $_p9k__ret ]]
}

function _p9k_fetch_cwd() {
  if [[ $PWD == /* && $PWD -ef . ]]; then
    _p9k__cwd=$PWD
  else
    _p9k__cwd=${${${:-.}:a}:-.}
  fi
  _p9k__cwd_a=${${_p9k__cwd:A}:-.}

  case $_p9k__cwd in
    /|.)
      _p9k__parent_dirs=()
      _p9k__parent_mtimes=()
      _p9k__parent_mtimes_i=()
      _p9k__parent_mtimes_s=
      return
    ;;
    ~|~/*)
      local parent=${${${:-~/..}:a}%/}/
      local parts=(${(s./.)_p9k__cwd#$parent})
    ;;
    *)
      local parent=/
      local parts=(${(s./.)_p9k__cwd})
    ;;
  esac
  local MATCH
  _p9k__parent_dirs=(${(@)${:-{$#parts..1}}/(#m)*/$parent${(pj./.)parts[1,MATCH]}})
  if ! zstat -A _p9k__parent_mtimes +mtime -- $_p9k__parent_dirs 2>/dev/null; then
    _p9k__parent_mtimes=(${(@)parts/*/-1})
  fi
  _p9k__parent_mtimes_i=(${(@)${:-{1..$#parts}}/(#m)*/$MATCH:$_p9k__parent_mtimes[MATCH]})
  _p9k__parent_mtimes_s="$_p9k__parent_mtimes_i"
}

# Usage: _p9k_glob parent_dir_index pattern
#
# parent_dir_index indexes _p9k__parent_dirs.
#
# Returns the number of matches.
#
# Pattern cannot have slashes.
#
# Example: _p9k_glob 3 '*.csproj'
function _p9k_glob() {
  local dir=$_p9k__parent_dirs[$1]
  local cached=$_p9k__glob_cache[$dir/$2]
  if [[ $cached == $_p9k__parent_mtimes[$1]:* ]]; then
    return ${cached##*:}
  fi
  local -a stat
  zstat -A stat +mtime -- $dir 2>/dev/null || stat=(-1)
  local files=($dir/$~2(N:t))
  _p9k__glob_cache[$dir/$2]="$stat[1]:$#files"
  return $#files
}

# Usage: _p9k_upglob pattern
#
# Returns index within _p9k__parent_dirs or 0 if there is no match.
#
# Search stops before reaching ~/../ or / and never matches in those directories.
#
# Example: _p9k_upglob '*.csproj'
function _p9k_upglob() {
  local cached=$_p9k__upsearch_cache[$_p9k__cwd/$1]
  if [[ -n $cached ]]; then
    if [[ $_p9k__parent_mtimes_s == ${cached% *}(| *) ]]; then
      return ${cached##* }
    fi
    cached=(${(s: :)cached})
    local last_idx=$cached[-1]
    cached[-1]=()
    local -i i
    for i in ${(@)${cached:|_p9k__parent_mtimes_i}%:*}; do
      _p9k_glob $i $1 && continue
      _p9k__upsearch_cache[$_p9k__cwd/$1]="${_p9k__parent_mtimes_i[1,i]} $i"
      return i
    done
    if (( i != last_idx )); then
      _p9k__upsearch_cache[$_p9k__cwd/$1]="${_p9k__parent_mtimes_i[1,$#cached]} $last_idx"
      return last_idx
    fi
    i=$(($#cached + 1))
  else
    local -i i=1
  fi
  for ((; i <= $#_p9k__parent_mtimes; ++i)); do
    _p9k_glob $i $1 && continue
    _p9k__upsearch_cache[$_p9k__cwd/$1]="${_p9k__parent_mtimes_i[1,i]} $i"
    return i
  done
  _p9k__upsearch_cache[$_p9k__cwd/$1]="$_p9k__parent_mtimes_s 0"
  return 0
}

# If we execute `print -P $1`, how many characters will be printed on the last line?
# Assumes that `%{%}` and `%G` don't lie.
#
#   _p9k_prompt_length '' => 0
#   _p9k_prompt_length 'abc' => 3
#   _p9k_prompt_length $'abc\nxy' => 2
#   _p9k_prompt_length $'\t' => 8
#   _p9k_prompt_length '%F{red}abc' => 3
#   _p9k_prompt_length $'%{a\b%Gb%}' => 1
function _p9k_prompt_length() {
  local -i COLUMNS=1024
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
      x=y
      (( y *= 2 ))
    done
    while (( y > x + 1 )); do
      (( m = x + (y - x) / 2 ))
      (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g _p9k__ret=$x
}

typeset -gr __p9k_byte_suffix=('B' 'K' 'M' 'G' 'T' 'P' 'E' 'Z' 'Y')

# 512 => 512B
# 1800 => 1.76K
# 18000 => 17.6K
function _p9k_human_readable_bytes() {
  typeset -F n=$1
  local suf
  for suf in $__p9k_byte_suffix; do
    (( n < 1024 )) && break
    (( n /= 1024 ))
  done
  if (( n >= 100 )); then
    printf -v _p9k__ret '%.0f.' $n
  elif (( n >= 10 )); then
    printf -v _p9k__ret '%.1f' $n
  else
    printf -v _p9k__ret '%.2f' $n
  fi
  _p9k__ret=${${_p9k__ret%%0#}%.}$suf
}

if is-at-least 5.4; then
  function _p9k_print_params() { typeset -p -- "$@" }
else
  # Cannot use `typeset -p` unconditionally because of bugs in zsh.
  function _p9k_print_params() {
    local name
    for name; do
      case $parameters[$name] in
        array*)
          print -r -- "$name=(" "${(@q)${(@P)name}}" ")"
        ;;
        association*)
          # Cannot use "${(@q)${(@kvP)name}}" because of bugs in zsh.
          local kv=("${(@kvP)name}")
          print -r -- "$name=(" "${(@q)kv}" ")"
        ;;
        *)
          print -r -- "$name=${(q)${(P)name}}"
        ;;
      esac
    done
  }
fi

# Determine if the passed segment is used in the prompt
#
# Pass the name of the segment to this function to test for its presence in
# either the LEFT or RIGHT prompt arrays.
#    * $1: The segment to be tested.
_p9k_segment_in_use() {
  (( $_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[(I)$1(|_joined)] ||
     $_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[(I)$1(|_joined)] ))
}

# Caching allows storing array-to-array associations. It should be used like this:
#
#   if ! _p9k_cache_get "$key1" "$key2"; then
#     # Compute val1 and val2 and then store them in the cache.
#     _p9k_cache_set "$val1" "$val2"
#   fi
#   # Here ${_p9k__cache_val[1]} and ${_p9k__cache_val[2]} are $val1 and $val2 respectively.
#
# Limitations:
#
#   * Calling _p9k_cache_set without arguments clears the cache entry. Subsequent calls to
#     _p9k_cache_get for the same key will return an error.
#   * There must be no intervening _p9k_cache_get calls between the associated _p9k_cache_get
#     and _p9k_cache_set.
_p9k_cache_set() {
  # Uncomment to see cache misses.
  # echo "caching: ${(@0q)_p9k__cache_key} => (${(q)@})" >&2
  _p9k_cache[$_p9k__cache_key]="${(pj:\0:)*}0"
  _p9k__cache_val=("$@")
  _p9k__state_dump_scheduled=1
}

_p9k_cache_get() {
  _p9k__cache_key="${(pj:\0:)*}"
  local v=$_p9k_cache[$_p9k__cache_key]
  [[ -n $v ]] && _p9k__cache_val=("${(@0)${v[1,-2]}}")
}

_p9k_cache_ephemeral_set() {
  # Uncomment to see cache misses.
  # echo "caching: ${(@0q)_p9k__cache_key} => (${(q)@})" >&2
  _p9k__cache_ephemeral[$_p9k__cache_key]="${(pj:\0:)*}0"
  _p9k__cache_val=("$@")
}

_p9k_cache_ephemeral_get() {
  _p9k__cache_key="${(pj:\0:)*}"
  local v=$_p9k__cache_ephemeral[$_p9k__cache_key]
  [[ -n $v ]] && _p9k__cache_val=("${(@0)${v[1,-2]}}")
}

_p9k_cache_stat_get() {
  local -H stat
  local label=$1 f
  shift

  _p9k__cache_stat_meta=
  _p9k__cache_stat_fprint=

  for f; do
    if zstat -H stat -- $f 2>/dev/null; then
      _p9k__cache_stat_meta+="${(q)f} $stat[inode] $stat[mtime] $stat[size] $stat[mode]; "
    fi
  done

  if _p9k_cache_get $0 $label meta "$@"; then
     if [[ $_p9k__cache_val[1] == $_p9k__cache_stat_meta ]]; then
      _p9k__cache_stat_fprint=$_p9k__cache_val[2]
      local -a key=($0 $label fprint "$@" "$_p9k__cache_stat_fprint")
      _p9k__cache_fprint_key="${(pj:\0:)key}"
      shift 2 _p9k__cache_val
      return 0
    else
      local -a key=($0 $label fprint "$@" "$_p9k__cache_val[2]")
      _p9k__cache_ephemeral[${(pj:\0:)key}]="${(pj:\0:)_p9k__cache_val[3,-1]}0"
    fi
  fi

  if (( $+commands[md5] )); then
    _p9k__cache_stat_fprint="$(md5 -- $* 2>&1)"
  elif (( $+commands[md5sum] )); then
    _p9k__cache_stat_fprint="$(md5sum -b -- $* 2>&1)"
  else
    return 1
  fi

  local meta_key=$_p9k__cache_key
  if _p9k_cache_ephemeral_get $0 $label fprint "$@" "$_p9k__cache_stat_fprint"; then
    _p9k__cache_fprint_key=$_p9k__cache_key
    _p9k__cache_key=$meta_key
    _p9k_cache_set "$_p9k__cache_stat_meta" "$_p9k__cache_stat_fprint" "$_p9k__cache_val[@]"
    shift 2 _p9k__cache_val
    return 0
  fi

  _p9k__cache_fprint_key=$_p9k__cache_key
  _p9k__cache_key=$meta_key
  return 1
}

_p9k_cache_stat_set() {
  _p9k_cache_set "$_p9k__cache_stat_meta" "$_p9k__cache_stat_fprint" "$@"
  _p9k__cache_key=$_p9k__cache_fprint_key
  _p9k_cache_ephemeral_set "$@"
}

# _p9k_param prompt_foo_BAR BACKGROUND red
_p9k_param() {
  local key="_p9k_param ${(pj:\0:)*}"
  _p9k__ret=$_p9k_cache[$key]
  if [[ -n $_p9k__ret ]]; then
    _p9k__ret[-1,-1]=''
  else
    if [[ ${1//-/_} == (#b)prompt_([a-z0-9_]#)(*) ]]; then
      local var=_POWERLEVEL9K_${${(U)match[1]}//İ/I}$match[2]_$2
      if (( $+parameters[$var] )); then
        _p9k__ret=${(P)var}
      else
        var=_POWERLEVEL9K_${${(U)match[1]%_}//İ/I}_$2
        if (( $+parameters[$var] )); then
          _p9k__ret=${(P)var}
        else
          var=_POWERLEVEL9K_$2
          if (( $+parameters[$var] )); then
            _p9k__ret=${(P)var}
          else
            _p9k__ret=$3
          fi
        fi
      fi
    else
      local var=_POWERLEVEL9K_$2
      if (( $+parameters[$var] )); then
        _p9k__ret=${(P)var}
      else
        _p9k__ret=$3
      fi
    fi
    _p9k_cache[$key]=${_p9k__ret}.
  fi
}

# _p9k_get_icon prompt_foo_BAR BAZ_ICON quix
_p9k_get_icon() {
  local key="_p9k_get_icon ${(pj:\0:)*}"
  _p9k__ret=$_p9k_cache[$key]
  if [[ -n $_p9k__ret ]]; then
    _p9k__ret[-1,-1]=''
  else
    if [[ $2 == $'\1'* ]]; then
      _p9k__ret=${2[2,-1]}
    else
      _p9k_param "$1" "$2" ${icons[$2]-$'\1'$3}
      if [[ $_p9k__ret == $'\1'* ]]; then
        _p9k__ret=${_p9k__ret[2,-1]}
      else
        _p9k__ret=${(g::)_p9k__ret}
        [[ $_p9k__ret != $'\b'? ]] || _p9k__ret="%{$_p9k__ret%}"  # penance for past sins
      fi
    fi
    _p9k_cache[$key]=${_p9k__ret}.
  fi
}

_p9k_translate_color() {
  if [[ $1 == <-> ]]; then                  # decimal color code: 255
    _p9k__ret=${(l.3..0.)1}
  elif [[ $1 == '#'[[:xdigit:]]## ]]; then  # hexademical color code: #ffffff
    _p9k__ret=${${(L)1}//ı/i}
  else                                      # named color: red
    # Strip prifixes if there are any.
    _p9k__ret=$__p9k_colors[${${${1#bg-}#fg-}#br}]
  fi
}

# _p9k_color prompt_foo_BAR BACKGROUND red
_p9k_color() {
  local key="_p9k_color ${(pj:\0:)*}"
  _p9k__ret=$_p9k_cache[$key]
  if [[ -n $_p9k__ret ]]; then
    _p9k__ret[-1,-1]=''
  else
    _p9k_param "$@"
    _p9k_translate_color $_p9k__ret
    _p9k_cache[$key]=${_p9k__ret}.
  fi
}

# _p9k_vcs_style CLEAN REMOTE_BRANCH
_p9k_vcs_style() {
  local key="$0 ${(pj:\0:)*}"
  _p9k__ret=$_p9k_cache[$key]
  if [[ -n $_p9k__ret ]]; then
    _p9k__ret[-1,-1]=''
  else
    local style=%b  # TODO: support bold
    _p9k_color prompt_vcs_$1 BACKGROUND "${__p9k_vcs_states[$1]}"
    _p9k_background $_p9k__ret
    style+=$_p9k__ret

    local var=_POWERLEVEL9K_VCS_${1}_${2}FORMAT_FOREGROUND
    if (( $+parameters[$var] )); then
      _p9k_translate_color "${(P)var}"
    else
      var=_POWERLEVEL9K_VCS_${2}FORMAT_FOREGROUND
      if (( $+parameters[$var] )); then
        _p9k_translate_color "${(P)var}"
      else
        _p9k_color prompt_vcs_$1 FOREGROUND "$_p9k_color1"
      fi
    fi

    _p9k_foreground $_p9k__ret
    _p9k__ret=$style$_p9k__ret
    _p9k_cache[$key]=${_p9k__ret}.
  fi
}

_p9k_background() {
  [[ -n $1 ]] && _p9k__ret="%K{$1}" || _p9k__ret="%k"
}

_p9k_foreground() {
  # Note: This code used to produce `%1F` instead of `%F{1}` because it's more efficient.
  # Unfortunately, this triggers a bug in zsh. Namely, `%1F{2}` gets percent-expanded as if
  # it was `%F{2}`.
  [[ -n $1 ]] && _p9k__ret="%F{$1}" || _p9k__ret="%f"
}

_p9k_escape_style() {
  [[ $1 == *'}'* ]] && _p9k__ret='${:-"'$1'"}' || _p9k__ret=$1
}

_p9k_escape() {
  [[ $1 == *["~!#\`\$^&*()\\\"'<>?{}[]"]* ]] && _p9k__ret="\${(Q)\${:-${(qqq)${(q)1}}}}" || _p9k__ret=$1
}

# * $1: Name of the function that was originally invoked.
#       Necessary, to make the dynamic color-overwrite mechanism work.
# * $2: Background color.
# * $3: Foreground color.
# * $4: An identifying icon.
# * $5: 1 to to perform parameter expansion and process substitution.
# * $6: If not empty but becomes empty after parameter expansion and process substitution,
#       the segment isn't rendered.
# * $7: Content.
_p9k_left_prompt_segment() {
  if ! _p9k_cache_get "$0" "$1" "$2" "$3" "$4" "$_p9k__segment_index"; then
    _p9k_color $1 BACKGROUND $2
    local bg_color=$_p9k__ret
    _p9k_background $bg_color
    local bg=$_p9k__ret

    _p9k_color $1 FOREGROUND $3
    local fg_color=$_p9k__ret
    _p9k_foreground $fg_color
    local fg=$_p9k__ret

    local style=%b$bg$fg
    local style_=${style//\}/\\\}}

    _p9k_get_icon $1 LEFT_SEGMENT_SEPARATOR
    local sep=$_p9k__ret
    _p9k_escape $_p9k__ret
    local sep_=$_p9k__ret

    _p9k_get_icon $1 LEFT_SUBSEGMENT_SEPARATOR
    _p9k_escape $_p9k__ret
    local subsep_=$_p9k__ret

    local icon_
    if [[ -n $4 ]]; then
      _p9k_get_icon $1 $4
      _p9k_escape $_p9k__ret
      icon_=$_p9k__ret
    fi

    _p9k_get_icon $1 LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL
    local start_sep=$_p9k__ret
    [[ -n $start_sep ]] && start_sep="%b%k%F{$bg_color}$start_sep"

    _p9k_get_icon $1 LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL $sep
    _p9k_escape $_p9k__ret
    local end_sep_=$_p9k__ret

    _p9k_get_icon $1 WHITESPACE_BETWEEN_LEFT_SEGMENTS ' '
    local space=$_p9k__ret

    _p9k_get_icon $1 LEFT_LEFT_WHITESPACE $space
    local left_space=$_p9k__ret
    [[ $left_space == *%* ]] && left_space+=$style

    _p9k_get_icon $1 LEFT_RIGHT_WHITESPACE $space
    _p9k_escape $_p9k__ret
    local right_space_=$_p9k__ret
    [[ $right_space_ == *%* ]] && right_space_+=$style_

    local s='<_p9k__s>' ss='<_p9k__ss>'

    local -i non_hermetic=0

    # Segment separator logic:
    #
    #   if [[ $_p9k__bg == NONE ]]; then
    #     1
    #   elif (( joined )); then
    #     2
    #   elif [[ $bg_color == (${_p9k__bg}|${_p9k__bg:-0}) ]]; then
    #     3
    #   else
    #     4
    #   fi

    local t=$(($#_p9k_t - __p9k_ksh_arrays))
    _p9k_t+=$start_sep$style$left_space              # 1
    _p9k_t+=$style                                   # 2
    if [[ -n $fg_color && $fg_color == $bg_color ]]; then
      if [[ $fg_color == $_p9k_color1 ]]; then
        _p9k_foreground $_p9k_color2
      else
        _p9k_foreground $_p9k_color1
      fi
      _p9k_t+=%b$bg$_p9k__ret$ss$style$left_space    # 3
    else
      _p9k_t+=%b$bg$ss$style$left_space              # 3
    fi
    _p9k_t+=%b$bg$s$style$left_space                 # 4

    local join="_p9k__i>=$_p9k_left_join[$_p9k__segment_index]"
    _p9k_param $1 SELF_JOINED false
    if [[ $_p9k__ret == false ]]; then
      if (( _p9k__segment_index > $_p9k_left_join[$_p9k__segment_index] )); then
        join+="&&_p9k__i<$_p9k__segment_index"
      else
        join=
      fi
    fi

    local p=
    p+="\${_p9k__n::=}"
    p+="\${\${\${_p9k__bg:-0}:#NONE}:-\${_p9k__n::=$((t+1))}}"                                # 1
    if [[ -n $join ]]; then
      p+="\${_p9k__n:=\${\${\$(($join)):#0}:+$((t+2))}}"                                      # 2
    fi
    if (( __p9k_sh_glob )); then
      p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x\$_p9k__bg}:+$((t+3))}}"                    # 3
      p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x\$${_p9k__bg:-0}}:+$((t+3))}}"              # 3
    else
      p+="\${_p9k__n:=\${\${(M)\${:-x$bg_color}:#x(\$_p9k__bg|\${_p9k__bg:-0})}:+$((t+3))}}"  # 3
    fi
    p+="\${_p9k__n:=$((t+4))}"                                                                # 4

    _p9k_param $1 VISUAL_IDENTIFIER_EXPANSION '${P9K_VISUAL_IDENTIFIER}'
    [[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1
    local icon_exp_=${_p9k__ret:+\"$_p9k__ret\"}

    _p9k_param $1 CONTENT_EXPANSION '${P9K_CONTENT}'
    [[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1
    local content_exp_=${_p9k__ret:+\"$_p9k__ret\"}

    if [[ ( $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ) ||
          ( $content_exp_ != '"${P9K_CONTENT}"' && $content_exp_ == *'$'* ) ]]; then
      p+="\${P9K_VISUAL_IDENTIFIER::=$icon_}"
    fi

    local -i has_icon=-1  # maybe

    if [[ $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ]]; then
      p+='${_p9k__v::='$icon_exp_$style_'}'
    else
      [[ $icon_exp_ == '"${P9K_VISUAL_IDENTIFIER}"' ]] && _p9k__ret=$icon_ || _p9k__ret=$icon_exp_
      if [[ -n $_p9k__ret ]]; then
        p+="\${_p9k__v::=$_p9k__ret"
        [[ $_p9k__ret == *%* ]] && p+=$style_
        p+="}"
        has_icon=1  # definitely yes
      else
        has_icon=0  # definitely no
      fi
    fi

    p+='${_p9k__c::='$content_exp_'}${_p9k__c::=${_p9k__c//'$'\r''}}'
    p+='${_p9k__e::=${${_p9k__'${_p9k__line_index}l${${1#prompt_}%%[A-Z0-9_]#}'+00}:-'
    if (( has_icon == -1 )); then
      p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}${${(%):-$_p9k__v%1(l.1.0)}[-1]}}'
    else
      p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}'$has_icon'}'
    fi

    p+='}}+}'

    p+='${${_p9k__e:#00}:+${${_p9k_t[$_p9k__n]/'$ss'/$_p9k__ss}/'$s'/$_p9k__s}'

    _p9k_param $1 ICON_BEFORE_CONTENT ''
    if [[ $_p9k__ret != false ]]; then
      _p9k_param $1 PREFIX ''
      _p9k__ret=${(g::)_p9k__ret}
      _p9k_escape $_p9k__ret
      p+=$_p9k__ret
      [[ $_p9k__ret == *%* ]] && local -i need_style=1 || local -i need_style=0

      if (( has_icon != 0 )); then
        _p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
        _p9k_foreground $_p9k__ret
        _p9k__ret=%b$bg$_p9k__ret
        _p9k__ret=${_p9k__ret//\}/\\\}}
        if [[ $_p9k__ret != $style_ ]]; then
          p+=$_p9k__ret'${_p9k__v}'$style_
        else
          (( need_style )) && p+=$style_
          p+='${_p9k__v}'
        fi

        _p9k_get_icon $1 LEFT_MIDDLE_WHITESPACE ' '
        if [[ -n $_p9k__ret ]]; then
          _p9k_escape $_p9k__ret
          [[ _p9k__ret == *%* ]] && _p9k__ret+=$style_
          p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}'
        fi
      elif (( need_style )); then
        p+=$style_
      fi

      p+='${_p9k__c}'$style_
    else
      _p9k_param $1 PREFIX ''
      _p9k__ret=${(g::)_p9k__ret}
      _p9k_escape $_p9k__ret
      p+=$_p9k__ret
      [[ $_p9k__ret == *%* ]] && p+=$style_

      p+='${_p9k__c}'$style_

      if (( has_icon != 0 )); then
        local -i need_style=0
        _p9k_get_icon $1 LEFT_MIDDLE_WHITESPACE ' '
        if [[ -n $_p9k__ret ]]; then
          _p9k_escape $_p9k__ret
          [[ $_p9k__ret == *%* ]] && need_style=1
          p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}'
        fi

        _p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
        _p9k_foreground $_p9k__ret
        _p9k__ret=%b$bg$_p9k__ret
        _p9k__ret=${_p9k__ret//\}/\\\}}
        [[ $_p9k__ret != $style_ || $need_style == 1 ]] && p+=$_p9k__ret
        p+='$_p9k__v'
      fi
    fi

    _p9k_param $1 SUFFIX ''
    _p9k__ret=${(g::)_p9k__ret}
    _p9k_escape $_p9k__ret
    p+=$_p9k__ret
    [[ $_p9k__ret == *%* && -n $right_space_ ]] && p+=$style_
    p+=$right_space_

    p+='${${:-'
    p+="\${_p9k__s::=%F{$bg_color\}$sep_}\${_p9k__ss::=$subsep_}\${_p9k__sss::=%F{$bg_color\}$end_sep_}"
    p+="\${_p9k__i::=$_p9k__segment_index}\${_p9k__bg::=$bg_color}"
    p+='}+}'

    p+='}'

    _p9k_param $1 SHOW_ON_UPGLOB ''
    _p9k_cache_set "$p" $non_hermetic $_p9k__ret
  fi

  if [[ -n $_p9k__cache_val[3] ]]; then
    _p9k__has_upglob=1
    _p9k_upglob $_p9k__cache_val[3] && return
  fi

  _p9k__non_hermetic_expansion=$_p9k__cache_val[2]

  (( $5 )) && _p9k__ret=\"$7\" || _p9k_escape $7
  if [[ -z $6 ]]; then
    _p9k__prompt+="\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]"
  else
    _p9k__prompt+="\${\${:-\"$6\"}:+\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]}"
  fi
}

# The same as _p9k_left_prompt_segment above but for the right prompt.
_p9k_right_prompt_segment() {
  if ! _p9k_cache_get "$0" "$1" "$2" "$3" "$4" "$_p9k__segment_index"; then
    _p9k_color $1 BACKGROUND $2
    local bg_color=$_p9k__ret
    _p9k_background $bg_color
    local bg=$_p9k__ret
    local bg_=${_p9k__ret//\}/\\\}}

    _p9k_color $1 FOREGROUND $3
    local fg_color=$_p9k__ret
    _p9k_foreground $fg_color
    local fg=$_p9k__ret

    local style=%b$bg$fg
    local style_=${style//\}/\\\}}

    _p9k_get_icon $1 RIGHT_SEGMENT_SEPARATOR
    local sep=$_p9k__ret
    _p9k_escape $_p9k__ret
    local sep_=$_p9k__ret

    _p9k_get_icon $1 RIGHT_SUBSEGMENT_SEPARATOR
    local subsep=$_p9k__ret
    [[ $subsep == *%* ]] && subsep+=$style

    local icon_
    if [[ -n $4 ]]; then
      _p9k_get_icon $1 $4
      _p9k_escape $_p9k__ret
      icon_=$_p9k__ret
    fi

    _p9k_get_icon $1 RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL $sep
    local start_sep=$_p9k__ret
    [[ -n $start_sep ]] && start_sep="%b%k%F{$bg_color}$start_sep"

    _p9k_get_icon $1 RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL
    _p9k_escape $_p9k__ret
    local end_sep_=$_p9k__ret

    _p9k_get_icon $1 WHITESPACE_BETWEEN_RIGHT_SEGMENTS ' '
    local space=$_p9k__ret

    _p9k_get_icon $1 RIGHT_LEFT_WHITESPACE $space
    local left_space=$_p9k__ret
    [[ $left_space == *%* ]] && left_space+=$style

    _p9k_get_icon $1 RIGHT_RIGHT_WHITESPACE $space
    _p9k_escape $_p9k__ret
    local right_space_=$_p9k__ret
    [[ $right_space_ == *%* ]] && right_space_+=$style_

    local w='<_p9k__w>' s='<_p9k__s>'

    local -i non_hermetic=0

    # Segment separator logic:
    #
    #   if [[ $_p9k__bg == NONE ]]; then
    #     1
    #   elif (( joined )); then
    #     2
    #   elif [[ $_p9k__bg == (${bg_color}|${bg_color:-0}) ]]; then
    #     3
    #   else
    #     4
    #   fi

    local t=$(($#_p9k_t - __p9k_ksh_arrays))
    _p9k_t+=$start_sep$style$left_space           # 1
    _p9k_t+=$w$style                              # 2
    _p9k_t+=$w$style$subsep$left_space            # 3
    _p9k_t+=$w%F{$bg_color}$sep$style$left_space  # 4

    local join="_p9k__i>=$_p9k_right_join[$_p9k__segment_index]"
    _p9k_param $1 SELF_JOINED false
    if [[ $_p9k__ret == false ]]; then
      if (( _p9k__segment_index > $_p9k_right_join[$_p9k__segment_index] )); then
        join+="&&_p9k__i<$_p9k__segment_index"
      else
        join=
      fi
    fi

    local p=
    p+="\${_p9k__n::=}"
    p+="\${\${\${_p9k__bg:-0}:#NONE}:-\${_p9k__n::=$((t+1))}}"                                      # 1
    if [[ -n $join ]]; then
      p+="\${_p9k__n:=\${\${\$(($join)):#0}:+$((t+2))}}"                                            # 2
    fi
    if (( __p9k_sh_glob )); then
      p+="\${_p9k__n:=\${\${(M)\${:-x\$_p9k__bg}:#x${(b)bg_color}}:+$((t+3))}}"                     # 3
      p+="\${_p9k__n:=\${\${(M)\${:-x\$_p9k__bg}:#x${(b)bg_color:-0}}:+$((t+3))}}"                  # 3
    else
      p+="\${_p9k__n:=\${\${(M)\${:-x\$_p9k__bg}:#x(${(b)bg_color}|${(b)bg_color:-0})}:+$((t+3))}}" # 3
    fi
    p+="\${_p9k__n:=$((t+4))}"                                                                      # 4

    _p9k_param $1 VISUAL_IDENTIFIER_EXPANSION '${P9K_VISUAL_IDENTIFIER}'
    [[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1
    local icon_exp_=${_p9k__ret:+\"$_p9k__ret\"}

    _p9k_param $1 CONTENT_EXPANSION '${P9K_CONTENT}'
    [[ $_p9k__ret == (|*[^\\])'$('* ]] && non_hermetic=1
    local content_exp_=${_p9k__ret:+\"$_p9k__ret\"}

    if [[ ( $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ) ||
          ( $content_exp_ != '"${P9K_CONTENT}"' && $content_exp_ == *'$'* ) ]]; then
      p+="\${P9K_VISUAL_IDENTIFIER::=$icon_}"
    fi

    local -i has_icon=-1  # maybe

    if [[ $icon_exp_ != '"${P9K_VISUAL_IDENTIFIER}"' && $icon_exp_ == *'$'* ]]; then
      p+="\${_p9k__v::=$icon_exp_$style_}"
    else
      [[ $icon_exp_ == '"${P9K_VISUAL_IDENTIFIER}"' ]] && _p9k__ret=$icon_ || _p9k__ret=$icon_exp_
      if [[ -n $_p9k__ret ]]; then
        p+="\${_p9k__v::=$_p9k__ret"
        [[ $_p9k__ret == *%* ]] && p+=$style_
        p+="}"
        has_icon=1  # definitely yes
      else
        has_icon=0  # definitely no
      fi
    fi

    p+='${_p9k__c::='$content_exp_'}${_p9k__c::=${_p9k__c//'$'\r''}}'
    p+='${_p9k__e::=${${_p9k__'${_p9k__line_index}r${${1#prompt_}%%[A-Z0-9_]#}'+00}:-'
    if (( has_icon == -1 )); then
      p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}${${(%):-$_p9k__v%1(l.1.0)}[-1]}}'
    else
      p+='${${(%):-$_p9k__c%1(l.1.0)}[-1]}'$has_icon'}'
    fi

    p+='}}+}'

    p+='${${_p9k__e:#00}:+${_p9k_t[$_p9k__n]/'$w'/$_p9k__w}'

    _p9k_param $1 ICON_BEFORE_CONTENT ''
    if [[ $_p9k__ret != true ]]; then
      _p9k_param $1 PREFIX ''
      _p9k__ret=${(g::)_p9k__ret}
      _p9k_escape $_p9k__ret
      p+=$_p9k__ret
      [[ $_p9k__ret == *%* ]] && p+=$style_

      p+='${_p9k__c}'$style_

      if (( has_icon != 0 )); then
        local -i need_style=0
        _p9k_get_icon $1 RIGHT_MIDDLE_WHITESPACE ' '
        if [[ -n $_p9k__ret ]]; then
          _p9k_escape $_p9k__ret
          [[ $_p9k__ret == *%* ]] && need_style=1
          p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}'
        fi

        _p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
        _p9k_foreground $_p9k__ret
        _p9k__ret=%b$bg$_p9k__ret
        _p9k__ret=${_p9k__ret//\}/\\\}}
        [[ $_p9k__ret != $style_ || $need_style == 1 ]] && p+=$_p9k__ret
        p+='$_p9k__v'
      fi
    else
      _p9k_param $1 PREFIX ''
      _p9k__ret=${(g::)_p9k__ret}
      _p9k_escape $_p9k__ret
      p+=$_p9k__ret
      [[ $_p9k__ret == *%* ]] && local -i need_style=1 || local -i need_style=0

      if (( has_icon != 0 )); then
        _p9k_color $1 VISUAL_IDENTIFIER_COLOR $fg_color
        _p9k_foreground $_p9k__ret
        _p9k__ret=%b$bg$_p9k__ret
        _p9k__ret=${_p9k__ret//\}/\\\}}
        if [[ $_p9k__ret != $style_ ]]; then
          p+=$_p9k__ret'${_p9k__v}'$style_
        else
          (( need_style )) && p+=$style_
          p+='${_p9k__v}'
        fi

        _p9k_get_icon $1 RIGHT_MIDDLE_WHITESPACE ' '
        if [[ -n $_p9k__ret ]]; then
          _p9k_escape $_p9k__ret
          [[ _p9k__ret == *%* ]] && _p9k__ret+=$style_
          p+='${${(M)_p9k__e:#11}:+'$_p9k__ret'}'
        fi
      elif (( need_style )); then
        p+=$style_
      fi

      p+='${_p9k__c}'$style_
    fi

    _p9k_param $1 SUFFIX ''
    _p9k__ret=${(g::)_p9k__ret}
    _p9k_escape $_p9k__ret
    p+=$_p9k__ret

    p+='${${:-'

    if [[ -n $fg_color && $fg_color == $bg_color ]]; then
      if [[ $fg_color == $_p9k_color1 ]]; then
        _p9k_foreground $_p9k_color2
      else
        _p9k_foreground $_p9k_color1
      fi
    else
      _p9k__ret=$fg
    fi
    _p9k__ret=${_p9k__ret//\}/\\\}}
    p+="\${_p9k__w::=${right_space_:+$style_}$right_space_%b$bg_$_p9k__ret}"

    p+='${_p9k__sss::='
    p+=$style_$right_space_
    [[ $right_space_ == *%* ]] && p+=$style_
    if [[ -n $end_sep_ ]]; then
      p+="%k%F{$bg_color\}$end_sep_$style_"
    fi
    p+='}'

    p+="\${_p9k__i::=$_p9k__segment_index}\${_p9k__bg::=$bg_color}"

    p+='}+}'
    p+='}'

    _p9k_param $1 SHOW_ON_UPGLOB ''
    _p9k_cache_set "$p" $non_hermetic $_p9k__ret
  fi

  if [[ -n $_p9k__cache_val[3] ]]; then
    _p9k__has_upglob=1
    _p9k_upglob $_p9k__cache_val[3] && return
  fi

  _p9k__non_hermetic_expansion=$_p9k__cache_val[2]

  (( $5 )) && _p9k__ret=\"$7\" || _p9k_escape $7
  if [[ -z $6 ]]; then
    _p9k__prompt+="\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]"
  else
    _p9k__prompt+="\${\${:-\"$6\"}:+\${\${:-\${P9K_CONTENT::=$_p9k__ret}$_p9k__cache_val[1]}"
  fi
}

function _p9k_prompt_segment() { "_p9k_${_p9k__prompt_side}_prompt_segment" "$@" }
function p9k_prompt_segment() { p10k segment "$@" }

function _p9k_python_version() {
  case $commands[python] in
    "")
      return 1
    ;;
    ${PYENV_ROOT:-~/.pyenv}/shims/python)
      local P9K_PYENV_PYTHON_VERSION _p9k__pyenv_version
      local -i _POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=1 _POWERLEVEL9K_PYENV_SHOW_SYSTEM=1
      local _POWERLEVEL9K_PYENV_SOURCES=(shell local global)
      if _p9k_pyenv_compute && [[ $P9K_PYENV_PYTHON_VERSION == ([[:digit:].]##)* ]]; then
        _p9k__ret=$P9K_PYENV_PYTHON_VERSION
        return 0
      fi
    ;&  # fall through
    *)
      _p9k_cached_cmd 1 '' python --version || return
      [[ $_p9k__ret == (#b)Python\ ([[:digit:].]##)* ]] && _p9k__ret=$match[1]
    ;;
  esac
}

################################################################
# Prompt Segment Definitions
################################################################

################################################################
# Anaconda Environment
prompt_anaconda() {
  local msg
  if _p9k_python_version; then
    P9K_ANACONDA_PYTHON_VERSION=$_p9k__ret
    if (( _POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION )); then
      msg="${P9K_ANACONDA_PYTHON_VERSION//\%/%%} "
    fi
  else
    unset P9K_ANACONDA_PYTHON_VERSION
  fi
  local p=${CONDA_PREFIX:-$CONDA_ENV_PATH}
  msg+="$_POWERLEVEL9K_ANACONDA_LEFT_DELIMITER${${p:t}//\%/%%}$_POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER"
  _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '' "$msg"
}

_p9k_prompt_anaconda_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${CONDA_PREFIX:-$CONDA_ENV_PATH}'
}

# Populates array `reply` with "$#profile:$profile:$region" where $profile and $region
# come from the AWS config (~/.aws/config).
function _p9k_parse_aws_config() {
  local cfg=$1
  typeset -ga reply=()
  [[ -f $cfg && -r $cfg ]] || return

  local -a lines
  lines=(${(f)"$(<$cfg)"}) || return

  local line profile
  local -a match mbegin mend
  for line in $lines; do
    if [[ $line == [[:space:]]#'[default]'[[:space:]]#(|'#'*) ]]; then
      # example: [default]
      profile=default
    elif [[ $line == (#b)'[profile'[[:space:]]##([^[:space:]]|[^[:space:]]*[^[:space:]])[[:space:]]#']'[[:space:]]#(|'#'*) ]]; then
      # example: [profile prod]
      profile=${(Q)match[1]}
    elif [[ $line == (#b)[[:space:]]#region[[:space:]]#=[[:space:]]#([^[:space:]]|[^[:space:]]*[^[:space:]])[[:space:]]# ]]; then
      # example: region = eu-west-1
      if [[ -n $profile ]]; then
        reply+=$#profile:$profile:$match[1]
        profile=
      fi
    fi
  done
}

################################################################
# AWS Profile
prompt_aws() {
  typeset -g P9K_AWS_PROFILE="${AWS_VAULT:-${AWSUME_PROFILE:-${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}}}"
  local pat class state
  for pat class in "${_POWERLEVEL9K_AWS_CLASSES[@]}"; do
    if [[ $P9K_AWS_PROFILE == ${~pat} ]]; then
      [[ -n $class ]] && state=_${${(U)class}//İ/I}
      break
    fi
  done

  if [[ -n ${AWS_REGION:-$AWS_DEFAULT_REGION} ]]; then
    typeset -g P9K_AWS_REGION=${AWS_REGION:-$AWS_DEFAULT_REGION}
  else
    local cfg=${AWS_CONFIG_FILE:-~/.aws/config}
    if ! _p9k_cache_stat_get $0 $cfg; then
      local -a reply
      _p9k_parse_aws_config $cfg
      _p9k_cache_stat_set $reply
    fi
    local prefix=$#P9K_AWS_PROFILE:$P9K_AWS_PROFILE:
    local kv=$_p9k__cache_val[(r)${(b)prefix}*]
    typeset -g P9K_AWS_REGION=${kv#$prefix}
  fi

  _p9k_prompt_segment "$0$state" red white 'AWS_ICON' 0 '' "${P9K_AWS_PROFILE//\%/%%}"
}

_p9k_prompt_aws_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${AWS_VAULT:-${AWSUME_PROFILE:-${AWS_PROFILE:-$AWS_DEFAULT_PROFILE}}}'
}

################################################################
# Current Elastic Beanstalk environment
prompt_aws_eb_env() {
  _p9k_upglob .elasticbeanstalk && return
  local dir=$_p9k__parent_dirs[$?]

  if ! _p9k_cache_stat_get $0 $dir/.elasticbeanstalk/config.yml; then
    local env
    env="$(command eb list 2>/dev/null)" || env=
    env="${${(@M)${(@f)env}:#\* *}#\* }"
    _p9k_cache_stat_set "$env"
  fi
  [[ -n $_p9k__cache_val[1] ]] || return
  _p9k_prompt_segment "$0" black green 'AWS_EB_ICON' 0 '' "${_p9k__cache_val[1]//\%/%%}"
}

_p9k_prompt_aws_eb_env_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[eb]'
}

################################################################
# Segment to indicate background jobs with an icon.
prompt_background_jobs() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  local msg
  if (( _POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE )); then
    if (( _POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS )); then
      msg='${(%):-%j}'
    else
      msg='${${(%):-%j}:#1}'
    fi
  fi
  _p9k_prompt_segment $0 "$_p9k_color1" cyan BACKGROUND_JOBS_ICON 1 '${${(%):-%j}:#0}' "$msg"
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

################################################################
# Segment that indicates usage level of current partition.
prompt_disk_usage() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0_CRITICAL red    white        DISK_ICON 1 '$_p9k__disk_usage_critical' '$_p9k__disk_usage_pct%%'
  _p9k_prompt_segment $0_WARNING  yellow $_p9k_color1 DISK_ICON 1 '$_p9k__disk_usage_warning'  '$_p9k__disk_usage_pct%%'
  if (( ! _POWERLEVEL9K_DISK_USAGE_ONLY_WARNING )); then
    _p9k_prompt_segment $0_NORMAL $_p9k_color1 yellow   DISK_ICON 1 '$_p9k__disk_usage_normal'   '$_p9k__disk_usage_pct%%'
  fi
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_disk_usage_init() {
  typeset -g _p9k__disk_usage_pct=
  typeset -g _p9k__disk_usage_normal=
  typeset -g _p9k__disk_usage_warning=
  typeset -g _p9k__disk_usage_critical=
  _p9k__async_segments_compute+='_p9k_worker_invoke disk_usage "_p9k_prompt_disk_usage_compute ${(q)_p9k__cwd_a}"'
}

_p9k_prompt_disk_usage_compute() {
  (( $+commands[df] )) || return
  _p9k_worker_async "_p9k_prompt_disk_usage_async ${(q)1}" _p9k_prompt_disk_usage_sync
}

_p9k_prompt_disk_usage_async() {
  local pct=${${=${(f)"$(df -P $1 2>/dev/null)"}[2]}[5]%%%}
  [[ $pct == <0-100> && $pct != $_p9k__disk_usage_pct ]] || return
  _p9k__disk_usage_pct=$pct
  _p9k__disk_usage_normal=
  _p9k__disk_usage_warning=
  _p9k__disk_usage_critical=
  if (( _p9k__disk_usage_pct >= _POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL )); then
    _p9k__disk_usage_critical=1
  elif (( _p9k__disk_usage_pct >= _POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL )); then
    _p9k__disk_usage_warning=1
  elif (( ! _POWERLEVEL9K_DISK_USAGE_ONLY_WARNING )); then
    _p9k__disk_usage_normal=1
  fi
  _p9k_print_params          \
    _p9k__disk_usage_pct     \
    _p9k__disk_usage_normal  \
    _p9k__disk_usage_warning \
    _p9k__disk_usage_critical
  echo -E - 'reset=1'
}

_p9k_prompt_disk_usage_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

function _p9k_read_file() {
  _p9k__ret=''
  [[ -n $1 ]] && IFS='' read -r _p9k__ret <$1
  [[ -n $_p9k__ret ]]
}

function _p9k_fvm_old() {
  _p9k_upglob fvm && return 1
  local fvm=$_p9k__parent_dirs[$?]/fvm
  if [[ -L $fvm ]]; then
    if [[ ${fvm:A} == (#b)*/versions/([^/]##)/bin/flutter ]]; then
      _p9k_prompt_segment prompt_fvm blue $_p9k_color1 FLUTTER_ICON 0 '' ${match[1]//\%/%%}
      return 0
    fi
  fi
  return 1
}

function _p9k_fvm_new() {
  _p9k_upglob .fvm && return 1
  local sdk=$_p9k__parent_dirs[$?]/.fvm/flutter_sdk
  if [[ -L $sdk ]]; then
    if [[ ${sdk:A} == (#b)*/versions/([^/]##) ]]; then
      _p9k_prompt_segment prompt_fvm blue $_p9k_color1 FLUTTER_ICON 0 '' ${match[1]//\%/%%}
      return 0
    fi
  fi
  return 1
}

prompt_fvm() {
  _p9k_fvm_new || _p9k_fvm_old
}

_p9k_prompt_fvm_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[fvm]'
}

################################################################
# Segment that displays the battery status in levels and colors
prompt_battery() {
  [[ $_p9k_os == (Linux|Android) ]] && _p9k_prompt_battery_set_args
  (( $#_p9k__battery_args )) && _p9k_prompt_segment "${_p9k__battery_args[@]}"
}

_p9k_prompt_battery_init() {
  typeset -ga _p9k__battery_args=()
  if [[ $_p9k_os == OSX && $+commands[pmset] == 1 ]]; then
    _p9k__async_segments_compute+='_p9k_worker_invoke battery _p9k_prompt_battery_compute'
    return
  fi
  if [[ $_p9k_os != (Linux|Android) ||
        -z /sys/class/power_supply/(CMB*|BAT*|*battery)/(energy_full|charge_full|charge_counter)(#qN) ]]; then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
  fi
}

_p9k_prompt_battery_compute() {
  _p9k_worker_async _p9k_prompt_battery_async _p9k_prompt_battery_sync
}

_p9k_prompt_battery_async() {
  local prev="${(pj:\0:)_p9k__battery_args}"
  _p9k_prompt_battery_set_args
  [[ "${(pj:\0:)_p9k__battery_args}" == $prev ]] && return 1
  _p9k_print_params _p9k__battery_args
  echo -E - 'reset=2'
}

_p9k_prompt_battery_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

_p9k_prompt_battery_set_args() {
  _p9k__battery_args=()

  local state remain
  local -i bat_percent

  case $_p9k_os in
    OSX)
      (( $+commands[pmset] )) || return
      local raw_data=${${(Af)"$(pmset -g batt 2>/dev/null)"}[2]}
      [[ $raw_data == *InternalBattery* ]] || return
      remain=${${(s: :)${${(s:; :)raw_data}[3]}}[1]}
      [[ $remain == *no* ]] && remain="..."
      [[ $raw_data =~ '([0-9]+)%' ]] && bat_percent=$match[1]

      case "${${(s:; :)raw_data}[2]}" in
        'charging'|'finishing charge'|'AC attached')
          if (( bat_percent == 100 )); then
            state=CHARGED
            remain=''
          else
            state=CHARGING
          fi
        ;;
        'discharging')
          (( bat_percent < _POWERLEVEL9K_BATTERY_LOW_THRESHOLD )) && state=LOW || state=DISCONNECTED
        ;;
        *)
          state=CHARGED
          remain=''
        ;;
      esac
    ;;

    Linux|Android)
      # See https://sourceforge.net/projects/acpiclient.
      local -a bats=( /sys/class/power_supply/(CMB*|BAT*|*battery)/(FN) )
      (( $#bats )) || return

      local -i energy_now energy_full power_now
      local -i is_full=1 is_calculating is_charching
      local dir
      for dir in $bats; do
        local -i pow=0 full=0
        if _p9k_read_file $dir/(energy_full|charge_full|charge_counter)(N); then
          (( energy_full += ${full::=_p9k__ret} ))
        fi
        if _p9k_read_file $dir/(power|current)_now(N) && (( $#_p9k__ret < 9 )); then
          (( power_now += ${pow::=$_p9k__ret} ))
        fi
        if _p9k_read_file $dir/capacity(N); then
          (( energy_now += _p9k__ret * full / 100. + 0.5 ))
        elif _p9k_read_file $dir/(energy|charge)_now(N); then
          (( energy_now += _p9k__ret ))
        fi
        _p9k_read_file $dir/status(N) && local bat_status=$_p9k__ret || continue
        [[ $bat_status != Full                                ]] && is_full=0
        [[ $bat_status == Charging                            ]] && is_charching=1
        [[ $bat_status == (Charging|Discharging) && $pow == 0 ]] && is_calculating=1
      done

      (( energy_full )) || return

      bat_percent=$(( 100. * energy_now / energy_full + 0.5 ))
      (( bat_percent > 100 )) && bat_percent=100

      if (( is_full || (bat_percent == 100 && is_charching) )); then
        state=CHARGED
      else
        if (( is_charching )); then
          state=CHARGING
        elif (( bat_percent < _POWERLEVEL9K_BATTERY_LOW_THRESHOLD )); then
          state=LOW
        else
          state=DISCONNECTED
        fi

        if (( power_now > 0 )); then
          (( is_charching )) && local -i e=$((energy_full - energy_now)) || local -i e=energy_now
          local -i minutes=$(( 60 * e / power_now ))
          (( minutes > 0 )) && remain=$((minutes/60)):${(l#2##0#)$((minutes%60))}
        elif (( is_calculating )); then
          remain="..."
        fi
      fi
    ;;

    *)
      return 0
    ;;
  esac

  (( bat_percent >= _POWERLEVEL9K_BATTERY_${state}_HIDE_ABOVE_THRESHOLD )) && return

  local msg="$bat_percent%%"
  [[ $_POWERLEVEL9K_BATTERY_VERBOSE == 1 && -n $remain ]] && msg+=" ($remain)"

  local icon=BATTERY_ICON
  local var=_POWERLEVEL9K_BATTERY_${state}_STAGES
  local -i idx="${#${(@P)var}}"
  if (( idx )); then
    (( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1))
    icon=$'\1'"${${(@P)var}[idx]}"
  fi

  local bg=$_p9k_color1
  local var=_POWERLEVEL9K_BATTERY_${state}_LEVEL_BACKGROUND
  local -i idx="${#${(@P)var}}"
  if (( idx )); then
    (( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1))
    bg="${${(@P)var}[idx]}"
  fi

  local fg=$_p9k_battery_states[$state]
  local var=_POWERLEVEL9K_BATTERY_${state}_LEVEL_FOREGROUND
  local -i idx="${#${(@P)var}}"
  if (( idx )); then
    (( bat_percent < 100 )) && idx=$((bat_percent * idx / 100 + 1))
    fg="${${(@P)var}[idx]}"
  fi

  _p9k__battery_args=(prompt_battery_$state "$bg" "$fg" $icon 0 '' $msg)
}

################################################################
# Public IP segment
prompt_public_ip() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  local ip='${_p9k__public_ip:-$_POWERLEVEL9K_PUBLIC_IP_NONE}'
  if [[ -n $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ]]; then
    _p9k_prompt_segment "$0" "$_p9k_color1" "$_p9k_color2" PUBLIC_IP_ICON 1 '${_p9k__public_ip_not_vpn:+'$ip'}' $ip
    _p9k_prompt_segment "$0" "$_p9k_color1" "$_p9k_color2" VPN_ICON 1 '${_p9k__public_ip_vpn:+'$ip'}' $ip
  else
    _p9k_prompt_segment "$0" "$_p9k_color1" "$_p9k_color2" PUBLIC_IP_ICON 1 $ip $ip
  fi
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_public_ip_init() {
  typeset -g _p9k__public_ip=
  typeset -gF _p9k__public_ip_next_time=0
  _p9k__async_segments_compute+='_p9k_worker_invoke public_ip _p9k_prompt_public_ip_compute'
}

_p9k_prompt_public_ip_compute() {
  (( EPOCHREALTIME >= _p9k__public_ip_next_time )) || return
  _p9k_worker_async _p9k_prompt_public_ip_async _p9k_prompt_public_ip_sync
}

_p9k_prompt_public_ip_async() {
  local ip method
  local -F start=EPOCHREALTIME
  local -F next='start + 5'
  for method in $_POWERLEVEL9K_PUBLIC_IP_METHODS $_POWERLEVEL9K_PUBLIC_IP_METHODS; do
    case $method in
      dig)
        if (( $+commands[dig] )); then
          ip="$(dig +tries=1 +short -4 A myip.opendns.com @resolver1.opendns.com 2>/dev/null)"
          [[ $ip == ';'* ]] && ip=
          if [[ -z $ip ]]; then
            ip="$(dig +tries=1 +short -6 AAAA myip.opendns.com @resolver1.opendns.com 2>/dev/null)"
            [[ $ip == ';'* ]] && ip=
          fi
        fi
      ;;
      curl)
        if (( $+commands[curl] )); then
          ip="$(curl --max-time 5 -w '\n' "$_POWERLEVEL9K_PUBLIC_IP_HOST" 2>/dev/null)"
        fi
      ;;
      wget)
        if (( $+commands[wget] )); then
          ip="$(wget -T 5 -qO- "$_POWERLEVEL9K_PUBLIC_IP_HOST" 2>/dev/null)"
        fi
      ;;
    esac
    [[ $ip =~ '^[0-9a-f.:]+$' ]] || ip=''
    if [[ -n $ip ]]; then
      next=$((start + _POWERLEVEL9K_PUBLIC_IP_TIMEOUT))
      break
    fi
  done
  _p9k__public_ip_next_time=$next
  _p9k_print_params _p9k__public_ip_next_time
  [[ $_p9k__public_ip == $ip ]] && return
  _p9k__public_ip=$ip
  _p9k_print_params _p9k__public_ip
  echo -E - 'reset=1'
}

_p9k_prompt_public_ip_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

################################################################
# Context: user@hostname (who am I and where am I)
prompt_context() {
  local -i len=$#_p9k__prompt _p9k__has_upglob

  local content
  if [[ $_POWERLEVEL9K_ALWAYS_SHOW_CONTEXT == 0 && -n $DEFAULT_USER && $P9K_SSH == 0 ]]; then
    local user="${(%):-%n}"
    if [[ $user == $DEFAULT_USER ]]; then
      content="${user//\%/%%}"
    fi
  fi

  local state
  if (( P9K_SSH )); then
    if [[ -n "$SUDO_COMMAND" ]]; then
      state="REMOTE_SUDO"
    else
      state="REMOTE"
    fi
  elif [[ -n "$SUDO_COMMAND" ]]; then
    state="SUDO"
  else
    state="DEFAULT"
  fi

  local cond
  for state cond in $state '${${(%):-%#}:#\#}' ROOT '${${(%):-%#}:#\%}'; do
    local text=$content
    if [[ -z $text ]]; then
      local var=_POWERLEVEL9K_CONTEXT_${state}_TEMPLATE
      if (( $+parameters[$var] )); then
        text=${(P)var}
        text=${(g::)text}
      else
        text=$_POWERLEVEL9K_CONTEXT_TEMPLATE
      fi
    fi
    _p9k_prompt_segment "$0_$state" "$_p9k_color1" yellow '' 0 "$cond" "$text"
  done

  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_context() {
  if [[ $_POWERLEVEL9K_ALWAYS_SHOW_CONTEXT == 0 && -n $DEFAULT_USER && $P9K_SSH == 0 ]]; then
    if [[ ${(%):-%n} == $DEFAULT_USER ]]; then
      if (( ! _POWERLEVEL9K_ALWAYS_SHOW_USER )); then
        return
      fi
    fi
  fi
  prompt_context
}

_p9k_prompt_context_init() {
  if [[ $_POWERLEVEL9K_ALWAYS_SHOW_CONTEXT == 0 && -n $DEFAULT_USER && $P9K_SSH == 0 ]]; then
    if [[ ${(%):-%n} == $DEFAULT_USER ]]; then
      if (( ! _POWERLEVEL9K_ALWAYS_SHOW_USER )); then
        typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
      fi
    fi
  fi
}

################################################################
# User: user (who am I)
prompt_user() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "${0}_ROOT" "${_p9k_color1}" yellow ROOT_ICON 0 '${${(%):-%#}:#\%}' "$_POWERLEVEL9K_USER_TEMPLATE"
  if [[ -n "$SUDO_COMMAND" ]]; then
    _p9k_prompt_segment "${0}_SUDO" "${_p9k_color1}" yellow SUDO_ICON 0 '${${(%):-%#}:#\#}' "$_POWERLEVEL9K_USER_TEMPLATE"
  else
    _p9k_prompt_segment "${0}_DEFAULT" "${_p9k_color1}" yellow USER_ICON 0 '${${(%):-%#}:#\#}' "%n"
  fi
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_user() {
  if [[ $_POWERLEVEL9K_ALWAYS_SHOW_USER == 0 && "${(%):-%n}" == $DEFAULT_USER ]]; then
    return
  fi
  prompt_user
}

_p9k_prompt_user_init() {
  if [[ $_POWERLEVEL9K_ALWAYS_SHOW_USER == 0 && "${(%):-%n}" == $DEFAULT_USER ]]; then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
  fi
}

################################################################
# Host: machine (where am I)
prompt_host() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  if (( P9K_SSH )); then
    _p9k_prompt_segment "$0_REMOTE" "${_p9k_color1}" yellow SSH_ICON 0 '' "$_POWERLEVEL9K_HOST_TEMPLATE"
  else
    _p9k_prompt_segment "$0_LOCAL" "${_p9k_color1}" yellow HOST_ICON 0 '' "$_POWERLEVEL9K_HOST_TEMPLATE"
  fi
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_host() { prompt_host; }

################################################################
# Toolbox: https://github.com/containers/toolbox
function prompt_toolbox() {
  _p9k_prompt_segment $0 $_p9k_color1 yellow TOOLBOX_ICON 0 '' $P9K_TOOLBOX_NAME
}

_p9k_prompt_toolbox_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$P9K_TOOLBOX_NAME'
}

function instant_prompt_toolbox() {
  _p9k_prompt_segment prompt_toolbox $_p9k_color1 yellow TOOLBOX_ICON 1 '$P9K_TOOLBOX_NAME' '$P9K_TOOLBOX_NAME'
}

################################################################
# The 'custom` prompt provides a way for users to invoke commands and display
# the output in a segment.
_p9k_custom_prompt() {
  local segment_name=${1:u}
  local command=_POWERLEVEL9K_CUSTOM_${segment_name}
  command=${(P)command}
  local parts=("${(@z)command}")
  local cmd="${(Q)parts[1]}"
  (( $+functions[$cmd] || $+commands[$cmd] )) || return
  local content="$(eval $command)"
  [[ -n $content ]] || return
  _p9k_prompt_segment "prompt_custom_$1" $_p9k_color2 $_p9k_color1 "CUSTOM_${segment_name}_ICON" 0 '' "$content"
}

################################################################
# Display the duration the command needed to run.
prompt_command_execution_time() {
  (( $+P9K_COMMAND_DURATION_SECONDS )) || return
  (( P9K_COMMAND_DURATION_SECONDS >= _POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD )) || return

  if (( P9K_COMMAND_DURATION_SECONDS < 60 )); then
    if (( !_POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION )); then
      local -i sec=$((P9K_COMMAND_DURATION_SECONDS + 0.5))
    else
      local -F $_POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION sec=P9K_COMMAND_DURATION_SECONDS
    fi
    local text=${sec}s
  else
    local -i d=$((P9K_COMMAND_DURATION_SECONDS + 0.5))
    if [[ $_POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT == "H:M:S" ]]; then
      local text=${(l.2..0.)$((d % 60))}
      if (( d >= 60 )); then
        text=${(l.2..0.)$((d / 60 % 60))}:$text
        if (( d >= 36000 )); then
          text=$((d / 3600)):$text
        elif (( d >= 3600 )); then
          text=0$((d / 3600)):$text
        fi
      fi
    else
      local text="$((d % 60))s"
      if (( d >= 60 )); then
        text="$((d / 60 % 60))m $text"
        if (( d >= 3600 )); then
          text="$((d / 3600 % 24))h $text"
          if (( d >= 86400 )); then
            text="$((d / 86400))d $text"
          fi
        fi
      fi
    fi
  fi

  _p9k_prompt_segment "$0" "red" "yellow1" 'EXECUTION_TIME_ICON' 0 '' $text
}

function _p9k_shorten_delim_len() {
  local def=$1
  _p9k__ret=${_POWERLEVEL9K_SHORTEN_DELIMITER_LENGTH:--1}
  (( _p9k__ret >= 0 )) || _p9k_prompt_length $1
}

# Percents are duplicated because this function is currently used only
# where the result is going to be percent-expanded.
function _p9k_url_escape() {
  if [[ $1 == [a-zA-Z0-9"/:_.-!'()~ "]# ]]; then
    _p9k__ret=${1// /%%20}
  else
    local c
    _p9k__ret=
    for c in ${(s::)1}; do
      [[ $c == [a-zA-Z0-9"/:_.-!'()~"] ]] || printf -v c '%%%%%02X' $(( #c ))
      _p9k__ret+=$c
    done
  fi
}

################################################################
# Dir: current working directory
prompt_dir() {
  if (( _POWERLEVEL9K_DIR_PATH_ABSOLUTE )); then
    local p=${(V)_p9k__cwd}
    local -a parts=("${(s:/:)p}")
  elif [[ -o auto_name_dirs ]]; then
    local p=${(V)${_p9k__cwd/#(#b)$HOME(|\/*)/'~'$match[1]}}
    local -a parts=("${(s:/:)p}")
  else
    local p=${(%):-%~}
    if [[ $p == '~['* ]]; then
      # If "${(%):-%~}" expands to "~[a]/]/b", is the first component "~[a]" or "~[a]/]"?
      # One would expect "${(%):-%-1~}" to give the right answer but alas it always simply
      # gives the segment before the first slash, which would be "~[a]" in this case. Worse,
      # for "~[a/b]" it'll give the nonsensical "~[a". To solve this problem we have to
      # repeat what "${(%):-%~}" does and hope that it produces the same result.
      local func=''
      local -a parts=()
      for func in zsh_directory_name $zsh_directory_name_functions; do
        local reply=()
        if (( $+functions[$func] )) && $func d $_p9k__cwd && [[ $p == '~['${(V)reply[1]}']'* ]]; then
          parts+='~['${(V)reply[1]}']'
          break
        fi
      done
      if (( $#parts )); then
        parts+=(${(s:/:)${p#$parts[1]}})
      else
        p=${(V)_p9k__cwd}
        parts=("${(s:/:)p}")
      fi
    else
      local -a parts=("${(s:/:)p}")
    fi
  fi

  local -i fake_first=0 expand=0 shortenlen=${_POWERLEVEL9K_SHORTEN_DIR_LENGTH:--1}

  if (( $+_POWERLEVEL9K_SHORTEN_DELIMITER )); then
    local delim=$_POWERLEVEL9K_SHORTEN_DELIMITER
  else
    if [[ $langinfo[CODESET] == (utf|UTF)(-|)8 ]]; then
      local delim=$'\u2026'
    else
      local delim='..'
    fi
  fi

  case $_POWERLEVEL9K_SHORTEN_STRATEGY in
    truncate_absolute|truncate_absolute_chars)
      if (( shortenlen > 0 && $#p > shortenlen )); then
        _p9k_shorten_delim_len $delim
        if (( $#p > shortenlen + $_p9k__ret )); then
          local -i n=shortenlen
          local -i i=$#parts
          while true; do
            local dir=$parts[i]
            local -i len=$(( $#dir + (i > 1) ))
            if (( len <= n )); then
              (( n -= len ))
              (( --i ))
            else
              parts[i]=$'\1'$dir[-n,-1]
              parts[1,i-1]=()
              break
            fi
          done
        fi
      fi
    ;;
    truncate_with_package_name|truncate_middle|truncate_from_right)
      () {
        [[ $_POWERLEVEL9K_SHORTEN_STRATEGY == truncate_with_package_name &&
           $+commands[jq] == 1 && $#_POWERLEVEL9K_DIR_PACKAGE_FILES > 0 ]] || return
        local pats="(${(j:|:)_POWERLEVEL9K_DIR_PACKAGE_FILES})"
        local -i i=$#parts
        local dir=$_p9k__cwd
        for (( ; i > 0; --i )); do
          local markers=($dir/${~pats}(N))
          if (( $#markers )); then
            local pat= pkg_file=
            for pat in $_POWERLEVEL9K_DIR_PACKAGE_FILES; do
              for pkg_file in $markers; do
                [[ $pkg_file == $dir/${~pat} ]] || continue
                if ! _p9k_cache_stat_get $0_pkg $pkg_file; then
                  local pkg_name=''
                  pkg_name="$(jq -j '.name | select(. != null)' <$pkg_file 2>/dev/null)" || pkg_name=''
                  _p9k_cache_stat_set "$pkg_name"
                fi
                [[ -n $_p9k__cache_val[1] ]] || continue
                parts[1,i]=($_p9k__cache_val[1])
                fake_first=1
                return 0
              done
            done
          fi
          dir=${dir:h}
        done
      }
      if (( shortenlen > 0 )); then
        _p9k_shorten_delim_len $delim
        local -i d=_p9k__ret pref=shortenlen suf=0 i=2
        [[ $_POWERLEVEL9K_SHORTEN_STRATEGY == truncate_middle ]] && suf=pref
        for (( ; i < $#parts; ++i )); do
          local dir=$parts[i]
          if (( $#dir > pref + suf + d )); then
            dir[pref+1,-suf-1]=$'\1'
            parts[i]=$dir
          fi
        done
      fi
    ;;
    truncate_to_last)
      shortenlen=${_POWERLEVEL9K_SHORTEN_DIR_LENGTH:-1}
      (( shortenlen > 0 )) || shortenlen=1
      local -i i='shortenlen+1'
      if [[ $#parts -gt i || $p[1] != / && $#parts -gt shortenlen ]]; then
        fake_first=1
        parts[1,-i]=()
      fi
    ;;
    truncate_to_first_and_last)
      if (( shortenlen > 0 )); then
        local -i i=$(( shortenlen + 1 ))
        [[ $p == /* ]] && (( ++i ))
        for (( ; i <= $#parts - shortenlen; ++i )); do
          parts[i]=$'\1'
        done
      fi
    ;;
    truncate_to_unique)
      expand=1
      delim=${_POWERLEVEL9K_SHORTEN_DELIMITER-'*'}
      shortenlen=${_POWERLEVEL9K_SHORTEN_DIR_LENGTH:-1}
      (( shortenlen >= 0 )) || shortenlen=1
      local rp=${(g:oce:)p}
      local rparts=("${(@s:/:)rp}")

      local -i i=2 e=$(($#parts - shortenlen))
      if [[ -n $_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER ]]; then
        (( e += shortenlen ))
        local orig=("$parts[2]" "${(@)parts[$((shortenlen > $#parts ? -$#parts : -shortenlen)),-1]}")
      elif [[ $p[1] == / ]]; then
        (( ++i ))
      fi
      if (( i <= e )); then
        local mtimes=(${(Oa)_p9k__parent_mtimes:$(($#parts-e)):$((e-i+1))})
        local key="${(pj.:.)mtimes}"
      else
        local key=
      fi
      if ! _p9k_cache_ephemeral_get $0 $e $i $_p9k__cwd || [[ $key != $_p9k__cache_val[1] ]]; then
        local rtail=${(j./.)rparts[i,-1]}
        local parent=$_p9k__cwd[1,-2-$#rtail]
        _p9k_prompt_length $delim
        local -i real_delim_len=_p9k__ret
        [[ -n $parts[i-1] ]] && parts[i-1]="\${(Q)\${:-${(qqq)${(q)parts[i-1]}}}}"$'\2'
        local -i d=${_POWERLEVEL9K_SHORTEN_DELIMITER_LENGTH:--1}
        (( d >= 0 )) || d=real_delim_len
        local -i m=1
        for (( ; i <= e; ++i, ++m )); do
          local sub=$parts[i]
          local rsub=$rparts[i]
          local dir=$parent/$rsub mtime=$mtimes[m]
          local pair=$_p9k__dir_stat_cache[$dir]
          if [[ $pair == ${mtime:-x}:* ]]; then
            parts[i]=${pair#*:}
          else
            [[ $sub != *["~!#\`\$^&*()\\\"'<>?{}[]"]* ]]
            local -i q=$?
            if [[ -n $_POWERLEVEL9K_SHORTEN_FOLDER_MARKER &&
                  -n $dir/${~_POWERLEVEL9K_SHORTEN_FOLDER_MARKER}(#qN) ]]; then
              (( q )) && parts[i]="\${(Q)\${:-${(qqq)${(q)sub}}}}"
              parts[i]+=$'\2'
            else
              local -i j=$rsub[(i)[^.]]
              for (( ; j + d < $#rsub; ++j )); do
                local -a matching=($parent/$rsub[1,j]*/(N))
                (( $#matching == 1 )) && break
              done
              local -i saved=$((${(m)#${(V)${rsub:$j}}} - d))
              if (( saved > 0 )); then
                if (( q )); then
                  parts[i]='${${${_p9k__d:#-*}:+${(Q)${:-'${(qqq)${(q)sub}}'}}}:-${(Q)${:-'
                  parts[i]+=$'\3'${(qqq)${(q)${(V)${rsub[1,j]}}}}$'}}\1\3''${$((_p9k__d+='$saved'))+}}'
                else
                  parts[i]='${${${_p9k__d:#-*}:+'$sub$'}:-\3'${(V)${rsub[1,j]}}$'\1\3''${$((_p9k__d+='$saved'))+}}'
                fi
              else
                (( q )) && parts[i]="\${(Q)\${:-${(qqq)${(q)sub}}}}"
              fi
            fi
            [[ -n $mtime ]] && _p9k__dir_stat_cache[$dir]="$mtime:$parts[i]"
          fi
          parent+=/$rsub
        done
        if [[ -n $_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER ]]; then
          local _2=$'\2'
          if [[ $_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER == last* ]]; then
            (( e = ${parts[(I)*$_2]} + ${_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER#*:} ))
          else
            (( e = ${parts[(ib:2:)*$_2]} + ${_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER#*:} ))
          fi
          if (( e > 1 && e <= $#parts )); then
            parts[1,e-1]=()
            fake_first=1
          elif [[ $p == /?* ]]; then
            parts[2]="\${(Q)\${:-${(qqq)${(q)orig[1]}}}}"$'\2'
          fi
          for ((i = $#parts < shortenlen ? $#parts : shortenlen; i > 0; --i)); do
            [[ $#parts[-i] == *$'\2' ]] && continue
            if [[ $orig[-i] == *["~!#\`\$^&*()\\\"'<>?{}[]"]* ]]; then
              parts[-i]='${(Q)${:-'${(qqq)${(q)orig[-i]}}'}}'$'\2'
            else
              parts[-i]=${orig[-i]}$'\2'
            fi
          done
        else
          for ((; i <= $#parts; ++i)); do
            [[ $parts[i] == *["~!#\`\$^&*()\\\"'<>?{}[]"]* ]] && parts[i]='${(Q)${:-'${(qqq)${(q)parts[i]}}'}}'
            parts[i]+=$'\2'
          done
        fi
        _p9k_cache_ephemeral_set "$key" "${parts[@]}"
      fi
      parts=("${(@)_p9k__cache_val[2,-1]}")
    ;;
    truncate_with_folder_marker)
      if [[ -n $_POWERLEVEL9K_SHORTEN_FOLDER_MARKER ]]; then
        local dir=$_p9k__cwd
        local -a m=()
        local -i i=$(($#parts - 1))
        for (( ; i > 1; --i )); do
          dir=${dir:h}
          [[ -n $dir/${~_POWERLEVEL9K_SHORTEN_FOLDER_MARKER}(#qN) ]] && m+=$i
        done
        m+=1
        for (( i=1; i < $#m; ++i )); do
          (( m[i] - m[i+1] > 2 )) && parts[m[i+1]+1,m[i]-1]=($'\1')
        done
      fi
    ;;
    *)
      if (( shortenlen > 0 )); then
        local -i len=$#parts
        [[ -z $parts[1] ]] && (( --len ))
        if (( len > shortenlen )); then
          parts[1,-shortenlen-1]=($'\1')
        fi
      fi
    ;;
  esac

  # w=0: writable
  # w=1: not writable
  # w=2: does not exist
  (( !_POWERLEVEL9K_DIR_SHOW_WRITABLE )) || [[ -w $_p9k__cwd ]]
  local -i w=$?
  (( w && _POWERLEVEL9K_DIR_SHOW_WRITABLE > 2 )) && [[ ! -e $_p9k__cwd ]] && w=2
  if ! _p9k_cache_ephemeral_get $0 $_p9k__cwd $p $w $fake_first "${parts[@]}"; then
    local state=$0
    local icon=''
    local a='' b='' c=''
    for a b c in "${_POWERLEVEL9K_DIR_CLASSES[@]}"; do
      if [[ $_p9k__cwd == ${~a} ]]; then
        [[ -n $b ]] && state+=_${${(U)b}//İ/I}
        icon=$'\1'$c
        break
      fi
    done
    if (( w )); then
      if (( _POWERLEVEL9K_DIR_SHOW_WRITABLE == 1 )); then
        state=${0}_NOT_WRITABLE
      elif (( w == 2 )); then
        state+=_NON_EXISTENT
      else
        state+=_NOT_WRITABLE
      fi
      icon=LOCK_ICON
    fi

    local state_u=${${(U)state}//İ/I}

    local style=%b
    _p9k_color $state BACKGROUND blue
    _p9k_background $_p9k__ret
    style+=$_p9k__ret
    _p9k_color $state FOREGROUND "$_p9k_color1"
    _p9k_foreground $_p9k__ret
    style+=$_p9k__ret
    if (( expand )); then
      _p9k_escape_style $style
      style=$_p9k__ret
    fi

    parts=("${(@)parts//\%/%%}")
    if [[ $_POWERLEVEL9K_HOME_FOLDER_ABBREVIATION != '~' && $fake_first == 0 && $p == ('~'|'~/'*) ]]; then
      (( expand )) && _p9k_escape $_POWERLEVEL9K_HOME_FOLDER_ABBREVIATION || _p9k__ret=$_POWERLEVEL9K_HOME_FOLDER_ABBREVIATION
      parts[1]=$_p9k__ret
      [[ $_p9k__ret == *%* ]] && parts[1]+=$style
    elif [[ $_POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER == 1 && $fake_first == 0 && $#parts > 1 && -z $parts[1] && -n $parts[2] ]]; then
      parts[1]=()
    fi

    local last_style=
    _p9k_param $state PATH_HIGHLIGHT_BOLD ''
    [[ $_p9k__ret == true ]] && last_style+=%B
    if (( $+parameters[_POWERLEVEL9K_DIR_PATH_HIGHLIGHT_FOREGROUND] ||
          $+parameters[_POWERLEVEL9K_${state_u}_PATH_HIGHLIGHT_FOREGROUND] )); then
      _p9k_color $state PATH_HIGHLIGHT_FOREGROUND ''
      _p9k_foreground $_p9k__ret
      last_style+=$_p9k__ret
    fi
    if [[ -n $last_style ]]; then
      (( expand )) && _p9k_escape_style $last_style || _p9k__ret=$last_style
      parts[-1]=$_p9k__ret${parts[-1]//$'\1'/$'\1'$_p9k__ret}$style
    fi

    local anchor_style=
    _p9k_param $state ANCHOR_BOLD ''
    [[ $_p9k__ret == true ]] && anchor_style+=%B
    if (( $+parameters[_POWERLEVEL9K_DIR_ANCHOR_FOREGROUND] ||
          $+parameters[_POWERLEVEL9K_${state_u}_ANCHOR_FOREGROUND] )); then
      _p9k_color $state ANCHOR_FOREGROUND ''
      _p9k_foreground $_p9k__ret
      anchor_style+=$_p9k__ret
    fi
    if [[ -n $anchor_style ]]; then
      (( expand )) && _p9k_escape_style $anchor_style || _p9k__ret=$anchor_style
      if [[ -z $last_style ]]; then
        parts=("${(@)parts/%(#b)(*)$'\2'/$_p9k__ret$match[1]$style}")
      else
        (( $#parts > 1 )) && parts[1,-2]=("${(@)parts[1,-2]/%(#b)(*)$'\2'/$_p9k__ret$match[1]$style}")
        parts[-1]=${parts[-1]/$'\2'}
      fi
    else
      parts=("${(@)parts/$'\2'}")
    fi

    if (( $+parameters[_POWERLEVEL9K_DIR_SHORTENED_FOREGROUND] ||
          $+parameters[_POWERLEVEL9K_${state_u}_SHORTENED_FOREGROUND] )); then
      _p9k_color $state SHORTENED_FOREGROUND ''
      _p9k_foreground $_p9k__ret
      (( expand )) && _p9k_escape_style $_p9k__ret
      local shortened_fg=$_p9k__ret
      (( expand )) && _p9k_escape $delim || _p9k__ret=$delim
      [[ $_p9k__ret == *%* ]] && _p9k__ret+=$style$shortened_fg
      parts=("${(@)parts/(#b)$'\3'(*)$'\1'(*)$'\3'/$shortened_fg$match[1]$_p9k__ret$match[2]$style}")
      parts=("${(@)parts/(#b)(*)$'\1'(*)/$shortened_fg$match[1]$_p9k__ret$match[2]$style}")
    else
      (( expand )) && _p9k_escape $delim || _p9k__ret=$delim
      [[ $_p9k__ret == *%* ]] && _p9k__ret+=$style
      parts=("${(@)parts/$'\1'/$_p9k__ret}")
      parts=("${(@)parts//$'\3'}")
    fi

    if [[ $_p9k__cwd == / && $_POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER == 1 ]]; then
      local sep='/'
    else
      local sep=''
      if (( $+parameters[_POWERLEVEL9K_DIR_PATH_SEPARATOR_FOREGROUND] ||
            $+parameters[_POWERLEVEL9K_${state_u}_PATH_SEPARATOR_FOREGROUND] )); then
        _p9k_color $state PATH_SEPARATOR_FOREGROUND ''
        _p9k_foreground $_p9k__ret
        (( expand )) && _p9k_escape_style $_p9k__ret
        sep=$_p9k__ret
      fi
      _p9k_param $state PATH_SEPARATOR /
      _p9k__ret=${(g::)_p9k__ret}
      (( expand )) && _p9k_escape $_p9k__ret
      sep+=$_p9k__ret
      [[ $sep == *%* ]] && sep+=$style
    fi

    local content="${(pj.$sep.)parts}"
    if (( _POWERLEVEL9K_DIR_HYPERLINK && _p9k_term_has_href )) && [[ $_p9k__cwd == /* ]]; then
      _p9k_url_escape $_p9k__cwd
      local header=$'%{\e]8;;file://'$_p9k__ret$'\a%}'
      local footer=$'%{\e]8;;\a%}'
      if (( expand )); then
        _p9k_escape $header
        header=$_p9k__ret
        _p9k_escape $footer
        footer=$_p9k__ret
      fi
      content=$header$content$footer
    fi

    (( expand )) && _p9k_prompt_length "${(e):-"\${\${_p9k__d::=0}+}$content"}" || _p9k__ret=
    _p9k_cache_ephemeral_set "$state" "$icon" "$expand" "$content" $_p9k__ret
  fi

  if (( _p9k__cache_val[3] )); then
    if (( $+_p9k__dir )); then
      _p9k__cache_val[4]='${${_p9k__d::=-1024}+}'$_p9k__cache_val[4]
    else
      _p9k__dir=$_p9k__cache_val[4]
      _p9k__dir_len=$_p9k__cache_val[5]
      _p9k__cache_val[4]='%{d%}'$_p9k__cache_val[4]'%{d%}'
    fi
  fi
  _p9k_prompt_segment "$_p9k__cache_val[1]" "blue" "$_p9k_color1" "$_p9k__cache_val[2]" "$_p9k__cache_val[3]" "" "$_p9k__cache_val[4]"
}

instant_prompt_dir() { prompt_dir; }

################################################################
# Docker machine
prompt_docker_machine() {
  _p9k_prompt_segment "$0" "magenta" "$_p9k_color1" 'SERVER_ICON' 0 '' "${DOCKER_MACHINE_NAME//\%/%%}"
}

_p9k_prompt_docker_machine_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$DOCKER_MACHINE_NAME'
}

################################################################
# GO prompt
prompt_go_version() {
  _p9k_cached_cmd 0 '' go version || return
  [[ $_p9k__ret == (#b)*go([[:digit:].]##)* ]] || return
  local v=$match[1]
  if (( _POWERLEVEL9K_GO_VERSION_PROJECT_ONLY )); then
    local p=$GOPATH
    if [[ -z $p ]]; then
      if [[ -d $HOME/go ]]; then
        p=$HOME/go
      else
        p="$(go env GOPATH 2>/dev/null)" && [[ -n $p ]] || return
      fi
    fi
    if [[ $_p9k__cwd/ != $p/* && $_p9k__cwd_a/ != $p/* ]]; then
      _p9k_upglob go.mod && return
    fi
  fi
  _p9k_prompt_segment "$0" "green" "grey93" "GO_ICON" 0 '' "${v//\%/%%}"
}

_p9k_prompt_go_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[go]'
}

################################################################
# Command number (in local history)
prompt_history() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "$0" "grey50" "$_p9k_color1" '' 0 '' '%h'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

prompt_package() {
  unset P9K_PACKAGE_NAME P9K_PACKAGE_VERSION
  _p9k_upglob package.json && return

  local file=$_p9k__parent_dirs[$?]/package.json
  if ! _p9k_cache_stat_get $0 $file; then
    () {
      local data field
      local -A found
      # Redneck json parsing. Yields correct results for any well-formed json document.
      # Produces random garbage for invalid json.
      { data="$(<$file)" || return } 2>/dev/null
      data=${${data//$'\r'}##[[:space:]]#}
      [[ $data == '{'* ]] || return
      data[1]=
      local -i depth=1
      while true; do
        data=${data##[[:space:]]#}
        [[ -n $data ]] || return
        case $data[1] in
          '{'|'[')      data[1]=; (( ++depth ));;
          '}'|']')      data[1]=; (( --depth > 0 )) || return;;
          ':')          data[1]=;;
          ',')          data[1]=; field=;;
          [[:alnum:].]) data=${data##[[:alnum:].]#};;
          '"')
            local tail=${data##\"([^\"\\]|\\?)#}
            [[ $tail == '"'* ]] || return
            local s=${data:1:-$#tail}
            data=${tail:1}
            (( depth == 1 )) || continue
            if [[ -z $field ]]; then
              field=${s:-x}
            elif [[ $field == (name|version) ]]; then
              (( ! $+found[$field] ))   || return
              [[ -n $s ]]               || return
              [[ $s != *($'\n'|'\')* ]] || return
              found[$field]=$s
              (( $#found == 2 )) && break
            fi
          ;;
          *) return 1;;
        esac
      done
      _p9k_cache_stat_set 1 $found[name] $found[version]
      return 0
    } || _p9k_cache_stat_set 0
  fi
  (( _p9k__cache_val[1] )) || return

  P9K_PACKAGE_NAME=$_p9k__cache_val[2]
  P9K_PACKAGE_VERSION=$_p9k__cache_val[3]
  _p9k_prompt_segment "$0" "cyan" "$_p9k_color1" PACKAGE_ICON 0 '' ${P9K_PACKAGE_VERSION//\%/%%}
}

################################################################
# Detection for virtualization (systemd based systems only)
prompt_detect_virt() {
  local virt="$(systemd-detect-virt 2>/dev/null)"
  if [[ "$virt" == "none" ]]; then
    local -a inode
    if zstat -A inode +inode / 2>/dev/null && [[ $inode[1] != 2 ]]; then
      virt="chroot"
    fi
  fi
  if [[ -n "${virt}" ]]; then
    _p9k_prompt_segment "$0" "$_p9k_color1" "yellow" '' 0 '' "${virt//\%/%%}"
  fi
}

_p9k_prompt_detect_virt_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[systemd-detect-virt]'
}

################################################################
# Segment to display the current IP address
prompt_ip() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "$0" "cyan" "$_p9k_color1" 'NETWORK_ICON' 1 '$P9K_IP_IP' '$P9K_IP_IP'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

################################################################
# Segment to display if VPN is active
prompt_vpn_ip() {
  typeset -ga _p9k__vpn_ip_segments
  _p9k__vpn_ip_segments+=($_p9k__prompt_side $_p9k__line_index $_p9k__segment_index)
  local p='${(e)_p9k__vpn_ip_'$_p9k__prompt_side$_p9k__segment_index'}'
  _p9k__prompt+=$p
  typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$p
}

_p9k_vpn_ip_render() {
  local _p9k__segment_name=vpn_ip _p9k__prompt_side ip
  local -i _p9k__has_upglob _p9k__segment_index
  for _p9k__prompt_side _p9k__line_index _p9k__segment_index in $_p9k__vpn_ip_segments; do
    local _p9k__prompt=
    for ip in $_p9k__vpn_ip_ips; do
      _p9k_prompt_segment prompt_vpn_ip "cyan" "$_p9k_color1" 'VPN_ICON' 0 '' $ip
    done
    typeset -g _p9k__vpn_ip_$_p9k__prompt_side$_p9k__segment_index=$_p9k__prompt
  done
}

################################################################
# Segment to display laravel version
prompt_laravel_version() {
  _p9k_upglob artisan && return
  local dir=$_p9k__parent_dirs[$?]
  local app=$dir/vendor/laravel/framework/src/Illuminate/Foundation/Application.php
  [[ -r $app ]] || return
  if ! _p9k_cache_stat_get $0 $dir/artisan $app; then
    local v="$(php $dir/artisan --version 2> /dev/null)"
    _p9k_cache_stat_set "${${(M)v:#Laravel Framework *}#Laravel Framework }"
  fi
  [[ -n $_p9k__cache_val[1] ]] || return
  _p9k_prompt_segment "$0" "maroon" "white" 'LARAVEL_ICON' 0 '' "${_p9k__cache_val[1]//\%/%%}"
}

_p9k_prompt_laravel_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[php]'
}

################################################################
# Segment to display load
prompt_load() {
  if [[ $_p9k_os == (OSX|BSD) ]]; then
    local -i len=$#_p9k__prompt _p9k__has_upglob
    _p9k_prompt_segment $0_CRITICAL red    "$_p9k_color1" LOAD_ICON 1 '$_p9k__load_critical' '$_p9k__load_value'
    _p9k_prompt_segment $0_WARNING  yellow "$_p9k_color1" LOAD_ICON 1 '$_p9k__load_warning'  '$_p9k__load_value'
    _p9k_prompt_segment $0_NORMAL   green  "$_p9k_color1" LOAD_ICON 1 '$_p9k__load_normal'   '$_p9k__load_value'
    (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
    return
  fi

  [[ -r /proc/loadavg ]] || return
  _p9k_read_file /proc/loadavg || return
  local load=${${(A)=_p9k__ret}[_POWERLEVEL9K_LOAD_WHICH]//,/.}
  local -F pct='100. * load / _p9k_num_cpus'
  if (( pct > _POWERLEVEL9K_LOAD_CRITICAL_PCT )); then
    _p9k_prompt_segment $0_CRITICAL red    "$_p9k_color1" LOAD_ICON 0 '' $load
  elif (( pct > _POWERLEVEL9K_LOAD_WARNING_PCT )); then
    _p9k_prompt_segment $0_WARNING  yellow "$_p9k_color1" LOAD_ICON 0 '' $load
  else
    _p9k_prompt_segment $0_NORMAL   green  "$_p9k_color1" LOAD_ICON 0 '' $load
  fi
}

_p9k_prompt_load_init() {
  if [[ $_p9k_os == (OSX|BSD) ]]; then
    typeset -g _p9k__load_value=
    typeset -g _p9k__load_normal=
    typeset -g _p9k__load_warning=
    typeset -g _p9k__load_critical=
    _p9k__async_segments_compute+='_p9k_worker_invoke load _p9k_prompt_load_compute'
  elif [[ ! -r /proc/loadavg ]]; then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
  fi
}

_p9k_prompt_load_compute() {
  (( $+commands[sysctl] )) || return
  _p9k_worker_async _p9k_prompt_load_async _p9k_prompt_load_sync
}

_p9k_prompt_load_async() {
  local load="$(sysctl -n vm.loadavg 2>/dev/null)" || return
  load=${${(A)=load}[_POWERLEVEL9K_LOAD_WHICH+1]//,/.}
  [[ $load == <->(|.<->) && $load != $_p9k__load_value ]] || return
  _p9k__load_value=$load
  _p9k__load_normal=
  _p9k__load_warning=
  _p9k__load_critical=
  local -F pct='100. * _p9k__load_value / _p9k_num_cpus'
  if (( pct > _POWERLEVEL9K_LOAD_CRITICAL_PCT )); then
    _p9k__load_critical=1
  elif (( pct > _POWERLEVEL9K_LOAD_WARNING_PCT )); then
    _p9k__load_warning=1
  else
    _p9k__load_normal=1
  fi
  _p9k_print_params     \
    _p9k__load_value    \
    _p9k__load_normal   \
    _p9k__load_warning  \
    _p9k__load_critical
  echo -E - 'reset=1'
}

_p9k_prompt_load_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

# Usage: _p9k_cached_cmd <0|1> <dep> <cmd> [args...]
#
# The first argument says whether to capture stderr (1) or ignore it (0).
# The second argument can be empty or a file. If it's a file, the
# output of the command is presumed to potentially depend on it.
function _p9k_cached_cmd() {
  local cmd=$commands[$3]
  [[ -n $cmd ]] || return
  if ! _p9k_cache_stat_get $0" ${(q)*}" $2 $cmd; then
    local out
    if (( $1 )); then
      out="$($cmd "${@:4}" 2>&1)"
    else
      out="$($cmd "${@:4}" 2>/dev/null)"
    fi
    _p9k_cache_stat_set $(( ! $? )) "$out"
  fi
  (( $_p9k__cache_val[1] )) || return
  _p9k__ret=$_p9k__cache_val[2]
}

################################################################
# Segment to diplay Node version
prompt_node_version() {
  _p9k_upglob package.json
  local -i idx=$?
  if (( idx )); then
    _p9k_cached_cmd 0 $_p9k__parent_dirs[idx]/package.json node --version || return
  else
    (( _POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY )) && return
    _p9k_cached_cmd 0 '' node --version || return
  fi
  [[ $_p9k__ret == v?* ]] || return
  _p9k_prompt_segment "$0" "green" "white" 'NODE_ICON' 0 '' "${_p9k__ret#v}"
}

_p9k_prompt_node_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[node]'
}

# Almost the same as `nvm_version default` but faster. The differences shouldn't affect
# the observable behavior of Powerlevel10k.
function _p9k_nvm_ls_default() {
  local v=default
  local -a seen=($v)
  while [[ -r $NVM_DIR/alias/$v ]]; do
    local target=
    IFS='' read -r target <$NVM_DIR/alias/$v
    target=${target%$'\r'}
    [[ -z $target ]] && break
    (( $seen[(I)$target] )) && return
    seen+=$target
    v=$target
  done

  case $v in
    default|N/A)
      return 1
    ;;
    system|v)
      _p9k__ret=system
      return 0
    ;;
    iojs-[0-9]*)
      v=iojs-v${v#iojs-}
    ;;
    [0-9]*)
      v=v$v
    ;;
  esac

  if [[ $v == v*.*.* ]]; then
    if [[ -x $NVM_DIR/versions/node/$v/bin/node || -x $NVM_DIR/$v/bin/node ]]; then
      _p9k__ret=$v
      return 0
    elif [[ -x $NVM_DIR/versions/io.js/$v/bin/node ]]; then
      _p9k__ret=iojs-$v
      return 0
    else
      return 1
    fi
  fi

  local -a dirs=()
  case $v in
    node|node-|stable)
      dirs=($NVM_DIR/versions/node $NVM_DIR)
      v='(v[1-9]*|v0.*[02468].*)'
    ;;
    unstable)
      dirs=($NVM_DIR/versions/node $NVM_DIR)
      v='v0.*[13579].*'
    ;;
    iojs*)
      dirs=($NVM_DIR/versions/io.js)
      v=v${${${v#iojs}#-}#v}'*'
    ;;
    *)
      dirs=($NVM_DIR/versions/node $NVM_DIR $NVM_DIR/versions/io.js)
      v=v${v#v}'*'
    ;;
  esac

  local -a matches=(${^dirs}/${~v}(/N))
  (( $#matches )) || return

  local max path
  for path in ${(Oa)matches}; do
    [[ ${path:t} == (#b)v(*).(*).(*) ]] || continue
    v=${(j::)${(@l:6::0:)match}}
    [[ $v > $max ]] || continue
    max=$v
    _p9k__ret=${path:t}
    [[ ${path:h:t} != io.js ]] || _p9k__ret=iojs-$_p9k__ret
  done

  [[ -n $max ]]
}

# The same as `nvm_version current` but faster.
_p9k_nvm_ls_current() {
  local node_path=${commands[node]:A}
  [[ -n $node_path ]] || return

  local nvm_dir=${NVM_DIR:A}
  if [[ -n $nvm_dir && $node_path == $nvm_dir/versions/io.js/* ]]; then
    _p9k_cached_cmd 0 '' iojs --version || return
    _p9k__ret=iojs-v${_p9k__ret#v}
  elif [[ -n $nvm_dir && $node_path == $nvm_dir/* ]]; then
    _p9k_cached_cmd 0 '' node --version || return
    _p9k__ret=v${_p9k__ret#v}
  else
    _p9k__ret=system
  fi
}

################################################################
# Segment to display Node version from NVM
# Only prints the segment if different than the default value
prompt_nvm() {
  [[ -n $NVM_DIR ]] && _p9k_nvm_ls_current || return
  local current=$_p9k__ret
  ! _p9k_nvm_ls_default || [[ $_p9k__ret != $current ]] || return
  _p9k_prompt_segment "$0" "magenta" "black" 'NODE_ICON' 0 '' "${${current#v}//\%/%%}"
}

_p9k_prompt_nvm_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[nvm]:-${${+functions[nvm]}:#0}}'
}

################################################################
# Segment to display NodeEnv
prompt_nodeenv() {
  local msg
  if (( _POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION )) && _p9k_cached_cmd 0 '' node --version; then
    msg="${_p9k__ret//\%/%%} "
  fi
  msg+="$_POWERLEVEL9K_NODEENV_LEFT_DELIMITER${${NODE_VIRTUAL_ENV:t}//\%/%%}$_POWERLEVEL9K_NODEENV_RIGHT_DELIMITER"
  _p9k_prompt_segment "$0" "black" "green" 'NODE_ICON' 0 '' "$msg"
}

_p9k_prompt_nodeenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$NODE_VIRTUAL_ENV'
}

function _p9k_nodeenv_version_transform() {
  local dir=${NODENV_ROOT:-$HOME/.nodenv}/versions
  [[ -z $1 || $1 == system ]] && _p9k__ret=$1          && return
  [[ -d $dir/$1 ]]            && _p9k__ret=$1          && return
  [[ -d $dir/${1/v} ]]        && _p9k__ret=${1/v}      && return
  [[ -d $dir/${1#node-} ]]    && _p9k__ret=${1#node-}  && return
  [[ -d $dir/${1#node-v} ]]   && _p9k__ret=${1#node-v} && return
  return 1
}

function _p9k_nodenv_global_version() {
  _p9k_read_word ${NODENV_ROOT:-$HOME/.nodenv}/version || _p9k__ret=system
}

################################################################
# Segment to display nodenv information
# https://github.com/nodenv/nodenv
prompt_nodenv() {
  if [[ -n $NODENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_NODENV_SOURCES[(I)shell]} )) || return
    local v=$NODENV_VERSION
  else
    (( ${_POWERLEVEL9K_NODENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $NODENV_DIR != (|.) ]]; then
      [[ $NODENV_DIR == /* ]] && local dir=$NODENV_DIR || local dir="$_p9k__cwd_a/$NODENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.node-version; then
            (( ${_POWERLEVEL9K_NODENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .node-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.node-version; then
        (( ${_POWERLEVEL9K_NODENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_NODENV_SOURCES[(I)global]} )) || return
      _p9k_nodenv_global_version
    fi

    _p9k_nodeenv_version_transform $_p9k__ret || return
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_nodenv_global_version
    _p9k_nodeenv_version_transform $_p9k__ret && [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_NODENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "black" "green" 'NODE_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_nodenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[nodenv]:-${${+functions[nodenv]}:#0}}'
}

prompt_dotnet_version() {
  if (( _POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY )); then
    _p9k_upglob 'project.json|global.json|packet.dependencies|*.csproj|*.fsproj|*.xproj|*.sln' && return
  fi
  _p9k_cached_cmd 0 '' dotnet --version || return
  _p9k_prompt_segment "$0" "magenta" "white" 'DOTNET_ICON' 0 '' "$_p9k__ret"
}

_p9k_prompt_dotnet_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[dotnet]'
}

################################################################
# Segment to print a little OS icon
prompt_os_icon() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "$0" "black" "white" '' 0 '' "$_p9k_os_icon"
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_os_icon() { prompt_os_icon; }

################################################################
# Segment to display PHP version number
prompt_php_version() {
  if (( _POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY )); then
    _p9k_upglob 'composer.json|*.php' && return
  fi
  _p9k_cached_cmd 0 '' php --version || return
  [[ $_p9k__ret == (#b)(*$'\n')#'PHP '([[:digit:].]##)* ]] || return
  local v=$match[2]
  _p9k_prompt_segment "$0" "fuchsia" "grey93" 'PHP_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_php_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[php]'
}

################################################################
# Segment to display free RAM and used Swap
prompt_ram() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 yellow "$_p9k_color1" RAM_ICON 1 '$_p9k__ram_free' '$_p9k__ram_free'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

function _p9k_prompt_ram_init() {
  if [[ $_p9k_os == OSX && $+commands[vm_stat] == 0 ||
        $_p9k_os == BSD && ! -r /var/run/dmesg.boot ||
        $_p9k_os != (OSX|BSD) && ! -r /proc/meminfo ]]; then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
    return
  fi
  typeset -g _p9k__ram_free=
  _p9k__async_segments_compute+='_p9k_worker_invoke ram _p9k_prompt_ram_compute'
}

_p9k_prompt_ram_compute() {
  _p9k_worker_async _p9k_prompt_ram_async _p9k_prompt_ram_sync
}

_p9k_prompt_ram_async() {
  local -F free_bytes

  case $_p9k_os in
    OSX)
      (( $+commands[vm_stat] )) || return
      local stat && stat="$(vm_stat 2>/dev/null)" || return
      [[ $stat =~ 'Pages free:[[:space:]]+([0-9]+)' ]] || return
      (( free_bytes += match[1] ))
      [[ $stat =~ 'Pages inactive:[[:space:]]+([0-9]+)' ]] || return
      (( free_bytes += match[1] ))
      if (( ! $+_p9k__ram_pagesize )); then
        local p
        (( $+commands[pagesize] )) && p=$(pagesize 2>/dev/null) && [[ $p == <1-> ]] || p=4096
        typeset -gi _p9k__ram_pagesize=p
        _p9k_print_params _p9k__ram_pagesize
      fi
      (( free_bytes *= _p9k__ram_pagesize ))
    ;;
    BSD)
      local stat && stat="$(grep -F 'avail memory' /var/run/dmesg.boot 2>/dev/null)" || return
      free_bytes=${${(A)=stat}[4]}
    ;;
    *)
      [[ -r /proc/meminfo ]] || return
      local stat && stat="$(</proc/meminfo)" || return
      [[ $stat == (#b)*(MemAvailable:|MemFree:)[[:space:]]#(<->)* ]] || return
      free_bytes=$(( $match[2] * 1024 ))
    ;;
  esac

  _p9k_human_readable_bytes $free_bytes
  [[ $_p9k__ret != $_p9k__ram_free ]] || return
  _p9k__ram_free=$_p9k__ret
  _p9k_print_params _p9k__ram_free
  echo -E - 'reset=1'
}

_p9k_prompt_ram_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

function _p9k_rbenv_global_version() {
  _p9k_read_word ${RBENV_ROOT:-$HOME/.rbenv}/version || _p9k__ret=system
}

################################################################
# Segment to display rbenv information
# https://github.com/rbenv/rbenv#choosing-the-ruby-version
prompt_rbenv() {
  if [[ -n $RBENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_RBENV_SOURCES[(I)shell]} )) || return
    local v=$RBENV_VERSION
  else
    (( ${_POWERLEVEL9K_RBENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $RBENV_DIR != (|.) ]]; then
      [[ $RBENV_DIR == /* ]] && local dir=$RBENV_DIR || local dir="$_p9k__cwd_a/$RBENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.ruby-version; then
            (( ${_POWERLEVEL9K_RBENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .ruby-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.ruby-version; then
        (( ${_POWERLEVEL9K_RBENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_RBENV_SOURCES[(I)global]} )) || return
      _p9k_rbenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_rbenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_RBENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "red" "$_p9k_color1" 'RUBY_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_rbenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[rbenv]:-${${+functions[rbenv]}:#0}}'
}

function _p9k_phpenv_global_version() {
  _p9k_read_word ${PHPENV_ROOT:-$HOME/.phpenv}/version || _p9k__ret=system
}

function _p9k_scalaenv_global_version() {
  _p9k_read_word ${SCALAENV_ROOT:-$HOME/.scalaenv}/version || _p9k__ret=system
}

# https://github.com/scalaenv/scalaenv
prompt_scalaenv() {
  if [[ -n $SCALAENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_SCALAENV_SOURCES[(I)shell]} )) || return
    local v=$SCALAENV_VERSION
  else
    (( ${_POWERLEVEL9K_SCALAENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $SCALAENV_DIR != (|.) ]]; then
      [[ $SCALAENV_DIR == /* ]] && local dir=$SCALAENV_DIR || local dir="$_p9k__cwd_a/$SCALAENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.scala-version; then
            (( ${_POWERLEVEL9K_SCALAENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .scala-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.scala-version; then
        (( ${_POWERLEVEL9K_SCALAENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_SCALAENV_SOURCES[(I)global]} )) || return
      _p9k_scalaenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_scalaenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_SCALAENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "red" "$_p9k_color1" 'SCALA_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_scalaenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[scalaenv]:-${${+functions[scalaenv]}:#0}}'
}

function _p9k_phpenv_global_version() {
  _p9k_read_word ${PHPENV_ROOT:-$HOME/.phpenv}/version || _p9k__ret=system
}

prompt_phpenv() {
  if [[ -n $PHPENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_PHPENV_SOURCES[(I)shell]} )) || return
    local v=$PHPENV_VERSION
  else
    (( ${_POWERLEVEL9K_PHPENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $PHPENV_DIR != (|.) ]]; then
      [[ $PHPENV_DIR == /* ]] && local dir=$PHPENV_DIR || local dir="$_p9k__cwd_a/$PHPENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.php-version; then
            (( ${_POWERLEVEL9K_PHPENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .php-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.php-version; then
        (( ${_POWERLEVEL9K_PHPENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_PHPENV_SOURCES[(I)global]} )) || return
      _p9k_phpenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_phpenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_PHPENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "magenta" "$_p9k_color1" 'PHP_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_phpenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[phpenv]:-${${+functions[phpenv]}:#0}}'
}

function _p9k_luaenv_global_version() {
  _p9k_read_word ${LUAENV_ROOT:-$HOME/.luaenv}/version || _p9k__ret=system
}

################################################################
# Segment to display luaenv information
# https://github.com/cehoffman/luaenv
prompt_luaenv() {
  if [[ -n $LUAENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_LUAENV_SOURCES[(I)shell]} )) || return
    local v=$LUAENV_VERSION
  else
    (( ${_POWERLEVEL9K_LUAENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $LUAENV_DIR != (|.) ]]; then
      [[ $LUAENV_DIR == /* ]] && local dir=$LUAENV_DIR || local dir="$_p9k__cwd_a/$LUAENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.lua-version; then
            (( ${_POWERLEVEL9K_LUAENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .lua-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.lua-version; then
        (( ${_POWERLEVEL9K_LUAENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_LUAENV_SOURCES[(I)global]} )) || return
      _p9k_luaenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_luaenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_LUAENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" blue "$_p9k_color1" 'LUA_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_luaenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[luaenv]:-${${+functions[luaenv]}:#0}}'
}

function _p9k_jenv_global_version() {
  _p9k_read_word ${JENV_ROOT:-$HOME/.jenv}/version || _p9k__ret=system
}

################################################################
# Segment to display jenv information
# https://github.com/jenv/jenv
prompt_jenv() {
  if [[ -n $JENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_JENV_SOURCES[(I)shell]} )) || return
    local v=$JENV_VERSION
  else
    (( ${_POWERLEVEL9K_JENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $JENV_DIR != (|.) ]]; then
      [[ $JENV_DIR == /* ]] && local dir=$JENV_DIR || local dir="$_p9k__cwd_a/$JENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.java-version; then
            (( ${_POWERLEVEL9K_JENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .java-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.java-version; then
        (( ${_POWERLEVEL9K_JENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_JENV_SOURCES[(I)global]} )) || return
      _p9k_jenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_jenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_JENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" white red 'JAVA_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_jenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[jenv]:-${${+functions[jenv]}:#0}}'
}

function _p9k_plenv_global_version() {
  _p9k_read_word ${PLENV_ROOT:-$HOME/.plenv}/version || _p9k__ret=system
}

################################################################
# Segment to display plenv information
# https://github.com/plenv/plenv#choosing-the-perl-version
prompt_plenv() {
  if [[ -n $PLENV_VERSION ]]; then
    (( ${_POWERLEVEL9K_PLENV_SOURCES[(I)shell]} )) || return
    local v=$PLENV_VERSION
  else
    (( ${_POWERLEVEL9K_PLENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $PLENV_DIR != (|.) ]]; then
      [[ $PLENV_DIR == /* ]] && local dir=$PLENV_DIR || local dir="$_p9k__cwd_a/$PLENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_word $dir/.perl-version; then
            (( ${_POWERLEVEL9K_PLENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .perl-version
      local -i idx=$?
      if (( idx )) && _p9k_read_word $_p9k__parent_dirs[idx]/.perl-version; then
        (( ${_POWERLEVEL9K_PLENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_PLENV_SOURCES[(I)global]} )) || return
      _p9k_plenv_global_version
    fi
    local v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_plenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_PLENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PERL_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_plenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[plenv]:-${${+functions[plenv]}:#0}}'
}

################################################################
# Segment to display perlbrew information
# https://github.com/gugod/App-perlbrew

prompt_perlbrew() {
  if (( _POWERLEVEL9K_PERLBREW_PROJECT_ONLY )); then
    _p9k_upglob 'cpanfile|.perltidyrc|(|MY)META.(yml|json)|(Makefile|Build).PL|*.(pl|pm|t|pod)' && return
  fi

  local v=$PERLBREW_PERL
  (( _POWERLEVEL9K_PERLBREW_SHOW_PREFIX )) || v=${v#*-}
  [[ -n $v ]] || return
  _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PERL_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_perlbrew_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$PERLBREW_PERL'
}

################################################################
# Segment to display chruby information
# see https://github.com/postmodern/chruby/issues/245 for chruby_auto issue with ZSH
prompt_chruby() {
  local v
  (( _POWERLEVEL9K_CHRUBY_SHOW_ENGINE )) && v=$RUBY_ENGINE
  if [[ $_POWERLEVEL9K_CHRUBY_SHOW_VERSION == 1 && -n $RUBY_VERSION ]] && v+=${v:+ }$RUBY_VERSION
  _p9k_prompt_segment "$0" "red" "$_p9k_color1" 'RUBY_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_chruby_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$RUBY_ENGINE'
}

################################################################
# Segment to print an icon if user is root.
prompt_root_indicator() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "$0" "$_p9k_color1" "yellow" 'ROOT_ICON' 0 '${${(%):-%#}:#\%}' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_root_indicator() { prompt_root_indicator; }

################################################################
# Segment to display Rust version number
prompt_rust_version() {
  unset P9K_RUST_VERSION
  if (( _POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY )); then
    _p9k_upglob Cargo.toml && return
  fi
  local rustc=$commands[rustc] toolchain deps=()
  if (( $+commands[ldd] )); then
    if ! _p9k_cache_stat_get $0_so $rustc; then
      local line so
      for line in "${(@f)$(ldd $rustc 2>/dev/null)}"; do
        [[ $line == (#b)[[:space:]]#librustc_driver[^[:space:]]#.so' => '(*)' (0x'[[:xdigit:]]#')' ]] || continue
        so=$match[1]
        break
      done
      _p9k_cache_stat_set "$so"
    fi
    deps+=$_p9k__cache_val[1]
  fi
  if (( $+commands[rustup] )); then
    local rustup=$commands[rustup]
    local rustup_home=${RUSTUP_HOME:-~/.rustup}
    local cfg=($rustup_home/settings.toml(.N))
    deps+=($cfg $rustup_home/update-hashes/*(.N))
    if [[ -z ${toolchain::=$RUSTUP_TOOLCHAIN} ]]; then
      if ! _p9k_cache_stat_get $0_overrides $rustup $cfg; then
        local lines=(${(f)"$(rustup override list 2>/dev/null)"})
        if [[ $lines[1] == "no overrides" ]]; then
          _p9k_cache_stat_set
        else
          local MATCH
          local keys=(${(@)${lines%%[[:space:]]#[^[:space:]]#}/(#m)*/${(b)MATCH}/})
          local vals=(${(@)lines/(#m)*/$MATCH[(I)/] ${MATCH##*[[:space:]]}})
          _p9k_cache_stat_set ${keys:^vals}
        fi
      fi
      local -A overrides=($_p9k__cache_val)
      _p9k_upglob rust-toolchain
      local dir=$_p9k__parent_dirs[$?]
      local -i n m=${dir[(I)/]}
      local pair
      for pair in ${overrides[(K)$_p9k__cwd/]}; do
        n=${pair%% *}
        (( n <= m )) && continue
        m=n
        toolchain=${pair#* }
      done
      if [[ -z $toolchain && -n $dir ]]; then
        _p9k_read_word $dir/rust-toolchain
        toolchain=$_p9k__ret
      fi
    fi
  fi
  if ! _p9k_cache_stat_get $0_v$toolchain $rustc $deps; then
    _p9k_cache_stat_set "$($rustc --version 2>/dev/null)"
  fi
  local v=${${_p9k__cache_val[1]#rustc }%% *}
  [[ -n $v ]] || return
  typeset -g P9K_RUST_VERSION=$_p9k__cache_val[1]
  _p9k_prompt_segment "$0" "darkorange" "$_p9k_color1" 'RUST_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_rust_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[rustc]'
}

# RSpec test ratio
prompt_rspec_stats() {
  if [[ -d app && -d spec ]]; then
    local -a code=(app/**/*.rb(N))
    (( $#code )) || return
    local tests=(spec/**/*.rb(N))
    _p9k_build_test_stats "$0" "$#code" "$#tests" "RSpec" 'TEST_ICON'
  fi
}

################################################################
# Segment to display Ruby Version Manager information
prompt_rvm() {
  [[ $GEM_HOME == *rvm* && $ruby_string != $rvm_path/bin/ruby ]] || return
  local v=${GEM_HOME:t}
  (( _POWERLEVEL9K_RVM_SHOW_GEMSET )) || v=${v%%${rvm_gemset_separator:-@}*}
  (( _POWERLEVEL9K_RVM_SHOW_PREFIX )) || v=${v#*-}
  [[ -n $v ]] || return
  _p9k_prompt_segment "$0" "240" "$_p9k_color1" 'RUBY_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_rvm_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[rvm-prompt]:-${${+functions[rvm-prompt]}:#0}}'
}

################################################################
# Segment to display SSH icon when connected
prompt_ssh() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment "$0" "$_p9k_color1" "yellow" 'SSH_ICON' 0 '' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_ssh_init() {
  if (( ! P9K_SSH )); then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
  fi
}

instant_prompt_ssh() {
  if (( ! P9K_SSH )); then
    return
  fi
  prompt_ssh
}

################################################################
# Status: When an error occur, return the error code, or a cross icon if option is set
# Display an ok icon when no error occur, or hide the segment if option is set to false
prompt_status() {
  if ! _p9k_cache_get $0 $_p9k__status $_p9k__pipestatus; then
    (( _p9k__status )) && local state=ERROR || local state=OK
    if (( _POWERLEVEL9K_STATUS_EXTENDED_STATES )); then
      if (( _p9k__status )); then
        if (( $#_p9k__pipestatus > 1 )); then
          state+=_PIPE
        elif (( _p9k__status > 128 )); then
          state+=_SIGNAL
        fi
      elif [[ "$_p9k__pipestatus" == *[1-9]* ]]; then
        state+=_PIPE
      fi
    fi
    _p9k__cache_val=(:)
    if (( _POWERLEVEL9K_STATUS_$state )); then
      if (( _POWERLEVEL9K_STATUS_SHOW_PIPESTATUS )); then
        local text=${(j:|:)${(@)_p9k__pipestatus:/(#b)(*)/$_p9k_exitcode2str[$match[1]+1]}}
      else
        local text=$_p9k_exitcode2str[_p9k__status+1]
      fi
      if (( _p9k__status )); then
        if (( !_POWERLEVEL9K_STATUS_CROSS && _POWERLEVEL9K_STATUS_VERBOSE )); then
          _p9k__cache_val=($0_$state red yellow1 CARRIAGE_RETURN_ICON 0 '' "$text")
        else
          _p9k__cache_val=($0_$state $_p9k_color1 red FAIL_ICON 0 '' '')
        fi
      elif (( _POWERLEVEL9K_STATUS_VERBOSE || _POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE )); then
        [[ $state == OK ]] && text=''
        _p9k__cache_val=($0_$state "$_p9k_color1" green OK_ICON 0 '' "$text")
      fi
    fi
    if (( $#_p9k__pipestatus < 3 )); then
      _p9k_cache_set "${(@)_p9k__cache_val}"
    fi
  fi
  _p9k_prompt_segment "${(@)_p9k__cache_val}"
}

instant_prompt_status() {
  if (( _POWERLEVEL9K_STATUS_OK )); then
    _p9k_prompt_segment prompt_status_OK "$_p9k_color1" green OK_ICON 0 '' ''
  fi
}

prompt_prompt_char() {
  local saved=$_p9k__prompt_char_saved[$_p9k__prompt_side$_p9k__segment_index$((!_p9k__status))]
  if [[ -n $saved ]]; then
    _p9k__prompt+=$saved
    return
  fi
  local -i len=$#_p9k__prompt _p9k__has_upglob
  if (( __p9k_sh_glob )); then
    if (( _p9k__status )); then
      if (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE )); then
        _p9k_prompt_segment $0_ERROR_VIINS "$_p9k_color1" 196 '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*overwrite*}}' '❯'
        _p9k_prompt_segment $0_ERROR_VIOWR "$_p9k_color1" 196 '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*insert*}}' '▶'
      else
        _p9k_prompt_segment $0_ERROR_VIINS "$_p9k_color1" 196 '' 0 '${${${${_p9k__keymap:#vicmd}:#vivis}:#vivli}}' '❯'
      fi
      _p9k_prompt_segment $0_ERROR_VICMD "$_p9k_color1" 196 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' '❮'
      _p9k_prompt_segment $0_ERROR_VIVIS "$_p9k_color1" 196 '' 0 '${$((! ${#${${${${:-$_p9k__keymap$_p9k__region_active}:#vicmd1}:#vivis?}:#vivli?}})):#0}' 'Ⅴ'
    else
      if (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE )); then
        _p9k_prompt_segment $0_OK_VIINS "$_p9k_color1" 76 '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*overwrite*}}' '❯'
        _p9k_prompt_segment $0_OK_VIOWR "$_p9k_color1" 76 '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*insert*}}' '▶'
      else
        _p9k_prompt_segment $0_OK_VIINS "$_p9k_color1" 76 '' 0 '${${${${_p9k__keymap:#vicmd}:#vivis}:#vivli}}' '❯'
      fi
      _p9k_prompt_segment $0_OK_VICMD "$_p9k_color1" 76 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' '❮'
      _p9k_prompt_segment $0_OK_VIVIS "$_p9k_color1" 76 '' 0 '${$((! ${#${${${${:-$_p9k__keymap$_p9k__region_active}:#vicmd1}:#vivis?}:#vivli?}})):#0}' 'Ⅴ'
    fi
  else
    if (( _p9k__status )); then
      if (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE )); then
        _p9k_prompt_segment $0_ERROR_VIINS "$_p9k_color1" 196 '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*overwrite*)}' '❯'
        _p9k_prompt_segment $0_ERROR_VIOWR "$_p9k_color1" 196 '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*insert*)}' '▶'
      else
        _p9k_prompt_segment $0_ERROR_VIINS "$_p9k_color1" 196 '' 0 '${_p9k__keymap:#(vicmd|vivis|vivli)}' '❯'
      fi
      _p9k_prompt_segment $0_ERROR_VICMD "$_p9k_color1" 196 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' '❮'
      _p9k_prompt_segment $0_ERROR_VIVIS "$_p9k_color1" 196 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#(vicmd1|vivis?|vivli?)}' 'Ⅴ'
    else
      if (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE )); then
        _p9k_prompt_segment $0_OK_VIINS "$_p9k_color1" 76 '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*overwrite*)}' '❯'
        _p9k_prompt_segment $0_OK_VIOWR "$_p9k_color1" 76 '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*insert*)}' '▶'
      else
        _p9k_prompt_segment $0_OK_VIINS "$_p9k_color1" 76 '' 0 '${_p9k__keymap:#(vicmd|vivis|vivli)}' '❯'
      fi
      _p9k_prompt_segment $0_OK_VICMD "$_p9k_color1" 76 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' '❮'
      _p9k_prompt_segment $0_OK_VIVIS "$_p9k_color1" 76 '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#(vicmd1|vivis?|vivli?)}' 'Ⅴ'
    fi
  fi
  (( _p9k__has_upglob )) || _p9k__prompt_char_saved[$_p9k__prompt_side$_p9k__segment_index$((!_p9k__status))]=$_p9k__prompt[len+1,-1]
}

instant_prompt_prompt_char() {
  _p9k_prompt_segment prompt_prompt_char_OK_VIINS "$_p9k_color1" 76 '' 0 '' '❯'
}

################################################################
# Segment to display Swap information
prompt_swap() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 yellow "$_p9k_color1" SWAP_ICON 1 '$_p9k__swap_used' '$_p9k__swap_used'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

function _p9k_prompt_swap_init() {
  if [[ $_p9k_os == OSX && $+commands[sysctl] == 0 || $_p9k_os != OSX && ! -r /proc/meminfo ]]; then
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
    return
  fi
  typeset -g _p9k__swap_used=
  _p9k__async_segments_compute+='_p9k_worker_invoke swap _p9k_prompt_swap_compute'
}

_p9k_prompt_swap_compute() {
  _p9k_worker_async _p9k_prompt_swap_async _p9k_prompt_swap_sync
}

_p9k_prompt_swap_async() {
  local -F used_bytes

  if [[ "$_p9k_os" == "OSX" ]]; then
    (( $+commands[sysctl] )) || return
    [[ "$(sysctl vm.swapusage 2>/dev/null)" =~ "used = ([0-9,.]+)([A-Z]+)" ]] || return
    used_bytes=${match[1]//,/.}
    case ${match[2]} in
      'K') (( used_bytes *= 1024 ));;
      'M') (( used_bytes *= 1048576 ));;
      'G') (( used_bytes *= 1073741824 ));;
      'T') (( used_bytes *= 1099511627776 ));;
      *) return 0;;
    esac
  else
    local meminfo && meminfo="$(grep -F 'Swap' /proc/meminfo 2>/dev/null)" || return
    [[ $meminfo =~ 'SwapTotal:[[:space:]]+([0-9]+)' ]] || return
    (( used_bytes+=match[1] ))
    [[ $meminfo =~ 'SwapFree:[[:space:]]+([0-9]+)' ]] || return
    (( used_bytes-=match[1] ))
    (( used_bytes *= 1024 ))
  fi

  (( used_bytes >= 0 || (used_bytes = 0) ))

  _p9k_human_readable_bytes $used_bytes
  [[ $_p9k__ret != $_p9k__swap_used ]] || return
  _p9k__swap_used=$_p9k__ret
  _p9k_print_params _p9k__swap_used
  echo -E - 'reset=1'
}

_p9k_prompt_swap_sync() {
  eval $REPLY
  _p9k_worker_reply $REPLY
}

################################################################
# Symfony2-PHPUnit test ratio
prompt_symfony2_tests() {
  if [[ -d src && -d app && -f app/AppKernel.php ]]; then
    local -a all=(src/**/*.php(N))
    local -a code=(${(@)all##*Tests*})
    (( $#code )) || return
    _p9k_build_test_stats "$0" "$#code" "$(($#all - $#code))" "SF2" 'TEST_ICON'
  fi
}

################################################################
# Segment to display Symfony2-Version
prompt_symfony2_version() {
  if [[ -r app/bootstrap.php.cache ]]; then
    local v="${$(grep -F " VERSION " app/bootstrap.php.cache 2>/dev/null)//[![:digit:].]}"
    _p9k_prompt_segment "$0" "grey35" "$_p9k_color1" 'SYMFONY_ICON' 0 '' "${v//\%/%%}"
  fi
}

################################################################
# Show a ratio of tests vs code
_p9k_build_test_stats() {
  local code_amount="$2"
  local tests_amount="$3"
  local headline="$4"

  (( code_amount > 0 )) || return
  local -F 2 ratio=$(( 100. * tests_amount / code_amount ))

  (( ratio >= 75 )) && _p9k_prompt_segment "${1}_GOOD" "cyan" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
  (( ratio >= 50 && ratio < 75 )) && _p9k_prompt_segment "$1_AVG" "yellow" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
  (( ratio < 50 )) && _p9k_prompt_segment "$1_BAD" "red" "$_p9k_color1" "$5" 0 '' "$headline: $ratio%%"
}

################################################################
# System time
prompt_time() {
  if (( _POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME )); then
    _p9k_prompt_segment "$0" "$_p9k_color2" "$_p9k_color1" "TIME_ICON" 0 '' "$_POWERLEVEL9K_TIME_FORMAT"
  else
    if [[ $_p9k__refresh_reason == precmd ]]; then
      if [[ $+__p9k_instant_prompt_active == 1 && $__p9k_instant_prompt_time_format == $_POWERLEVEL9K_TIME_FORMAT ]]; then
        _p9k__time=${__p9k_instant_prompt_time//\%/%%}
      else
        _p9k__time=${${(%)_POWERLEVEL9K_TIME_FORMAT}//\%/%%}
      fi
    fi
    if (( _POWERLEVEL9K_TIME_UPDATE_ON_COMMAND )); then
      _p9k_escape $_p9k__time
      local t=$_p9k__ret
      _p9k_escape $_POWERLEVEL9K_TIME_FORMAT
      _p9k_prompt_segment "$0" "$_p9k_color2" "$_p9k_color1" "TIME_ICON" 1 '' \
          "\${_p9k__line_finished-$t}\${_p9k__line_finished+$_p9k__ret}"
    else
      _p9k_prompt_segment "$0" "$_p9k_color2" "$_p9k_color1" "TIME_ICON" 0 '' $_p9k__time
    fi
  fi
}

instant_prompt_time() {
  _p9k_escape $_POWERLEVEL9K_TIME_FORMAT
  local stash='${${__p9k_instant_prompt_time::=${(%)${__p9k_instant_prompt_time_format::='$_p9k__ret'}}}+}'
  _p9k_escape $_POWERLEVEL9K_TIME_FORMAT
  _p9k_prompt_segment prompt_time "$_p9k_color2" "$_p9k_color1" "TIME_ICON" 1 '' $stash$_p9k__ret
}

_p9k_prompt_time_init() {
  (( _POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME )) || return
  _p9k__async_segments_compute+='_p9k_worker_invoke time _p9k_prompt_time_compute'
}

_p9k_prompt_time_compute() {
  _p9k_worker_async _p9k_prompt_time_async _p9k_prompt_time_sync
}

_p9k_prompt_time_async() {
  sleep 1 || true
}

_p9k_prompt_time_sync() {
  _p9k_worker_reply '_p9k_worker_invoke _p9k_prompt_time_compute _p9k_prompt_time_compute; reset=1'
}

################################################################
# System date
prompt_date() {
  if [[ $_p9k__refresh_reason == precmd ]]; then
    if [[ $+__p9k_instant_prompt_active == 1 && $__p9k_instant_prompt_date_format == $_POWERLEVEL9K_DATE_FORMAT ]]; then
      _p9k__date=${__p9k_instant_prompt_date//\%/%%}
    else
      _p9k__date=${${(%)_POWERLEVEL9K_DATE_FORMAT}//\%/%%}
    fi
  fi
  _p9k_prompt_segment "$0" "$_p9k_color2" "$_p9k_color1" "DATE_ICON" 0 '' "$_p9k__date"
}

instant_prompt_date() {
  _p9k_escape $_POWERLEVEL9K_DATE_FORMAT
  local stash='${${__p9k_instant_prompt_date::=${(%)${__p9k_instant_prompt_date_format::='$_p9k__ret'}}}+}'
  _p9k_escape $_POWERLEVEL9K_DATE_FORMAT
  _p9k_prompt_segment prompt_date "$_p9k_color2" "$_p9k_color1" "DATE_ICON" 1 '' $stash$_p9k__ret
}

################################################################
# todo.sh: shows the number of tasks in your todo.sh file
prompt_todo() {
  unset P9K_TODO_TOTAL_TASK_COUNT P9K_TODO_FILTERED_TASK_COUNT
  [[ -r $_p9k__todo_file && -x $_p9k__todo_command ]] || return
  if ! _p9k_cache_stat_get $0 $_p9k__todo_file; then
    local count="$($_p9k__todo_command -p ls | command tail -1)"
    if [[ $count == (#b)'TODO: '([[:digit:]]##)' of '([[:digit:]]##)' '* ]]; then
      _p9k_cache_stat_set 1 $match[1] $match[2]
    else
      _p9k_cache_stat_set 0
    fi
  fi
  (( $_p9k__cache_val[1] )) || return
  typeset -gi P9K_TODO_FILTERED_TASK_COUNT=$_p9k__cache_val[2]
  typeset -gi P9K_TODO_TOTAL_TASK_COUNT=$_p9k__cache_val[3]
  if (( (P9K_TODO_TOTAL_TASK_COUNT    || !_POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL) &&
        (P9K_TODO_FILTERED_TASK_COUNT || !_POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED) )); then
    if (( P9K_TODO_TOTAL_TASK_COUNT == P9K_TODO_FILTERED_TASK_COUNT )); then
      local text=$P9K_TODO_TOTAL_TASK_COUNT
    else
      local text="$P9K_TODO_FILTERED_TASK_COUNT/$P9K_TODO_TOTAL_TASK_COUNT"
    fi
    _p9k_prompt_segment "$0" "grey50" "$_p9k_color1" 'TODO_ICON' 0 '' "$text"
  fi
}

_p9k_prompt_todo_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$_p9k__todo_file'
}

################################################################
# VCS segment: shows the state of your repository, if you are in a folder under
# version control

# The vcs segment can have 4 different states - defaults to 'CLEAN'.
typeset -gA __p9k_vcs_states=(
  'CLEAN'         '2'
  'MODIFIED'      '3'
  'UNTRACKED'     '2'
  'LOADING'       '8'
  'CONFLICTED'    '3'
)

function +vi-git-untracked() {
  [[ -z "${vcs_comm[gitdir]}" || "${vcs_comm[gitdir]}" == "." ]] && return

  # get the root for the current repo or submodule
  local repoTopLevel="$(git rev-parse --show-toplevel 2> /dev/null)"
  # dump out if we're outside a git repository (which includes being in the .git folder)
  [[ $? != 0 || -z $repoTopLevel ]] && return

  local untrackedFiles="$(git ls-files --others --exclude-standard "${repoTopLevel}" 2> /dev/null)"

  if [[ -z $untrackedFiles && $_POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY == 1 ]]; then
    untrackedFiles+="$(git submodule foreach --quiet --recursive 'git ls-files --others --exclude-standard' 2> /dev/null)"
  fi

  [[ -z $untrackedFiles ]] && return

  hook_com[unstaged]+=" $(print_icon 'VCS_UNTRACKED_ICON')"
  VCS_WORKDIR_HALF_DIRTY=true
}

function +vi-git-aheadbehind() {
  local ahead behind
  local -a gitstatus

  # for git prior to 1.7
  # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
  ahead="$(git rev-list --count "${hook_com[branch]}"@{upstream}..HEAD 2>/dev/null)"
  (( ahead )) && gitstatus+=( " $(print_icon 'VCS_OUTGOING_CHANGES_ICON')${ahead// /}" )

  # for git prior to 1.7
  # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
  behind="$(git rev-list --count HEAD.."${hook_com[branch]}"@{upstream} 2>/dev/null)"
  (( behind )) && gitstatus+=( " $(print_icon 'VCS_INCOMING_CHANGES_ICON')${behind// /}" )

  hook_com[misc]+=${(j::)gitstatus}
}

function +vi-git-remotebranch() {
  local remote
  local branch_name="${hook_com[branch]}"

  # Are we on a remote-tracking branch?
  remote="$(git rev-parse --verify HEAD@{upstream} --symbolic-full-name 2>/dev/null)"
  remote=${remote/refs\/(remotes|heads)\/}

  if (( $+_POWERLEVEL9K_VCS_SHORTEN_LENGTH && $+_POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH )); then
    if (( ${#hook_com[branch]} > _POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH && ${#hook_com[branch]} > _POWERLEVEL9K_VCS_SHORTEN_LENGTH )); then
      case $_POWERLEVEL9K_VCS_SHORTEN_STRATEGY in
        truncate_middle)
          hook_com[branch]="${branch_name:0:$_POWERLEVEL9K_VCS_SHORTEN_LENGTH}${_POWERLEVEL9K_VCS_SHORTEN_DELIMITER}${branch_name: -$_POWERLEVEL9K_VCS_SHORTEN_LENGTH}"
        ;;
        truncate_from_right)
          hook_com[branch]="${branch_name:0:$_POWERLEVEL9K_VCS_SHORTEN_LENGTH}${_POWERLEVEL9K_VCS_SHORTEN_DELIMITER}"
        ;;
      esac
    fi
  fi

  if (( _POWERLEVEL9K_HIDE_BRANCH_ICON )); then
    hook_com[branch]="${hook_com[branch]}"
  else
    hook_com[branch]="$(print_icon 'VCS_BRANCH_ICON')${hook_com[branch]}"
  fi
  # Always show the remote
  #if [[ -n ${remote} ]] ; then
  # Only show the remote if it differs from the local
  if [[ -n ${remote} ]] && [[ "${remote#*/}" != "${branch_name}" ]] ; then
     hook_com[branch]+="$(print_icon 'VCS_REMOTE_BRANCH_ICON')${remote// /}"
  fi
}

function +vi-git-tagname() {
  if (( !_POWERLEVEL9K_VCS_HIDE_TAGS )); then
    # If we are on a tag, append the tagname to the current branch string.
    local tag
    tag="$(git describe --tags --exact-match HEAD 2>/dev/null)"

    if [[ -n "${tag}" ]] ; then
      # There is a tag that points to our current commit. Need to determine if we
      # are also on a branch, or are in a DETACHED_HEAD state.
      if [[ -z "$(git symbolic-ref HEAD 2>/dev/null)" ]]; then
        # DETACHED_HEAD state. We want to append the tag name to the commit hash
        # and print it. Unfortunately, `vcs_info` blows away the hash when a tag
        # exists, so we have to manually retrieve it and clobber the branch
        # string.
        local revision
        revision="$(git rev-list -n 1 --abbrev-commit --abbrev=${_POWERLEVEL9K_CHANGESET_HASH_LENGTH} HEAD)"
        if (( _POWERLEVEL9K_HIDE_BRANCH_ICON )); then
          hook_com[branch]="${revision} $(print_icon 'VCS_TAG_ICON')${tag}"
        else
          hook_com[branch]="$(print_icon 'VCS_BRANCH_ICON')${revision} $(print_icon 'VCS_TAG_ICON')${tag}"
        fi
      else
        # We are on both a tag and a branch; print both by appending the tag name.
        hook_com[branch]+=" $(print_icon 'VCS_TAG_ICON')${tag}"
      fi
    fi
  fi
}

# Show count of stashed changes
# Port from https://github.com/whiteinge/dotfiles/blob/5dfd08d30f7f2749cfc60bc55564c6ea239624d9/.zsh_shouse_prompt#L268
function +vi-git-stash() {
  if [[ -s "${vcs_comm[gitdir]}/logs/refs/stash" ]] ; then
    local -a stashes=( "${(@f)"$(<${vcs_comm[gitdir]}/logs/refs/stash)"}" )
    hook_com[misc]+=" $(print_icon 'VCS_STASH_ICON')${#stashes}"
  fi
}

function +vi-hg-bookmarks() {
  if [[ -n "${hgbmarks[@]}" ]]; then
    hook_com[hg-bookmark-string]=" $(print_icon 'VCS_BOOKMARK_ICON')${hgbmarks[@]}"

    # To signal that we want to use the sting we just generated, set the special
    # variable `ret' to something other than the default zero:
    ret=1
    return 0
  fi
}

function +vi-vcs-detect-changes() {
  if [[ "${hook_com[vcs]}" == "git" ]]; then

    local remote="$(git ls-remote --get-url 2> /dev/null)"
    if [[ "$remote" =~ "github" ]] then
      vcs_visual_identifier='VCS_GIT_GITHUB_ICON'
    elif [[ "$remote" =~ "bitbucket" ]] then
      vcs_visual_identifier='VCS_GIT_BITBUCKET_ICON'
    elif [[ "$remote" =~ "stash" ]] then
      vcs_visual_identifier='VCS_GIT_BITBUCKET_ICON'
    elif [[ "$remote" =~ "gitlab" ]] then
      vcs_visual_identifier='VCS_GIT_GITLAB_ICON'
    else
      vcs_visual_identifier='VCS_GIT_ICON'
    fi

  elif [[ "${hook_com[vcs]}" == "hg" ]]; then
    vcs_visual_identifier='VCS_HG_ICON'
  elif [[ "${hook_com[vcs]}" == "svn" ]]; then
    vcs_visual_identifier='VCS_SVN_ICON'
  fi

  if [[ -n "${hook_com[staged]}" ]] || [[ -n "${hook_com[unstaged]}" ]]; then
    VCS_WORKDIR_DIRTY=true
  else
    VCS_WORKDIR_DIRTY=false
  fi
}

function +vi-svn-detect-changes() {
  local svn_status="$(svn status)"
  if [[ -n "$(echo "$svn_status" | \grep \^\?)" ]]; then
    hook_com[unstaged]+=" $(print_icon 'VCS_UNTRACKED_ICON')"
    VCS_WORKDIR_HALF_DIRTY=true
  fi
  if [[ -n "$(echo "$svn_status" | \grep \^\M)" ]]; then
    hook_com[unstaged]+=" $(print_icon 'VCS_UNSTAGED_ICON')"
    VCS_WORKDIR_DIRTY=true
  fi
  if [[ -n "$(echo "$svn_status" | \grep \^\A)" ]]; then
    hook_com[staged]+=" $(print_icon 'VCS_STAGED_ICON')"
    VCS_WORKDIR_DIRTY=true
  fi
}

_p9k_vcs_info_init() {
  autoload -Uz vcs_info

  local prefix=''
  if (( _POWERLEVEL9K_SHOW_CHANGESET )); then
    _p9k_get_icon '' VCS_COMMIT_ICON
    prefix="$_p9k__ret%0.${_POWERLEVEL9K_CHANGESET_HASH_LENGTH}i "
  fi

  zstyle ':vcs_info:*' check-for-changes true

  zstyle ':vcs_info:*' formats "$prefix%b%c%u%m"
  zstyle ':vcs_info:*' actionformats "%b %F{$_POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND}| %a%f"
  _p9k_get_icon '' VCS_STAGED_ICON
  zstyle ':vcs_info:*' stagedstr " $_p9k__ret"
  _p9k_get_icon '' VCS_UNSTAGED_ICON
  zstyle ':vcs_info:*' unstagedstr " $_p9k__ret"
  zstyle ':vcs_info:git*+set-message:*' hooks $_POWERLEVEL9K_VCS_GIT_HOOKS
  zstyle ':vcs_info:hg*+set-message:*' hooks $_POWERLEVEL9K_VCS_HG_HOOKS
  zstyle ':vcs_info:svn*+set-message:*' hooks $_POWERLEVEL9K_VCS_SVN_HOOKS

  # For Hg, only show the branch name
  if (( _POWERLEVEL9K_HIDE_BRANCH_ICON )); then
    zstyle ':vcs_info:hg*:*' branchformat "%b"
  else
    _p9k_get_icon '' VCS_BRANCH_ICON
    zstyle ':vcs_info:hg*:*' branchformat "$_p9k__ret%b"
  fi
  # The `get-revision` function must be turned on for dirty-check to work for Hg
  zstyle ':vcs_info:hg*:*' get-revision true
  zstyle ':vcs_info:hg*:*' get-bookmarks true
  zstyle ':vcs_info:hg*+gen-hg-bookmark-string:*' hooks hg-bookmarks

  # TODO: fix the %b (branch) format for svn. Using %b breaks color-encoding of the foreground
  # for the rest of the powerline.
  zstyle ':vcs_info:svn*:*' formats "$prefix%c%u"
  zstyle ':vcs_info:svn*:*' actionformats "$prefix%c%u %F{$_POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND}| %a%f"

  if (( _POWERLEVEL9K_SHOW_CHANGESET )); then
    zstyle ':vcs_info:*' get-revision true
  else
    zstyle ':vcs_info:*' get-revision false
  fi
}

function _p9k_vcs_status_save() {
  local z=$'\0'
  _p9k__gitstatus_last[${${_p9k__git_dir:+GIT_DIR:$_p9k__git_dir}:-$VCS_STATUS_WORKDIR}]=\
$VCS_STATUS_COMMIT$z$VCS_STATUS_LOCAL_BRANCH$z$VCS_STATUS_REMOTE_BRANCH$z$VCS_STATUS_REMOTE_NAME$z\
$VCS_STATUS_REMOTE_URL$z$VCS_STATUS_ACTION$z$VCS_STATUS_INDEX_SIZE$z$VCS_STATUS_NUM_STAGED$z\
$VCS_STATUS_NUM_UNSTAGED$z$VCS_STATUS_NUM_CONFLICTED$z$VCS_STATUS_NUM_UNTRACKED$z\
$VCS_STATUS_HAS_STAGED$z$VCS_STATUS_HAS_UNSTAGED$z$VCS_STATUS_HAS_CONFLICTED$z\
$VCS_STATUS_HAS_UNTRACKED$z$VCS_STATUS_COMMITS_AHEAD$z$VCS_STATUS_COMMITS_BEHIND$z\
$VCS_STATUS_STASHES$z$VCS_STATUS_TAG$z$VCS_STATUS_NUM_UNSTAGED_DELETED$z\
$VCS_STATUS_NUM_STAGED_NEW$z$VCS_STATUS_NUM_STAGED_DELETED$z$VCS_STATUS_PUSH_REMOTE_NAME$z\
$VCS_STATUS_PUSH_REMOTE_URL$z$VCS_STATUS_PUSH_COMMITS_AHEAD$z$VCS_STATUS_PUSH_COMMITS_BEHIND$z\
$VCS_STATUS_NUM_SKIP_WORKTREE$z$VCS_STATUS_NUM_ASSUME_UNCHANGED
}

function _p9k_vcs_status_restore() {
  for VCS_STATUS_COMMIT VCS_STATUS_LOCAL_BRANCH VCS_STATUS_REMOTE_BRANCH VCS_STATUS_REMOTE_NAME   \
      VCS_STATUS_REMOTE_URL VCS_STATUS_ACTION VCS_STATUS_INDEX_SIZE VCS_STATUS_NUM_STAGED         \
      VCS_STATUS_NUM_UNSTAGED VCS_STATUS_NUM_CONFLICTED VCS_STATUS_NUM_UNTRACKED                  \
      VCS_STATUS_HAS_STAGED VCS_STATUS_HAS_UNSTAGED VCS_STATUS_HAS_CONFLICTED                     \
      VCS_STATUS_HAS_UNTRACKED VCS_STATUS_COMMITS_AHEAD VCS_STATUS_COMMITS_BEHIND                 \
      VCS_STATUS_STASHES VCS_STATUS_TAG VCS_STATUS_NUM_UNSTAGED_DELETED VCS_STATUS_NUM_STAGED_NEW \
      VCS_STATUS_NUM_STAGED_DELETED VCS_STATUS_PUSH_REMOTE_NAME VCS_STATUS_PUSH_REMOTE_URL        \
      VCS_STATUS_PUSH_COMMITS_AHEAD VCS_STATUS_PUSH_COMMITS_BEHIND VCS_STATUS_NUM_SKIP_WORKTREE   \
      VCS_STATUS_NUM_ASSUME_UNCHANGED
      in "${(@0)1}"; do done
}

function _p9k_vcs_status_for_dir() {
  if [[ -n $GIT_DIR ]]; then
    _p9k__ret=$_p9k__gitstatus_last[GIT_DIR:$GIT_DIR]
    [[ -n $_p9k__ret ]]
  else
    local dir=$_p9k__cwd_a
    while true; do
      _p9k__ret=$_p9k__gitstatus_last[$dir]
      [[ -n $_p9k__ret ]] && return 0
      [[ $dir == (/|.) ]] && return 1
      dir=${dir:h}
    done
  fi
}

function _p9k_vcs_status_purge() {
  if [[ -n $_p9k__git_dir ]]; then
    _p9k__gitstatus_last[GIT_DIR:$_p9k__git_dir]=""
  else
    local dir=$1
    while true; do
      # unset doesn't work if $dir contains weird shit
      _p9k__gitstatus_last[$dir]=""
      _p9k_git_slow[$dir]=""
      [[ $dir == (/|.) ]] && break
      dir=${dir:h}
    done
  fi
}

function _p9k_vcs_icon() {
  case "$VCS_STATUS_REMOTE_URL" in
    *github*)    _p9k__ret=VCS_GIT_GITHUB_ICON;;
    *bitbucket*) _p9k__ret=VCS_GIT_BITBUCKET_ICON;;
    *stash*)     _p9k__ret=VCS_GIT_BITBUCKET_ICON;;
    *gitlab*)    _p9k__ret=VCS_GIT_GITLAB_ICON;;
    *)           _p9k__ret=VCS_GIT_ICON;;
  esac
}

function _p9k_vcs_render() {
  local state

  if (( $+_p9k__gitstatus_next_dir )); then
    if _p9k_vcs_status_for_dir; then
      _p9k_vcs_status_restore $_p9k__ret
      state=LOADING
    else
      _p9k_prompt_segment prompt_vcs_LOADING "${__p9k_vcs_states[LOADING]}" "$_p9k_color1" VCS_LOADING_ICON 0 '' "$_POWERLEVEL9K_VCS_LOADING_TEXT"
      return 0
    fi
  elif [[ $VCS_STATUS_RESULT != ok-* ]]; then
    return 1
  fi

  if (( _POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING )); then
    if [[ -z $state ]]; then
      if [[ $VCS_STATUS_HAS_CONFLICTED == 1 && $_POWERLEVEL9K_VCS_CONFLICTED_STATE == 1 ]]; then
        state=CONFLICTED
      elif [[ $VCS_STATUS_HAS_STAGED != 0 || $VCS_STATUS_HAS_UNSTAGED != 0 ]]; then
        state=MODIFIED
      elif [[ $VCS_STATUS_HAS_UNTRACKED != 0 ]]; then
        state=UNTRACKED
      else
        state=CLEAN
      fi
    fi
    _p9k_vcs_icon
    _p9k_prompt_segment prompt_vcs_$state "${__p9k_vcs_states[$state]}" "$_p9k_color1" "$_p9k__ret" 0 '' ""
    return 0
  fi

  (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)git-untracked]} )) || VCS_STATUS_HAS_UNTRACKED=0
  (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)git-aheadbehind]} )) || { VCS_STATUS_COMMITS_AHEAD=0 && VCS_STATUS_COMMITS_BEHIND=0 }
  (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)git-stash]} )) || VCS_STATUS_STASHES=0
  (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)git-remotebranch]} )) || VCS_STATUS_REMOTE_BRANCH=""
  (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)git-tagname]} )) || VCS_STATUS_TAG=""

  (( _POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM >= 0 && VCS_STATUS_COMMITS_AHEAD > _POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM )) &&
    VCS_STATUS_COMMITS_AHEAD=$_POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM

  (( _POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM >= 0 && VCS_STATUS_COMMITS_BEHIND > _POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM )) &&
    VCS_STATUS_COMMITS_BEHIND=$_POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM

  local -a cache_key=(
    "$VCS_STATUS_LOCAL_BRANCH"
    "$VCS_STATUS_REMOTE_BRANCH"
    "$VCS_STATUS_REMOTE_URL"
    "$VCS_STATUS_ACTION"
    "$VCS_STATUS_NUM_STAGED"
    "$VCS_STATUS_NUM_UNSTAGED"
    "$VCS_STATUS_NUM_UNTRACKED"
    "$VCS_STATUS_HAS_CONFLICTED"
    "$VCS_STATUS_HAS_STAGED"
    "$VCS_STATUS_HAS_UNSTAGED"
    "$VCS_STATUS_HAS_UNTRACKED"
    "$VCS_STATUS_COMMITS_AHEAD"
    "$VCS_STATUS_COMMITS_BEHIND"
    "$VCS_STATUS_STASHES"
    "$VCS_STATUS_TAG"
    "$VCS_STATUS_NUM_UNSTAGED_DELETED"
  )
  if [[ $_POWERLEVEL9K_SHOW_CHANGESET == 1 || -z $VCS_STATUS_LOCAL_BRANCH ]]; then
    cache_key+=$VCS_STATUS_COMMIT
  fi

  if ! _p9k_cache_ephemeral_get "$state" "${(@)cache_key}"; then
    local icon
    local content

    if (( ${_POWERLEVEL9K_VCS_GIT_HOOKS[(I)vcs-detect-changes]} )); then
      if [[ $VCS_STATUS_HAS_CONFLICTED == 1 && $_POWERLEVEL9K_VCS_CONFLICTED_STATE == 1 ]]; then
        : ${state:=CONFLICTED}
      elif [[ $VCS_STATUS_HAS_STAGED != 0 || $VCS_STATUS_HAS_UNSTAGED != 0 ]]; then
        : ${state:=MODIFIED}
      elif [[ $VCS_STATUS_HAS_UNTRACKED != 0 ]]; then
        : ${state:=UNTRACKED}
      fi

      # It's weird that removing vcs-detect-changes from POWERLEVEL9K_VCS_GIT_HOOKS gets rid
      # of the GIT icon. That's what vcs_info does, so we do the same in the name of compatiblity.
      _p9k_vcs_icon
      icon=$_p9k__ret
    fi

    : ${state:=CLEAN}

    function _$0_fmt() {
      _p9k_vcs_style $state $1
      content+="$_p9k__ret$2"
    }

    local ws
    if [[ $_POWERLEVEL9K_SHOW_CHANGESET == 1 || -z $VCS_STATUS_LOCAL_BRANCH ]]; then
      _p9k_get_icon prompt_vcs_$state VCS_COMMIT_ICON
      _$0_fmt COMMIT "$_p9k__ret${${VCS_STATUS_COMMIT:0:$_POWERLEVEL9K_CHANGESET_HASH_LENGTH}:-HEAD}"
      ws=' '
    fi

    if [[ -n $VCS_STATUS_LOCAL_BRANCH ]]; then
      local branch=$ws
      if (( !_POWERLEVEL9K_HIDE_BRANCH_ICON )); then
        _p9k_get_icon prompt_vcs_$state VCS_BRANCH_ICON
        branch+=$_p9k__ret
      fi
      if (( $+_POWERLEVEL9K_VCS_SHORTEN_LENGTH && $+_POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH &&
            $#VCS_STATUS_LOCAL_BRANCH > _POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH &&
            $#VCS_STATUS_LOCAL_BRANCH > _POWERLEVEL9K_VCS_SHORTEN_LENGTH )) &&
         [[ $_POWERLEVEL9K_VCS_SHORTEN_STRATEGY == (truncate_middle|truncate_from_right) ]]; then
        branch+=${VCS_STATUS_LOCAL_BRANCH[1,_POWERLEVEL9K_VCS_SHORTEN_LENGTH]//\%/%%}${_POWERLEVEL9K_VCS_SHORTEN_DELIMITER}
        if [[ $_POWERLEVEL9K_VCS_SHORTEN_STRATEGY == truncate_middle ]]; then
          _p9k_vcs_style $state BRANCH
          branch+=${_p9k__ret}${VCS_STATUS_LOCAL_BRANCH[-_POWERLEVEL9K_VCS_SHORTEN_LENGTH,-1]//\%/%%}
        fi
      else
        branch+=${VCS_STATUS_LOCAL_BRANCH//\%/%%}
      fi
      _$0_fmt BRANCH $branch
    fi

    if [[ $_POWERLEVEL9K_VCS_HIDE_TAGS == 0 && -n $VCS_STATUS_TAG ]]; then
      _p9k_get_icon prompt_vcs_$state VCS_TAG_ICON
      _$0_fmt TAG " $_p9k__ret${VCS_STATUS_TAG//\%/%%}"
    fi

    if [[ -n $VCS_STATUS_ACTION ]]; then
      _$0_fmt ACTION " | ${VCS_STATUS_ACTION//\%/%%}"
    else
      if [[ -n $VCS_STATUS_REMOTE_BRANCH &&
            $VCS_STATUS_LOCAL_BRANCH != $VCS_STATUS_REMOTE_BRANCH ]]; then
        _p9k_get_icon prompt_vcs_$state VCS_REMOTE_BRANCH_ICON
        _$0_fmt REMOTE_BRANCH " $_p9k__ret${VCS_STATUS_REMOTE_BRANCH//\%/%%}"
      fi
      if [[ $VCS_STATUS_HAS_STAGED == 1 || $VCS_STATUS_HAS_UNSTAGED == 1 || $VCS_STATUS_HAS_UNTRACKED == 1 ]]; then
        _p9k_get_icon prompt_vcs_$state VCS_DIRTY_ICON
        _$0_fmt DIRTY "$_p9k__ret"
        if [[ $VCS_STATUS_HAS_STAGED == 1 ]]; then
          _p9k_get_icon prompt_vcs_$state VCS_STAGED_ICON
          (( _POWERLEVEL9K_VCS_STAGED_MAX_NUM != 1 )) && _p9k__ret+=$VCS_STATUS_NUM_STAGED
          _$0_fmt STAGED " $_p9k__ret"
        fi
        if [[ $VCS_STATUS_HAS_UNSTAGED == 1 ]]; then
          _p9k_get_icon prompt_vcs_$state VCS_UNSTAGED_ICON
          (( _POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM != 1 )) && _p9k__ret+=$VCS_STATUS_NUM_UNSTAGED
          _$0_fmt UNSTAGED " $_p9k__ret"
        fi
        if [[ $VCS_STATUS_HAS_UNTRACKED == 1 ]]; then
          _p9k_get_icon prompt_vcs_$state VCS_UNTRACKED_ICON
          (( _POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM != 1 )) && _p9k__ret+=$VCS_STATUS_NUM_UNTRACKED
          _$0_fmt UNTRACKED " $_p9k__ret"
        fi
      fi
      if [[ $VCS_STATUS_COMMITS_BEHIND -gt 0 ]]; then
        _p9k_get_icon prompt_vcs_$state VCS_INCOMING_CHANGES_ICON
        (( _POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM != 1 )) && _p9k__ret+=$VCS_STATUS_COMMITS_BEHIND
        _$0_fmt INCOMING_CHANGES " $_p9k__ret"
      fi
      if [[ $VCS_STATUS_COMMITS_AHEAD -gt 0 ]]; then
        _p9k_get_icon prompt_vcs_$state VCS_OUTGOING_CHANGES_ICON
        (( _POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM != 1 )) && _p9k__ret+=$VCS_STATUS_COMMITS_AHEAD
        _$0_fmt OUTGOING_CHANGES " $_p9k__ret"
      fi
      if [[ $VCS_STATUS_STASHES -gt 0 ]]; then
        _p9k_get_icon prompt_vcs_$state VCS_STASH_ICON
        _$0_fmt STASH " $_p9k__ret$VCS_STATUS_STASHES"
      fi
    fi

    _p9k_cache_ephemeral_set "prompt_vcs_$state" "${__p9k_vcs_states[$state]}" "$_p9k_color1" "$icon" 0 '' "$content"
  fi

  _p9k_prompt_segment "$_p9k__cache_val[@]"
  return 0
}

function _p9k_maybe_ignore_git_repo() {
  if [[ $VCS_STATUS_RESULT == ok-* && $VCS_STATUS_WORKDIR == $~_POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN ]]; then
    VCS_STATUS_RESULT=norepo${VCS_STATUS_RESULT#ok}
  fi
}

function _p9k_vcs_resume() {
  eval "$__p9k_intro"

  _p9k_maybe_ignore_git_repo

  if [[ $VCS_STATUS_RESULT == ok-async ]]; then
    local latency=$((EPOCHREALTIME - _p9k__gitstatus_start_time))
    if (( latency > _POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS )); then
      _p9k_git_slow[${${_p9k__git_dir:+GIT_DIR:$_p9k__git_dir}:-$VCS_STATUS_WORKDIR}]=1
    elif (( $1 && latency < 0.8 * _POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS )); then  # 0.8 to avoid flip-flopping
      _p9k_git_slow[${${_p9k__git_dir:+GIT_DIR:$_p9k__git_dir}:-$VCS_STATUS_WORKDIR}]=0
    fi
    _p9k_vcs_status_save
  fi

  if [[ -z $_p9k__gitstatus_next_dir ]]; then
    unset _p9k__gitstatus_next_dir
    case $VCS_STATUS_RESULT in
      norepo-async) (( $1 )) && _p9k_vcs_status_purge $_p9k__cwd_a;;
      ok-async) (( $1 )) || _p9k__gitstatus_next_dir=$_p9k__cwd_a;;
    esac
  fi

  if [[ -n $_p9k__gitstatus_next_dir ]]; then
    _p9k__git_dir=$GIT_DIR
    if ! gitstatus_query_p9k_ -d $_p9k__gitstatus_next_dir -t 0 -c '_p9k_vcs_resume 1' POWERLEVEL9K; then
      unset _p9k__gitstatus_next_dir
      unset VCS_STATUS_RESULT
    else
      _p9k_maybe_ignore_git_repo
      case $VCS_STATUS_RESULT in
        tout) _p9k__gitstatus_next_dir=''; _p9k__gitstatus_start_time=$EPOCHREALTIME;;
        norepo-sync) _p9k_vcs_status_purge $_p9k__gitstatus_next_dir; unset _p9k__gitstatus_next_dir;;
        ok-sync) _p9k_vcs_status_save; unset _p9k__gitstatus_next_dir;;
      esac
    fi
  fi

  if (( _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
    local _p9k__prompt _p9k__prompt_side=$_p9k_vcs_side _p9k__segment_name=vcs
    local -i _p9k__has_upglob _p9k__segment_index=_p9k_vcs_index _p9k__line_index=_p9k_vcs_line_index
    _p9k_vcs_render
    typeset -g _p9k__vcs=$_p9k__prompt
  else
    _p9k__refresh_reason=gitstatus
    _p9k_set_prompt
    _p9k__refresh_reason=''
  fi
  _p9k_reset_prompt
}

function _p9k_vcs_gitstatus() {
  if [[ $_p9k__refresh_reason == precmd ]] && (( !_p9k__vcs_called )); then
    typeset -gi _p9k__vcs_called=1
    if (( $+_p9k__gitstatus_next_dir )); then
      _p9k__gitstatus_next_dir=$_p9k__cwd_a
    else
      local -F timeout=_POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS
      if ! _p9k_vcs_status_for_dir; then
        _p9k__git_dir=$GIT_DIR
        gitstatus_query_p9k_ -d $_p9k__cwd_a -t $timeout -p -c '_p9k_vcs_resume 0' POWERLEVEL9K || return 1
        _p9k_maybe_ignore_git_repo
        case $VCS_STATUS_RESULT in
          tout) _p9k__gitstatus_next_dir=''; _p9k__gitstatus_start_time=$EPOCHREALTIME; return 0;;
          norepo-sync) return 0;;
          ok-sync) _p9k_vcs_status_save;;
        esac
      else
        if [[ -n $GIT_DIR ]]; then
          [[ $_p9k_git_slow[GIT_DIR:$GIT_DIR] == 1 ]] && timeout=0
        else
          local dir=$_p9k__cwd_a
          while true; do
            case $_p9k_git_slow[$dir] in
              "") [[ $dir == (/|.) ]] && break; dir=${dir:h};;
              0) break;;
              1) timeout=0; break;;
            esac
          done
        fi
      fi
      (( _p9k__prompt_idx == 1 )) && timeout=0
      _p9k__git_dir=$GIT_DIR
      if (( _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
        if ! gitstatus_query_p9k_ -d $_p9k__cwd_a -t 0 -c '_p9k_vcs_resume 1' POWERLEVEL9K; then
          unset VCS_STATUS_RESULT
          return 1
        fi
        typeset -gF _p9k__vcs_timeout=timeout
        _p9k__gitstatus_next_dir=''
        _p9k__gitstatus_start_time=$EPOCHREALTIME
        return 0
      fi
      if ! gitstatus_query_p9k_ -d $_p9k__cwd_a -t $timeout -c '_p9k_vcs_resume 1' POWERLEVEL9K; then
        unset VCS_STATUS_RESULT
        return 1
      fi
      _p9k_maybe_ignore_git_repo
      case $VCS_STATUS_RESULT in
        tout) _p9k__gitstatus_next_dir=''; _p9k__gitstatus_start_time=$EPOCHREALTIME;;
        norepo-sync) _p9k_vcs_status_purge $_p9k__cwd_a;;
        ok-sync) _p9k_vcs_status_save;;
      esac
    fi
  fi
  return 0
}

################################################################
# Segment to show VCS information

prompt_vcs() {
  if (( _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
    _p9k__prompt+='${(e)_p9k__vcs}'
    return
  fi

  local -a backends=($_POWERLEVEL9K_VCS_BACKENDS)
  if (( ${backends[(I)git]} && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )) && _p9k_vcs_gitstatus; then
    _p9k_vcs_render && return
    backends=(${backends:#git})
  fi
  if (( $#backends )); then
    VCS_WORKDIR_DIRTY=false
    VCS_WORKDIR_HALF_DIRTY=false
    local current_state=""
    # Actually invoke vcs_info manually to gather all information.
    zstyle ':vcs_info:*' enable ${backends}
    vcs_info
    local vcs_prompt="${vcs_info_msg_0_}"
    if [[ -n "$vcs_prompt" ]]; then
      if [[ "$VCS_WORKDIR_DIRTY" == true ]]; then
        # $vcs_visual_identifier gets set in +vi-vcs-detect-changes in functions/vcs.zsh,
        # as we have there access to vcs_info internal hooks.
        current_state='MODIFIED'
      else
        if [[ "$VCS_WORKDIR_HALF_DIRTY" == true ]]; then
          current_state='UNTRACKED'
        else
          current_state='CLEAN'
        fi
      fi
      _p9k_prompt_segment "${0}_${${(U)current_state}//İ/I}" "${__p9k_vcs_states[$current_state]}" "$_p9k_color1" "$vcs_visual_identifier" 0 '' "$vcs_prompt"
    fi
  fi
}

################################################################
# Vi Mode: show editing mode (NORMAL|INSERT|VISUAL)
prompt_vi_mode() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  if (( __p9k_sh_glob )); then
    if (( $+_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING )); then
      if [[ -n $_POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then
        _p9k_prompt_segment $0_INSERT "$_p9k_color1" blue '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*overwrite*}}' "$_POWERLEVEL9K_VI_INSERT_MODE_STRING"
      fi
      _p9k_prompt_segment $0_OVERWRITE "$_p9k_color1" blue '' 0 '${${${${${${:-$_p9k__keymap.$_p9k__zle_state}:#vicmd.*}:#vivis.*}:#vivli.*}:#*.*insert*}}' "$_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING"
    else
      if [[ -n $_POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then
        _p9k_prompt_segment $0_INSERT "$_p9k_color1" blue '' 0 '${${${${_p9k__keymap:#vicmd}:#vivis}:#vivli}}' "$_POWERLEVEL9K_VI_INSERT_MODE_STRING"
      fi
    fi

    if (( $+_POWERLEVEL9K_VI_VISUAL_MODE_STRING )); then
      _p9k_prompt_segment $0_NORMAL "$_p9k_color1" white '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' "$_POWERLEVEL9K_VI_COMMAND_MODE_STRING"
      _p9k_prompt_segment $0_VISUAL "$_p9k_color1" white '' 0 '${$((! ${#${${${${:-$_p9k__keymap$_p9k__region_active}:#vicmd1}:#vivis?}:#vivli?}})):#0}' "$_POWERLEVEL9K_VI_VISUAL_MODE_STRING"
    else
      _p9k_prompt_segment $0_NORMAL "$_p9k_color1" white '' 0 '${$((! ${#${${${_p9k__keymap:#vicmd}:#vivis}:#vivli}})):#0}' "$_POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    fi
  else
    if (( $+_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING )); then
      if [[ -n $_POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then
        _p9k_prompt_segment $0_INSERT "$_p9k_color1" blue '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*overwrite*)}' "$_POWERLEVEL9K_VI_INSERT_MODE_STRING"
      fi
      _p9k_prompt_segment $0_OVERWRITE "$_p9k_color1" blue '' 0 '${${:-$_p9k__keymap.$_p9k__zle_state}:#(vicmd.*|vivis.*|vivli.*|*.*insert*)}' "$_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING"
    else
      if [[ -n $_POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then
        _p9k_prompt_segment $0_INSERT "$_p9k_color1" blue '' 0 '${_p9k__keymap:#(vicmd|vivis|vivli)}' "$_POWERLEVEL9K_VI_INSERT_MODE_STRING"
      fi
    fi

    if (( $+_POWERLEVEL9K_VI_VISUAL_MODE_STRING )); then
      _p9k_prompt_segment $0_NORMAL "$_p9k_color1" white '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#vicmd0}' "$_POWERLEVEL9K_VI_COMMAND_MODE_STRING"
      _p9k_prompt_segment $0_VISUAL "$_p9k_color1" white '' 0 '${(M)${:-$_p9k__keymap$_p9k__region_active}:#(vicmd1|vivis?|vivli?)}' "$_POWERLEVEL9K_VI_VISUAL_MODE_STRING"
    else
      _p9k_prompt_segment $0_NORMAL "$_p9k_color1" white '' 0 '${(M)_p9k__keymap:#(vicmd|vivis|vivli)}' "$_POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    fi
  fi
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

instant_prompt_vi_mode() {
  if [[ -n $_POWERLEVEL9K_VI_INSERT_MODE_STRING ]]; then
    _p9k_prompt_segment prompt_vi_mode_INSERT "$_p9k_color1" blue '' 0 '' "$_POWERLEVEL9K_VI_INSERT_MODE_STRING"
  fi
}

################################################################
# Virtualenv: current working virtualenv
# More information on virtualenv (Python):
# https://virtualenv.pypa.io/en/latest/
prompt_virtualenv() {
  local msg=''
  if (( _POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION )) && _p9k_python_version; then
    msg="${_p9k__ret//\%/%%} "
  fi
  local v=${VIRTUAL_ENV:t}
  if [[ $VIRTUAL_ENV_PROMPT == '('?*') ' && $VIRTUAL_ENV_PROMPT != "($v) " ]]; then
    v=$VIRTUAL_ENV_PROMPT[2,-3]
  elif [[ $v == $~_POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES ]]; then
    v=${VIRTUAL_ENV:h:t}
  fi
  msg+="$_POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER${v//\%/%%}$_POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER"
  case $_POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV in
    false)
      _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '${(M)${#P9K_PYENV_PYTHON_VERSION}:#0}' "$msg"
    ;;
    if-different)
      _p9k_escape $v
      _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '${${:-'$_p9k__ret'}:#$_p9k__pyenv_version}' "$msg"
    ;;
    *)
      _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '' "$msg"
    ;;
  esac
}

_p9k_prompt_virtualenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$VIRTUAL_ENV'
}

# _p9k_read_pyenv_like_version_file <filepath> [prefix]
function _p9k_read_pyenv_like_version_file() {
  local -a stat
  zstat -A stat +mtime -- $1 2>/dev/null || stat=(-1)
  local cached=$_p9k__read_pyenv_like_version_file_cache[$1:$2]
  if [[ $cached == $stat[1]:* ]]; then
    _p9k__ret=${cached#*:}
  else
    local fd content
    {
      { sysopen -r -u fd -- $1 && sysread -i $fd -s 1024 content } 2>/dev/null
    } always {
      [[ -n $fd ]] && exec {fd}>&-
    }
    local MATCH
    local versions=(${${${${(f)content}/(#m)*/${MATCH[(w)1]}}##\#*}#$2})
    _p9k__ret=${(j.:.)versions}
    _p9k__read_pyenv_like_version_file_cache[$1:$2]=$stat[1]:$_p9k__ret
  fi
  [[ -n $_p9k__ret ]]
}

function _p9k_pyenv_global_version() {
  _p9k_read_pyenv_like_version_file ${PYENV_ROOT:-$HOME/.pyenv}/version python- || _p9k__ret=system
}

function _p9k_pyenv_compute() {
  unset P9K_PYENV_PYTHON_VERSION _p9k__pyenv_version

  local v=${(j.:.)${(@)${(s.:.)PYENV_VERSION}#python-}}
  if [[ -n $v ]]; then
    (( ${_POWERLEVEL9K_PYENV_SOURCES[(I)shell]} )) || return
  else
    (( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $PYENV_DIR != (|.) ]]; then
      [[ $PYENV_DIR == /* ]] && local dir=$PYENV_DIR || local dir="$_p9k__cwd_a/$PYENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_pyenv_like_version_file $dir/.python-version python-; then
            (( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .python-version
      local -i idx=$?
      if (( idx )) && _p9k_read_pyenv_like_version_file $_p9k__parent_dirs[idx]/.python-version python-; then
        (( ${_POWERLEVEL9K_PYENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_PYENV_SOURCES[(I)global]} )) || return
      _p9k_pyenv_global_version
    fi
    v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_pyenv_global_version
    [[ $v == $_p9k__ret ]] && return 1
  fi

  if (( !_POWERLEVEL9K_PYENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return 1
  fi

  local versions=${PYENV_ROOT:-$HOME/.pyenv}/versions
  versions=${versions:A}
  local name version
  for name in ${(s.:.)v}; do
    version=$versions/$name
    version=${version:A}
    if [[ $version(#qN/) == (#b)$versions/([^/]##)* ]]; then
      typeset -g P9K_PYENV_PYTHON_VERSION=$match[1]
      break
    fi
  done

  typeset -g _p9k__pyenv_version=$v
}

################################################################
# Segment to display pyenv information
# https://github.com/pyenv/pyenv#choosing-the-python-version
prompt_pyenv() {
  _p9k_pyenv_compute || return
  _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'PYTHON_ICON' 0 '' "${_p9k__pyenv_version//\%/%%}"
}

_p9k_prompt_pyenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[pyenv]:-${${+functions[pyenv]}:#0}}'
}

function _p9k_goenv_global_version() {
  _p9k_read_pyenv_like_version_file ${GOENV_ROOT:-$HOME/.goenv}/version go- || _p9k__ret=system
}

################################################################
# Segment to display goenv information: https://github.com/syndbg/goenv
prompt_goenv() {
  local v=${(j.:.)${(@)${(s.:.)GOENV_VERSION}#go-}}
  if [[ -n $v ]]; then
    (( ${_POWERLEVEL9K_GOENV_SOURCES[(I)shell]} )) || return
  else
    (( ${_POWERLEVEL9K_GOENV_SOURCES[(I)local|global]} )) || return
    _p9k__ret=
    if [[ $GOENV_DIR != (|.) ]]; then
      [[ $GOENV_DIR == /* ]] && local dir=$GOENV_DIR || local dir="$_p9k__cwd_a/$GOENV_DIR"
      dir=${dir:A}
      if [[ $dir != $_p9k__cwd_a ]]; then
        while true; do
          if _p9k_read_pyenv_like_version_file $dir/.go-version go-; then
            (( ${_POWERLEVEL9K_GOENV_SOURCES[(I)local]} )) || return
            break
          fi
          [[ $dir == (/|.) ]] && break
          dir=${dir:h}
        done
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      _p9k_upglob .go-version
      local -i idx=$?
      if (( idx )) && _p9k_read_pyenv_like_version_file $_p9k__parent_dirs[idx]/.go-version go-; then
        (( ${_POWERLEVEL9K_GOENV_SOURCES[(I)local]} )) || return
      else
        _p9k__ret=
      fi
    fi
    if [[ -z $_p9k__ret ]]; then
      (( _POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_GOENV_SOURCES[(I)global]} )) || return
      _p9k_goenv_global_version
    fi
    v=$_p9k__ret
  fi

  if (( !_POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW )); then
    _p9k_goenv_global_version
    [[ $v == $_p9k__ret ]] && return
  fi

  if (( !_POWERLEVEL9K_GOENV_SHOW_SYSTEM )); then
    [[ $v == system ]] && return
  fi

  _p9k_prompt_segment "$0" "blue" "$_p9k_color1" 'GO_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_goenv_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[goenv]:-${${+functions[goenv]}:#0}}'
}

################################################################
# Display openfoam information
prompt_openfoam() {
  if [[ -z "$WM_FORK" ]] ; then
    _p9k_prompt_segment "$0" "yellow" "$_p9k_color1" '' 0 '' "OF: ${${WM_PROJECT_VERSION:t}//\%/%%}"
  else
    _p9k_prompt_segment "$0" "yellow" "$_p9k_color1" '' 0 '' "F-X: ${${WM_PROJECT_VERSION:t}//\%/%%}"
  fi
}

_p9k_prompt_openfoam_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$WM_PROJECT_VERSION'
}

################################################################
# Segment to display Swift version
prompt_swift_version() {
  _p9k_cached_cmd 0 '' swift --version || return
  [[ $_p9k__ret == (#b)[^[:digit:]]#([[:digit:].]##)* ]] || return
  _p9k_prompt_segment "$0" "magenta" "white" 'SWIFT_ICON' 0 '' "${match[1]//\%/%%}"
}

_p9k_prompt_swift_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[swift]'
}

################################################################
# dir_writable: Display information about the user's permission to write in the current directory
prompt_dir_writable() {
  if [[ ! -w "$_p9k__cwd_a" ]]; then
    _p9k_prompt_segment "$0_FORBIDDEN" "red" "yellow1" 'LOCK_ICON' 0 '' ''
  fi
}

instant_prompt_dir_writable() { prompt_dir_writable; }

################################################################
# Kubernetes Current Context/Namespace
prompt_kubecontext() {
  if ! _p9k_cache_stat_get $0 ${(s.:.)${KUBECONFIG:-$HOME/.kube/config}}; then
    local name namespace cluster user cloud_name cloud_account cloud_zone cloud_cluster text state
    () {
      local cfg && cfg=(${(f)"$(kubectl config view -o=yaml 2>/dev/null)"}) || return
      local qstr='"*"'
      local str='([^"'\''|>]*|'$qstr')'
      local ctx=(${(@M)cfg:#current-context: $~str})
      (( $#ctx == 1 )) || return
      name=${ctx[1]#current-context: }
      local -i pos=${cfg[(i)contexts:]}
      {
        (( pos <= $#cfg )) || return
        shift $pos cfg
        pos=${cfg[(i)  name: ${(b)name}]}
        (( pos <= $#cfg )) || return
        (( --pos ))
        for ((; pos > 0; --pos)); do
          local line=$cfg[pos]
          if [[ $line == '- context:' ]]; then
            return 0
          elif [[ $line == (#b)'    cluster: '($~str) ]]; then
            cluster=$match[1]
            [[ $cluster == $~qstr ]] && cluster=$cluster[2,-2]
          elif [[ $line == (#b)'    namespace: '($~str) ]]; then
            namespace=$match[1]
            [[ $namespace == $~qstr ]] && namespace=$namespace[2,-2]
          elif [[ $line == (#b)'    user: '($~str) ]]; then
            user=$match[1]
            [[ $user == $~qstr ]] && user=$user[2,-2]
          fi
        done
      } always {
        [[ $name == $~qstr ]] && name=$name[2,-2]
      }
    }
    if [[ -n $name ]]; then
      : ${namespace:=default}
      # gke_my-account_us-east1-a_cluster-01
      # gke_my-account_us-east1_cluster-01
      if [[ $cluster == (#b)gke_(?*)_(asia|australia|europe|northamerica|southamerica|us)-([a-z]##<->)(-[a-z]|)_(?*) ]]; then
        cloud_name=gke
        cloud_account=$match[1]
        cloud_zone=$match[2]-$match[3]$match[4]
        cloud_cluster=$match[5]
        if (( ${_POWERLEVEL9K_KUBECONTEXT_SHORTEN[(I)gke]} )); then
          text=$cloud_cluster
        fi
      # arn:aws:eks:us-east-1:123456789012:cluster/cluster-01
      elif [[ $cluster == (#b)arn:aws:eks:([[:alnum:]-]##):([[:digit:]]##):cluster/(?*) ]]; then
        cloud_name=eks
        cloud_zone=$match[1]
        cloud_account=$match[2]
        cloud_cluster=$match[3]
        if (( ${_POWERLEVEL9K_KUBECONTEXT_SHORTEN[(I)eks]} )); then
          text=$cloud_cluster
        fi
      fi
      if [[ -z $text ]]; then
        text=$name
        if [[ $_POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE == 1 || $namespace != (default|$name) ]]; then
          text+="/$namespace"
        fi
      fi
      local pat class
      for pat class in "${_POWERLEVEL9K_KUBECONTEXT_CLASSES[@]}"; do
        if [[ $text == ${~pat} ]]; then
          [[ -n $class ]] && state=_${${(U)class}//İ/I}
          break
        fi
      done
    fi
    _p9k_cache_stat_set "${(g::)name}" "${(g::)namespace}" "${(g::)cluster}" "${(g::)user}" "${(g::)cloud_name}" "${(g::)cloud_account}" "${(g::)cloud_zone}" "${(g::)cloud_cluster}" "${(g::)text}" "$state"
  fi

  typeset -g P9K_KUBECONTEXT_NAME=$_p9k__cache_val[1]
  typeset -g P9K_KUBECONTEXT_NAMESPACE=$_p9k__cache_val[2]
  typeset -g P9K_KUBECONTEXT_CLUSTER=$_p9k__cache_val[3]
  typeset -g P9K_KUBECONTEXT_USER=$_p9k__cache_val[4]
  typeset -g P9K_KUBECONTEXT_CLOUD_NAME=$_p9k__cache_val[5]
  typeset -g P9K_KUBECONTEXT_CLOUD_ACCOUNT=$_p9k__cache_val[6]
  typeset -g P9K_KUBECONTEXT_CLOUD_ZONE=$_p9k__cache_val[7]
  typeset -g P9K_KUBECONTEXT_CLOUD_CLUSTER=$_p9k__cache_val[8]
  [[ -n $_p9k__cache_val[9] ]] || return
  _p9k_prompt_segment $0$_p9k__cache_val[10] magenta white KUBERNETES_ICON 0 '' "${_p9k__cache_val[9]//\%/%%}"
}

_p9k_prompt_kubecontext_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[kubectl]'
}

################################################################
# Dropbox status
prompt_dropbox() {
  # The first column is just the directory, so cut it
  local dropbox_status="$(dropbox-cli filestatus . | cut -d\  -f2-)"

  # Only show if the folder is tracked and dropbox is running
  if [[ "$dropbox_status" != 'unwatched' && "$dropbox_status" != "isn't running!" ]]; then
    # If "up to date", only show the icon
    if [[ "$dropbox_status" =~ 'up to date' ]]; then
      dropbox_status=""
    fi

    _p9k_prompt_segment "$0" "white" "blue" "DROPBOX_ICON" 0 '' "${dropbox_status//\%/%%}"
  fi
}

_p9k_prompt_dropbox_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[dropbox-cli]'
}

# print Java version number
prompt_java_version() {
  if (( _POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY )); then
    _p9k_upglob 'pom.xml|build.gradle.kts|build.sbt|deps.edn|project.clj|build.boot|*.(java|class|jar|gradle|clj|cljc)' && return
  fi

  local java=$commands[java]
  if ! _p9k_cache_stat_get $0 $java ${JAVA_HOME:+$JAVA_HOME/release}; then
    local v
    v="$(java -fullversion 2>&1)" || v=
    v=${${v#*\"}%\"*}
    (( _POWERLEVEL9K_JAVA_VERSION_FULL )) || v=${v%%-*}
    _p9k_cache_stat_set "${v//\%/%%}"
  fi

  [[ -n $_p9k__cache_val[1] ]] || return
  _p9k_prompt_segment "$0" "red" "white" "JAVA_ICON" 0 '' $_p9k__cache_val[1]
}

_p9k_prompt_java_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[java]'
}

prompt_azure() {
  local cfg=${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json
  if ! _p9k_cache_stat_get $0 $cfg; then
    local name
    if (( $+commands[jq] )) && name="$(jq -r '[.subscriptions[]|select(.isDefault==true)|.name][]|strings' $cfg 2>/dev/null)"; then
      name=${name%%$'\n'*}
    elif ! name="$(az account show --query name --output tsv 2>/dev/null)"; then
      name=
    fi
    _p9k_cache_stat_set "$name"
  fi
  local pat class state
  for pat class in "${_POWERLEVEL9K_AZURE_CLASSES[@]}"; do
    if [[ $name == ${~pat} ]]; then
      [[ -n $class ]] && state=_${${(U)class}//İ/I}
      break
    fi
  done
  [[ -n $_p9k__cache_val[1] ]] || return
  _p9k_prompt_segment "$0$state" "blue" "white" "AZURE_ICON" 0 '' "${_p9k__cache_val[1]//\%/%%}"
}

_p9k_prompt_azure_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[az]'
}

prompt_gcloud() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment                                                                    \
    $0_PARTIAL blue white GCLOUD_ICON 1                                                  \
    '${${(M)${#P9K_GCLOUD_PROJECT_NAME}:#0}:+$P9K_GCLOUD_ACCOUNT$P9K_GCLOUD_PROJECT_ID}' \
    '${P9K_GCLOUD_ACCOUNT//\%/%%}:${P9K_GCLOUD_PROJECT_ID//\%/%%}'
  _p9k_prompt_segment                                                                    \
    $0_COMPLETE blue white GCLOUD_ICON 1                                                 \
    '$P9K_GCLOUD_PROJECT_NAME'                                                           \
    '${P9K_GCLOUD_ACCOUNT//\%/%%}:${P9K_GCLOUD_PROJECT_ID//\%/%%}'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_gcloud_prefetch() {
  # P9K_GCLOUD_PROJECT is deprecated; it's always equal to P9K_GCLOUD_PROJECT_ID
  unset P9K_GCLOUD_CONFIGURATION P9K_GCLOUD_ACCOUNT P9K_GCLOUD_PROJECT P9K_GCLOUD_PROJECT_ID P9K_GCLOUD_PROJECT_NAME
  (( $+commands[gcloud] )) || return
  _p9k_read_word ${CLOUDSDK_CONFIG:-~/.config/gcloud}/active_config || return
  P9K_GCLOUD_CONFIGURATION=$_p9k__ret
  if ! _p9k_cache_stat_get $0 ${CLOUDSDK_CONFIG:-~/.config/gcloud}/configurations/config_$P9K_GCLOUD_CONFIGURATION; then
    local pair account project_id
    pair="$(gcloud config configurations describe $P9K_GCLOUD_CONFIGURATION \
      --format=$'value[separator="\1"](properties.core.account,properties.core.project)')"
    (( ! $? )) && IFS=$'\1' read account project_id <<<$pair
    _p9k_cache_stat_set "$account" "$project_id"
  fi
  if [[ -n $_p9k__cache_val[1] ]]; then
    P9K_GCLOUD_ACCOUNT=$_p9k__cache_val[1]
  fi
  if [[ -n $_p9k__cache_val[2] ]]; then
    P9K_GCLOUD_PROJECT_ID=$_p9k__cache_val[2]
    P9K_GCLOUD_PROJECT=$P9K_GCLOUD_PROJECT_ID  # deprecated parameter; set for backward compatibility
  fi
  if [[ $P9K_GCLOUD_CONFIGURATION == $_p9k_gcloud_configuration &&
        $P9K_GCLOUD_ACCOUNT == $_p9k_gcloud_account &&
        $P9K_GCLOUD_PROJECT_ID == $_p9k_gcloud_project_id ]]; then
    [[ -n $_p9k_gcloud_project_name ]] && P9K_GCLOUD_PROJECT_NAME=$_p9k_gcloud_project_name
    if (( _POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS < 0 ||
          _p9k__gcloud_last_fetch_ts + _POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS > EPOCHREALTIME )); then
      return
    fi
  else
    _p9k_gcloud_configuration=$P9K_GCLOUD_CONFIGURATION
    _p9k_gcloud_account=$P9K_GCLOUD_ACCOUNT
    _p9k_gcloud_project_id=$P9K_GCLOUD_PROJECT_ID
    _p9k_gcloud_project_name=
    _p9k__state_dump_scheduled=1
  fi
  [[ -n $P9K_GCLOUD_CONFIGURATION && -n $P9K_GCLOUD_ACCOUNT && -n $P9K_GCLOUD_PROJECT_ID ]] || return
  _p9k__gcloud_last_fetch_ts=EPOCHREALTIME
  _p9k_worker_invoke gcloud "_p9k_prompt_gcloud_compute ${(q)commands[gcloud]} ${(q)P9K_GCLOUD_CONFIGURATION} ${(q)P9K_GCLOUD_ACCOUNT} ${(q)P9K_GCLOUD_PROJECT_ID}"
}

_p9k_prompt_gcloud_init() {
  _p9k__async_segments_compute+=_p9k_gcloud_prefetch
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[gcloud]'
}

_p9k_prompt_gcloud_compute() {
  local gcloud=$1
  P9K_GCLOUD_CONFIGURATION=$2
  P9K_GCLOUD_ACCOUNT=$3
  P9K_GCLOUD_PROJECT_ID=$4
  _p9k_worker_async "_p9k_prompt_gcloud_async ${(q)gcloud}" _p9k_prompt_gcloud_sync
}

_p9k_prompt_gcloud_async() {
  local gcloud=$1
  $gcloud projects describe $P9K_GCLOUD_PROJECT_ID --configuration=$P9K_GCLOUD_CONFIGURATION \
    --account=$P9K_GCLOUD_ACCOUNT --format='value(name)'
}

_p9k_prompt_gcloud_sync() {
  _p9k_worker_reply "_p9k_prompt_gcloud_update ${(q)P9K_GCLOUD_CONFIGURATION} ${(q)P9K_GCLOUD_ACCOUNT} ${(q)P9K_GCLOUD_PROJECT_ID} ${(q)REPLY%$'\n'}"
}

_p9k_prompt_gcloud_update() {
  [[ $1 == $P9K_GCLOUD_CONFIGURATION &&
     $2 == $P9K_GCLOUD_ACCOUNT &&
     $3 == $P9K_GCLOUD_PROJECT_ID &&
     $4 != $P9K_GCLOUD_PROJECT_NAME ]] || return
  [[ -n $4 ]] && P9K_GCLOUD_PROJECT_NAME=$4 || unset P9K_GCLOUD_PROJECT_NAME
  _p9k_gcloud_project_name=$P9K_GCLOUD_PROJECT_NAME
  _p9k__state_dump_scheduled=1
  reset=1
}

prompt_google_app_cred() {
  unset P9K_GOOGLE_APP_CRED_{TYPE,PROJECT_ID,CLIENT_EMAIL}

  if ! _p9k_cache_stat_get $0 $GOOGLE_APPLICATION_CREDENTIALS; then
    local -a lines
    local q='[.type//"", .project_id//"", .client_email//"", 0][]'
    if lines=("${(@f)$(jq -r $q <$GOOGLE_APPLICATION_CREDENTIALS 2>/dev/null)}") && (( $#lines == 4 )); then
      local text="${(j.:.)lines[1,-2]}"
      local pat class state
      for pat class in "${_POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES[@]}"; do
        if [[ $text == ${~pat} ]]; then
          [[ -n $class ]] && state=_${${(U)class}//İ/I}
          break
        fi
      done
      _p9k_cache_stat_set 1 "${(@)lines[1,-2]}" "$text" "$state"
    else
      _p9k_cache_stat_set 0
    fi
  fi

  (( _p9k__cache_val[1] )) || return
  P9K_GOOGLE_APP_CRED_TYPE=$_p9k__cache_val[2]
  P9K_GOOGLE_APP_CRED_PROJECT_ID=$_p9k__cache_val[3]
  P9K_GOOGLE_APP_CRED_CLIENT_EMAIL=$_p9k__cache_val[4]
  _p9k_prompt_segment "$0$_p9k__cache_val[6]" "blue" "white" "GCLOUD_ICON" 0 '' "$_p9k__cache_val[5]"
}

_p9k_prompt_google_app_cred_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${GOOGLE_APPLICATION_CREDENTIALS:+$commands[jq]}'
}

typeset -gra __p9k_nordvpn_tag=(
  P9K_NORDVPN_STATUS
  P9K_NORDVPN_TECHNOLOGY
  P9K_NORDVPN_PROTOCOL
  P9K_NORDVPN_IP_ADDRESS
  P9K_NORDVPN_SERVER
  P9K_NORDVPN_COUNTRY
  P9K_NORDVPN_CITY
)

function _p9k_fetch_nordvpn_status() {
  setopt err_return no_multi_byte
  local REPLY
  zsocket /run/nordvpn/nordvpnd.sock
  local -i fd=REPLY
  {
    print -nu $fd 'PRI * HTTP/2.0\r\n\r\nSM\r\n\r\n\0\0\0\4\1\0\0\0\0\0\0;\1\4\0\0\0\1\203\206E\213b\270\327\2762\322z\230\326j\246A\206\240\344\35\23\235\t_\213\35u\320b\r&=LMedz\212\232\312\310\264\307`+\262\332\340@\2te\206M\2035\5\261\37\0\0\5\0\1\0\0\0\1\0\0\0\0\0\0\0\25\1\4\0\0\0\3\203\206E\215b\270\327\2762\322z\230\334\221\246\324\177\302\301\300\277\0\0\5\0\1\0\0\0\3\0\0\0\0\0'
    local val
    local -i len n wire tag
    {
      IFS='' read -t 0.25 -r val
      val=$'\n'
      while true; do
        tag=$((#val))
        wire='tag & 7'
        (( (tag >>= 3) && tag <= $#__p9k_nordvpn_tag )) || break
        if (( wire == 0 )); then
          # varint
          sysread -s 1 -t 0.25 val
          n=$((#val))
          (( n < 128 )) || break  # bail on multi-byte varints
          if (( tag == 2 )); then
            # P9K_NORDVPN_TECHNOLOGY
            case $n in
              1) typeset -g P9K_NORDVPN_TECHNOLOGY=OPENVPN;;
              2) typeset -g P9K_NORDVPN_TECHNOLOGY=NORDLYNX;;
              3) typeset -g P9K_NORDVPN_TECHNOLOGY=SKYLARK;;
              *) typeset -g P9K_NORDVPN_TECHNOLOGY=UNKNOWN;;
            esac
          elif (( tag == 3 )); then
            # P9K_NORDVPN_PROTOCOL
            case $n in
              1) typeset -g P9K_NORDVPN_PROTOCOL=UDP;;
              2) typeset -g P9K_NORDVPN_PROTOCOL=TCP;;
              *) typeset -g P9K_NORDVPN_PROTOCOL=UNKNOWN;;
            esac
          else
            break
          fi
        else
          # length-delimited
          (( wire == 2 )) || break
          (( tag != 2 && tag != 3 )) || break
          [[ -t $fd ]] || true  # https://www.zsh.org/mla/workers/2020/msg00207.html
          sysread -s 1 -t 0.25 val
          len=$((#val))
          val=
          while (( $#val < len )); do
            [[ -t $fd ]] || true  # https://www.zsh.org/mla/workers/2020/msg00207.html
            sysread -s $(( len - $#val )) -t 0.25 'val[$#val+1]'
          done
          typeset -g $__p9k_nordvpn_tag[tag]=$val
        fi
        [[ -t $fd ]] || true  # https://www.zsh.org/mla/workers/2020/msg00207.html
        sysread -s 1 -t 0.25 val
      done
    } <&$fd
  } always {
    exec {fd}>&-
  }
}

# Shows the state of NordVPN connection. Works only on Linux. Can be in the following 5 states.
#
# CONNECTED: NordVPN is connected. By default shows NORDVPN_ICON as icon and country code as
# content. In addition, the following variables are set for the use by
# POWERLEVEL9K_NORDVPN_CONNECTED_VISUAL_IDENTIFIER_EXPANSION and
# POWERLEVEL9K_NORDVPN_CONNECTED_CONTENT_EXPANSION:
#
#   - P9K_NORDVPN_STATUS
#   - P9K_NORDVPN_PROTOCOL
#   - P9K_NORDVPN_TECHNOLOGY
#   - P9K_NORDVPN_IP_ADDRESS
#   - P9K_NORDVPN_SERVER
#   - P9K_NORDVPN_COUNTRY
#   - P9K_NORDVPN_CITY
#   - P9K_NORDVPN_COUNTRY_CODE
#
# The last variable is trivially derived from P9K_NORDVPN_SERVER. The rest correspond to the output
# lines of `nordvpn status` command. Example of using these variables:
#
#   # Display the name of the city where VPN servers are located when connected to NordVPN.
#   POWERLEVEL9K_NORDVPN_CONNECTED_CONTENT_EXPANSION='${P9K_NORDVPN_CITY}'
#
# DISCONNECTED, CONNECTING, DISCONNECTING: NordVPN is disconnected/connecting/disconnecting. By
# default shows NORDVPN_ICON as icon and FAIL_ICON as content. In state CONNECTING the same
# P9K_NORDVPN_* variables are set as in CONNECTED. In states DISCONNECTED and DISCONNECTING only
# P9K_NORDVPN_STATUS is set. Example customizations:
#
#   # Hide NordVPN segment when disconnected (segments with no icon and no content are not shown).
#   POWERLEVEL9K_NORDVPN_DISCONNECTED_CONTENT_EXPANSION=
#   POWERLEVEL9K_NORDVPN_DISCONNECTED_VISUAL_IDENTIFIER_EXPANSION=
#
#   # When NordVPN is connecting, show country code on cyan background.
#   POWERLEVEL9K_NORDVPN_CONNECTING_CONTENT_EXPANSION='${P9K_NORDVPN_COUNTRY_CODE}'
#   POWERLEVEL9K_NORDVPN_CONNECTING_BACKGROUND=cyan
function prompt_nordvpn() {
  unset $__p9k_nordvpn_tag P9K_NORDVPN_COUNTRY_CODE
  [[ -e /run/nordvpn/nordvpnd.sock ]] || return
  _p9k_fetch_nordvpn_status 2>/dev/null || return
  if [[ $P9K_NORDVPN_SERVER == (#b)([[:alpha:]]##)[[:digit:]]##.nordvpn.com ]]; then
    typeset -g P9K_NORDVPN_COUNTRY_CODE=${${(U)match[1]}//İ/I}
  fi
  case $P9K_NORDVPN_STATUS in
    Connected)
      _p9k_prompt_segment $0_CONNECTED blue   white NORDVPN_ICON 0 '' "$P9K_NORDVPN_COUNTRY_CODE"
    ;;
    Disconnected|Connecting|Disconnecting)
      local state=${${(U)P9K_NORDVPN_STATUS}//İ/I}
      _p9k_get_icon $0_$state FAIL_ICON
      _p9k_prompt_segment $0_$state    yellow white NORDVPN_ICON 0 '' "$_p9k__ret"
    ;;
    *)
      return
    ;;
  esac
}

_p9k_prompt_nordvpn_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[nordvpn]'
}

function prompt_ranger() {
  _p9k_prompt_segment $0 $_p9k_color1 yellow RANGER_ICON 0 '' $RANGER_LEVEL
}

_p9k_prompt_ranger_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$RANGER_LEVEL'
}

function instant_prompt_ranger() {
  _p9k_prompt_segment prompt_ranger $_p9k_color1 yellow RANGER_ICON 1 '$RANGER_LEVEL' '$RANGER_LEVEL'
}

function prompt_midnight_commander() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 $_p9k_color1 yellow MIDNIGHT_COMMANDER_ICON 0 '' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_midnight_commander_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$MC_TMPDIR'
}

function instant_prompt_midnight_commander() {
  _p9k_prompt_segment prompt_midnight_commander $_p9k_color1 yellow MIDNIGHT_COMMANDER_ICON 0 '$MC_TMPDIR' ''
}

function prompt_nnn() {
  _p9k_prompt_segment $0 6 $_p9k_color1 NNN_ICON 0 '' $NNNLVL
}

_p9k_prompt_nnn_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${NNNLVL:#0}'
}

function instant_prompt_nnn() {
  _p9k_prompt_segment prompt_nnn 6 $_p9k_color1 NNN_ICON 1 '${NNNLVL:#0}' '$NNNLVL'
}

function prompt_xplr() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 6 $_p9k_color1 XPLR_ICON 0 '' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_xplr_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$XPLR_PID'
}

function instant_prompt_xplr() {
  _p9k_prompt_segment prompt_xplr 6 $_p9k_color1 XPLR_ICON 0 '$XPLR_PID' ''
}

function prompt_vim_shell() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 green $_p9k_color1 VIM_ICON 0 '' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_vim_shell_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$VIMRUNTIME'
}

function instant_prompt_vim_shell() {
  _p9k_prompt_segment prompt_vim_shell green $_p9k_color1 VIM_ICON 0 '$VIMRUNTIME' ''
}

function prompt_nix_shell() {
  _p9k_prompt_segment $0 4 $_p9k_color1 NIX_SHELL_ICON 0 '' "${(M)IN_NIX_SHELL:#(pure|impure)}"
}

_p9k_prompt_nix_shell_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${IN_NIX_SHELL:#0}'
}

function instant_prompt_nix_shell() {
  _p9k_prompt_segment prompt_nix_shell 4 $_p9k_color1 NIX_SHELL_ICON 1 '${IN_NIX_SHELL:#0}' '${(M)IN_NIX_SHELL:#(pure|impure)}'
}

function prompt_terraform() {
  local ws=$TF_WORKSPACE
  if [[ -z $TF_WORKSPACE ]]; then
    _p9k_read_word ${${TF_DATA_DIR:-.terraform}:A}/environment && ws=$_p9k__ret
  fi
  [[ -z $ws || $ws == default && $_POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT == 0 ]] && return
  local pat class state
  for pat class in "${_POWERLEVEL9K_TERRAFORM_CLASSES[@]}"; do
    if [[ $ws == ${~pat} ]]; then
      [[ -n $class ]] && state=_${${(U)class}//İ/I}
      break
    fi
  done
  _p9k_prompt_segment "$0$state" $_p9k_color1 blue TERRAFORM_ICON 0 '' $ws
}

_p9k_prompt_terraform_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[terraform]'
}

function prompt_terraform_version() {
  _p9k_cached_cmd 0 '' terraform --version || return
  local v=${_p9k__ret#Terraform v}
  (( $#v < $#_p9k__ret )) || return
  v=${v%%$'\n'*}
  [[ -n $v ]] || return
  _p9k_prompt_segment $0 $_p9k_color1 blue TERRAFORM_ICON 0 '' $v
}

_p9k_prompt_terraform_version_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[terraform]'
}

function prompt_proxy() {
  local -U p=(
    $all_proxy $http_proxy $https_proxy $ftp_proxy
    $ALL_PROXY $HTTP_PROXY $HTTPS_PROXY $FTP_PROXY)
  p=(${(@)${(@)${(@)p#*://}##*@}%%/*})
  (( $#p == 1 )) || p=("")
  _p9k_prompt_segment $0 $_p9k_color1 blue PROXY_ICON 0 '' "$p[1]"
}

_p9k_prompt_proxy_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$all_proxy$http_proxy$https_proxy$ftp_proxy$ALL_PROXY$HTTP_PROXY$HTTPS_PROXY$FTP_PROXY'
}

function prompt_direnv() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 $_p9k_color1 yellow DIRENV_ICON 0 '${DIRENV_DIR-}' ''
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_direnv_init() {
  # DIRENV_DIR is set in a precmd hook. If our hook isn't the last, DIRENV_DIR might
  # still get set before prompt is expanded.
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${DIRENV_DIR-${precmd_functions[-1]:#_p9k_precmd}}'
}

function instant_prompt_direnv() {
  if [[ -n ${DIRENV_DIR:-} && $precmd_functions[-1] == _p9k_precmd ]]; then
    _p9k_prompt_segment prompt_direnv $_p9k_color1 yellow DIRENV_ICON 0 '' ''
  fi
}

function _p9k_timewarrior_clear() {
  [[ -z $_p9k_timewarrior_dir ]] && return
  _p9k_timewarrior_dir=
  _p9k_timewarrior_dir_mtime=0
  _p9k_timewarrior_file_mtime=0
  _p9k_timewarrior_file_name=
  unset _p9k_timewarrior_tags
  _p9k__state_dump_scheduled=1
}

function prompt_timewarrior() {
  local -a stat
  local dir=${TIMEWARRIORDB:-~/.timewarrior}/data
  [[ $dir == $_p9k_timewarrior_dir ]] || _p9k_timewarrior_clear
  if [[ -n $_p9k_timewarrior_file_name ]]; then
    zstat -A stat +mtime -- $dir $_p9k_timewarrior_file_name 2>/dev/null || stat=()
    if [[ $stat[1] == $_p9k_timewarrior_dir_mtime && $stat[2] == $_p9k_timewarrior_file_mtime ]]; then
      if (( $+_p9k_timewarrior_tags )); then
        _p9k_prompt_segment $0 grey 255 TIMEWARRIOR_ICON 0 '' "${_p9k_timewarrior_tags//\%/%%}"
      fi
      return
    fi
  fi
  if [[ ! -d $dir ]]; then
    _p9k_timewarrior_clear
    return
  fi
  _p9k_timewarrior_dir=$dir
  if [[ $stat[1] != $_p9k_timewarrior_dir_mtime ]]; then
    local -a files=($dir/<->-<->.data(.N))
    if (( ! $#files )); then
      if (( $#stat )) || zstat -A stat +mtime -- $dir 2>/dev/null; then
        _p9k_timewarrior_dir_mtime=$stat[1]
        _p9k_timewarrior_file_mtime=$stat[1]
        _p9k_timewarrior_file_name=$dir  # sic
        unset _p9k_timewarrior_tags
        _p9k__state_dump_scheduled=1
      else
        _p9k_timewarrior_clear
      fi
      return
    fi
    _p9k_timewarrior_file_name=${${(AO)files}[1]}
  fi
  if ! zstat -A stat +mtime -- $dir $_p9k_timewarrior_file_name 2>/dev/null; then
    _p9k_timewarrior_clear
    return
  fi
  _p9k_timewarrior_dir_mtime=$stat[1]
  _p9k_timewarrior_file_mtime=$stat[2]
  { local tail=${${(Af)"$(<$_p9k_timewarrior_file_name)"}[-1]} } 2>/dev/null
  if [[ $tail == (#b)'inc '[^\ ]##(|\ #\#(*)) ]]; then
    _p9k_timewarrior_tags=${${match[2]## #}%% #}
    _p9k_prompt_segment $0 grey 255 TIMEWARRIOR_ICON 0 '' "${_p9k_timewarrior_tags//\%/%%}"
  else
    unset _p9k_timewarrior_tags
  fi
  _p9k__state_dump_scheduled=1
}

function _p9k_prompt_timewarrior_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[timew]'
}

function _p9k_taskwarrior_check_meta() {
  [[ -n $_p9k_taskwarrior_meta_sig ]] || return
  [[ -z $^_p9k_taskwarrior_meta_non_files(#qN) ]] || return
  local -a stat
  if (( $#_p9k_taskwarrior_meta_files )); then
    zstat -A stat +mtime -- $_p9k_taskwarrior_meta_files 2>/dev/null || return
  fi
  [[ $_p9k_taskwarrior_meta_sig == ${(pj:\0:)stat}$'\0'$TASKRC$'\0'$TASKDATA ]] || return
}

function _p9k_taskwarrior_init_meta() {
  local last_sig=$_p9k_taskwarrior_meta_sig
  {
    local cfg
    cfg="$(command task show data.location rc.color=0 rc._forcecolor=0 </dev/null 2>/dev/null)" || return
    local lines=(${(@M)${(f)cfg}:#data.location[[:space:]]##[^[:space:]]*})
    (( $#lines == 1 )) || return
    local dir=${lines[1]##data.location[[:space:]]#}
    : ${dir::=$~dir}  # `task` can give us path with `~`` in it; expand it

    local -a stat files=(${TASKRC:-~/.taskrc})
    _p9k_taskwarrior_meta_files=($^files(N))
    _p9k_taskwarrior_meta_non_files=(${files:|_p9k_taskwarrior_meta_files})
    if (( $#_p9k_taskwarrior_meta_files )); then
      zstat -A stat +mtime -- $_p9k_taskwarrior_meta_files 2>/dev/null || stat=(-1)
    fi
    _p9k_taskwarrior_meta_sig=${(pj:\0:)stat}$'\0'$TASKRC$'\0'$TASKDATA
    _p9k_taskwarrior_data_dir=$dir
  } always {
    if (( $? == 0 )); then
      _p9k__state_dump_scheduled=1
      return
    fi
    [[ -n $last_sig ]] && _p9k__state_dump_scheduled=1
    _p9k_taskwarrior_meta_files=()
    _p9k_taskwarrior_meta_non_files=()
    _p9k_taskwarrior_meta_sig=
    _p9k_taskwarrior_data_dir=
    _p9k__taskwarrior_functional=
  }
}

function _p9k_taskwarrior_check_data() {
  [[ -n $_p9k_taskwarrior_data_sig ]] || return
  [[ -z $^_p9k_taskwarrior_data_non_files(#qN) ]] || return
  local -a stat
  if (( $#_p9k_taskwarrior_data_files )); then
    zstat -A stat +mtime -- $_p9k_taskwarrior_data_files 2>/dev/null || return
  fi
  [[ $_p9k_taskwarrior_data_sig == ${(pj:\0:)stat}$'\0'$TASKRC$'\0'$TASKDATA ]] || return
  (( _p9k_taskwarrior_next_due == 0 || _p9k_taskwarrior_next_due > EPOCHSECONDS )) || return
}

function _p9k_taskwarrior_init_data() {
  local -a stat files=($_p9k_taskwarrior_data_dir/{pending,completed}.data)
  _p9k_taskwarrior_data_files=($^files(N))
  _p9k_taskwarrior_data_non_files=(${files:|_p9k_taskwarrior_data_files})
  if (( $#_p9k_taskwarrior_data_files )); then
    zstat -A stat +mtime -- $_p9k_taskwarrior_data_files 2>/dev/null || stat=(-1)
    _p9k_taskwarrior_data_sig=${(pj:\0:)stat}$'\0'
  else
    _p9k_taskwarrior_data_sig=
  fi

  _p9k_taskwarrior_data_files+=($_p9k_taskwarrior_meta_files)
  _p9k_taskwarrior_data_non_files+=($_p9k_taskwarrior_meta_non_files)
  _p9k_taskwarrior_data_sig+=$_p9k_taskwarrior_meta_sig

  local name val
  for name in PENDING OVERDUE; do
    val="$(command task +$name count rc.color=0 rc._forcecolor=0 </dev/null 2>/dev/null)" || continue
    [[ $val == <1-> ]] || continue
    _p9k_taskwarrior_counters[$name]=$val
  done

  _p9k_taskwarrior_next_due=0

  if (( _p9k_taskwarrior_counters[PENDING] > _p9k_taskwarrior_counters[OVERDUE] )); then
    local -a ts
    ts=($(command task +PENDING -OVERDUE list rc.verbose=nothing rc.color=0 rc._forcecolor=0 \
      rc.report.list.labels= rc.report.list.columns=due.epoch </dev/null 2>/dev/null)) || ts=()
    if (( $#ts )); then
      _p9k_taskwarrior_next_due=${${(on)ts}[1]}
      (( _p9k_taskwarrior_next_due > EPOCHSECONDS )) || _p9k_taskwarrior_next_due=$((EPOCHSECONDS+60))
    fi
  fi

  _p9k__state_dump_scheduled=1
}

function prompt_taskwarrior() {
  unset P9K_TASKWARRIOR_PENDING_COUNT P9K_TASKWARRIOR_OVERDUE_COUNT
  if ! _p9k_taskwarrior_check_data; then
    _p9k_taskwarrior_data_files=()
    _p9k_taskwarrior_data_non_files=()
    _p9k_taskwarrior_data_sig=
    _p9k_taskwarrior_counters=()
    _p9k_taskwarrior_next_due=0
    _p9k_taskwarrior_check_meta || _p9k_taskwarrior_init_meta || return
    _p9k_taskwarrior_init_data
  fi
  (( $#_p9k_taskwarrior_counters )) || return
  local text c=$_p9k_taskwarrior_counters[OVERDUE]
  if [[ -n $c ]]; then
    typeset -g P9K_TASKWARRIOR_OVERDUE_COUNT=$c
    text+="!$c"
  fi
  c=$_p9k_taskwarrior_counters[PENDING]
  if [[ -n $c ]]; then
    typeset -g P9K_TASKWARRIOR_PENDING_COUNT=$c
    [[ -n $text ]] && text+='/'
    text+=$c
  fi
  [[ -n $text ]] || return
  _p9k_prompt_segment $0 6 $_p9k_color1 TASKWARRIOR_ICON 0 '' $text
}

function _p9k_prompt_taskwarrior_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[task]:+$_p9k__taskwarrior_functional}'
}

prompt_wifi() {
  local -i len=$#_p9k__prompt _p9k__has_upglob
  _p9k_prompt_segment $0 green $_p9k_color1 WIFI_ICON 1 '$_p9k__wifi_on' '$P9K_WIFI_LAST_TX_RATE Mbps'
  (( _p9k__has_upglob )) || typeset -g "_p9k__segment_val_${_p9k__prompt_side}[_p9k__segment_index]"=$_p9k__prompt[len+1,-1]
}

_p9k_prompt_wifi_init() {
  if [[ -x /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport ||
        -r /proc/net/wireless && -n $commands[iw] ]]; then
    typeset -g _p9k__wifi_on=
    typeset -g P9K_WIFI_LAST_TX_RATE=
    typeset -g P9K_WIFI_SSID=
    typeset -g P9K_WIFI_LINK_AUTH=
    typeset -g P9K_WIFI_RSSI=
    typeset -g P9K_WIFI_NOISE=
    typeset -g P9K_WIFI_BARS=
    _p9k__async_segments_compute+='_p9k_worker_invoke wifi _p9k_prompt_wifi_compute'
  else
    typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${:-}'
  fi
}

_p9k_prompt_wifi_compute() {
  _p9k_worker_async _p9k_prompt_wifi_async _p9k_prompt_wifi_sync
}

_p9k_prompt_wifi_async() {
  local airport=/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
  local last_tx_rate ssid link_auth rssi noise bars on out line v state iface
  {
    if [[ -x $airport ]]; then
      out="$($airport -I)" || return 0
      for line in ${${${(f)out}##[[:space:]]#}%%[[:space:]]#}; do
        v=${line#*: }
        case $line[1,-$#v-3] in
          agrCtlRSSI)  rssi=$v;;
          agrCtlNoise) noise=$v;;
          state)       state=$v;;
          lastTxRate)  last_tx_rate=$v;;
          link\ auth)  link_auth=$v;;
          SSID)        ssid=$v;;
        esac
      done
      [[ $state == running && $rssi == (0|-<->) && $noise == (0|-<->) ]] || return 0
    elif [[ -r /proc/net/wireless && -n $commands[iw] ]]; then
      # Content example (https://github.com/romkatv/powerlevel10k/pull/973#issuecomment-680251804):
      #
      # Inter-| sta-|   Quality        |   Discarded packets               | Missed | WE
      #  face | tus | link level noise |  nwid  crypt   frag  retry   misc | beacon | 22
      # wlp3s0: 0000   58.  -52.  -256        0      0      0      0     76        0
      local -a lines
      lines=(${${(f)"$(</proc/net/wireless)"}:#*\|*}) || return 0
      (( $#lines == 1 )) || return 0
      local parts=(${=lines[1]})
      iface=${parts[1]%:}
      state=${parts[2]}
      rssi=${parts[4]%.*}
      noise=${parts[5]%.*}
      [[ -n $iface && $state == 0## && $rssi == (0|-<->) && $noise == (0|-<->) ]] || return 0
      # Output example (https://github.com/romkatv/powerlevel10k/pull/973#issuecomment-680251804):
      #
      # Connected to 74:83:c2:be:76:da (on wlp3s0)
      # 	SSID: DailyGrindGuest1
      # 	freq: 5745
      # 	RX: 35192066 bytes (27041 packets)
      # 	TX: 4090471 bytes (24287 packets)
      # 	signal: -52 dBm
      # 	rx bitrate: 243.0 MBit/s VHT-MCS 6 40MHz VHT-NSS 2
      # 	tx bitrate: 240.0 MBit/s VHT-MCS 5 40MHz short GI VHT-NSS 2
      #
      # 	bss flags:	short-slot-time
      # 	dtim period:	1
      # 	beacon int:	100
      lines=(${(f)"$(command iw dev $iface link)"}) || return 0
      local -a match mbegin mend
      for line in $lines; do
        if [[ $line == (#b)[[:space:]]#SSID:[[:space:]]##(*) ]]; then
          ssid=$match[1]
        elif [[ $line == (#b)[[:space:]]#'tx bitrate:'[[:space:]]##([^[:space:]]##)' MBit/s'* ]]; then
          last_tx_rate=$match[1]
          [[ $last_tx_rate == <->.<-> ]] && last_tx_rate=${${last_tx_rate%%0#}%.}
        fi
      done
      [[ -n $ssid && -n $last_tx_rate ]] || return 0
    else
      return 0
    fi
    # https://www.speedguide.net/faq/how-to-read-rssisignal-and-snrnoise-ratings-440
    # http://www.wireless-nets.com/resources/tutorials/define_SNR_values.html
    local -i snr_margin='rssi - noise'
    if (( snr_margin >= 40 )); then
      bars=4
    elif (( snr_margin >= 25 )); then
      bars=3
    elif (( snr_margin >= 15 )); then
      bars=2
    elif (( snr_margin >= 10 )); then
      bars=1
    else
      bars=0
    fi
    on=1
  } always {
    if (( ! on )); then
      rssi=
      noise=
      ssid=
      last_tx_rate=
      bars=
      link_auth=
    fi
    if [[ $_p9k__wifi_on         != $on           ||
          $P9K_WIFI_LAST_TX_RATE != $last_tx_rate ||
          $P9K_WIFI_SSID         != $ssid         ||
          $P9K_WIFI_LINK_AUTH    != $link_auth    ||
          $P9K_WIFI_RSSI         != $rssi         ||
          $P9K_WIFI_NOISE        != $noise        ||
          $P9K_WIFI_BARS         != $bars         ]]; then
      _p9k__wifi_on=$on
      P9K_WIFI_LAST_TX_RATE=$last_tx_rate
      P9K_WIFI_SSID=$ssid
      P9K_WIFI_LINK_AUTH=$link_auth
      P9K_WIFI_RSSI=$rssi
      P9K_WIFI_NOISE=$noise
      P9K_WIFI_BARS=$bars
      _p9k_print_params       \
        _p9k__wifi_on         \
        P9K_WIFI_LAST_TX_RATE \
        P9K_WIFI_SSID         \
        P9K_WIFI_LINK_AUTH    \
        P9K_WIFI_RSSI         \
        P9K_WIFI_NOISE        \
        P9K_WIFI_BARS
      echo -E - 'reset=1'
    fi
  }
}

_p9k_prompt_wifi_sync() {
  if [[ -n $REPLY ]]; then
    eval $REPLY
    _p9k_worker_reply $REPLY
  fi
}

function _p9k_asdf_check_meta() {
  [[ -n $_p9k_asdf_meta_sig ]] || return
  [[ -z $^_p9k_asdf_meta_non_files(#qN) ]] || return
  local -a stat
  if (( $#_p9k_asdf_meta_files )); then
    zstat -A stat +mtime -- $_p9k_asdf_meta_files 2>/dev/null || return
  fi
  [[ $_p9k_asdf_meta_sig == $ASDF_CONFIG_FILE$'\0'$ASDF_DATA_DIR$'\0'${(pj:\0:)stat} ]] || return
}

function _p9k_asdf_init_meta() {
  local last_sig=$_p9k_asdf_meta_sig
  {
    local -a files
    local -i legacy_enabled

    _p9k_asdf_plugins=()
    _p9k_asdf_file_info=()

    local cfg=${ASDF_CONFIG_FILE:-~/.asdfrc}
    files+=$cfg
    if [[ -f $cfg && -r $cfg ]]; then
      # Config parser in adsf is very strange.
      #
      # This gives "yes":
      #
      #   legacy_version_file = yes = no
      #
      # This gives "no":
      #
      #   legacy_version_file = yes
      #   legacy_version_file = yes
      #
      # We do the same.
      local lines=(${(@M)${(@)${(f)"$(<$cfg)"}%$'\r'}:#[[:space:]]#legacy_version_file[[:space:]]#=*})
      if [[ $#lines == 1 && ${${(s:=:)lines[1]}[2]} == [[:space:]]#yes[[:space:]]# ]]; then
        legacy_enabled=1
      fi
    fi

    local root=${ASDF_DATA_DIR:-~/.asdf}
    files+=$root/plugins
    if [[ -d $root/plugins ]]; then
      local plugin
      for plugin in $root/plugins/[^[:space:]]##(/N); do
        files+=$root/installs/${plugin:t}
        local -aU installed=($root/installs/${plugin:t}/[^[:space:]]##(/N:t) system)
        _p9k_asdf_plugins[${plugin:t}]=${(j:|:)${(@b)installed}}
        (( legacy_enabled )) || continue
        if [[ ! -e $plugin/bin ]]; then
          files+=$plugin/bin
        else
          local list_names=$plugin/bin/list-legacy-filenames
          files+=$list_names
          if [[ -x $list_names ]]; then
            local parse=$plugin/bin/parse-legacy-file
            local -i has_parse=0
            files+=$parse
            [[ -x $parse ]] && has_parse=1
            local name
            for name in ${$($list_names 2>/dev/null)%$'\r'}; do
              [[ $name == (*/*|.tool-versions) ]] && continue
              _p9k_asdf_file_info[$name]+="${plugin:t} $has_parse "
            done
          fi
        fi
      done
    fi

    _p9k_asdf_meta_files=($^files(N))
    _p9k_asdf_meta_non_files=(${files:|_p9k_asdf_meta_files})

    local -a stat
    if (( $#_p9k_asdf_meta_files )); then
      zstat -A stat +mtime -- $_p9k_asdf_meta_files 2>/dev/null || return
    fi
    _p9k_asdf_meta_sig=$ASDF_CONFIG_FILE$'\0'$ASDF_DATA_DIR$'\0'${(pj:\0:)stat}
    _p9k__asdf_dir2files=()
    _p9k_asdf_file2versions=()
  } always {
    if (( $? == 0 )); then
      _p9k__state_dump_scheduled=1
      return
    fi
    [[ -n $last_sig ]] && _p9k__state_dump_scheduled=1
    _p9k_asdf_meta_files=()
    _p9k_asdf_meta_non_files=()
    _p9k_asdf_meta_sig=
    _p9k_asdf_plugins=()
    _p9k_asdf_file_info=()
    _p9k__asdf_dir2files=()
    _p9k_asdf_file2versions=()
  }
}

# Usage: _p9k_asdf_parse_version_file <file> <is_legacy>
#
# Mutates `versions` on success.
function _p9k_asdf_parse_version_file() {
  local file=$1
  local is_legacy=$2
  local -a stat
  zstat -A stat +mtime $file 2>/dev/null || return
  if (( is_legacy )); then
    local plugin has_parse
    for plugin has_parse in $=_p9k_asdf_file_info[$file:t]; do
      local cached=$_p9k_asdf_file2versions[$plugin:$file]
      if [[ $cached == $stat[1]:* ]]; then
        local v=${cached#*:}
      else
        if (( has_parse )); then
          local v=($(${ASDF_DATA_DIR:-~/.asdf}/plugins/$plugin/bin/parse-legacy-file $file 2>/dev/null))
        else
          { local v=($(<$file)) } 2>/dev/null
        fi
        v=(${v%$'\r'})
        v=${v[(r)$_p9k_asdf_plugins[$plugin]]:-$v[1]}
        _p9k_asdf_file2versions[$plugin:$file]=$stat[1]:"$v"
        _p9k__state_dump_scheduled=1
      fi
      [[ -n $v ]] && : ${versions[$plugin]="$v"}
    done
  else
    local cached=$_p9k_asdf_file2versions[:$file]
    if [[ $cached == $stat[1]:* ]]; then
      local file_versions=(${(0)${cached#*:}})
    else
      local file_versions=()
      { local lines=(${(@)${(@)${(f)"$(<$file)"}%$'\r'}/\#*}) } 2>/dev/null
      local line
      for line in $lines; do
        local words=($=line)
        (( $#words > 1 )) || continue
        local installed=$_p9k_asdf_plugins[$words[1]]
        [[ -n $installed ]] || continue
        file_versions+=($words[1] ${${words:1}[(r)$installed]:-$words[2]})
      done
      _p9k_asdf_file2versions[:$file]=$stat[1]:${(pj:\0:)file_versions}
      _p9k__state_dump_scheduled=1
    fi
    local plugin version
    for plugin version in $file_versions; do
      : ${versions[$plugin]=$version}
    done
  fi
  return 0
}

function prompt_asdf() {
  _p9k_asdf_check_meta || _p9k_asdf_init_meta || return

  local -A versions
  local -a stat
  local -i has_global
  local dirs=($_p9k__parent_dirs)
  local mtimes=($_p9k__parent_mtimes)
  if [[ $dirs[-1] != ~ ]]; then
    zstat -A stat +mtime ~ 2>/dev/null || return
    dirs+=(~)
    mtimes+=($stat[1])
  fi

  local elem
  for elem in ${(@)${:-{1..$#dirs}}/(#m)*/${${:-$MATCH:$_p9k__asdf_dir2files[$dirs[MATCH]]}#$MATCH:$mtimes[MATCH]:}}; do
    if [[ $elem == *:* ]]; then
      local dir=$dirs[${elem%%:*}]
      zstat -A stat +mtime $dir 2>/dev/null || return
      local files=($dir/.tool-versions(N) $dir/${(k)^_p9k_asdf_file_info}(N))
      _p9k__asdf_dir2files[$dir]=$stat[1]:${(pj:\0:)files}
    else
      local files=(${(0)elem})
    fi
    if [[ ${files[1]:h} == ~ ]]; then
      has_global=1
      local -A local_versions=(${(kv)versions})
      versions=()
    fi
    local file
    for file in $files; do
      [[ $file == */.tool-versions ]]
      _p9k_asdf_parse_version_file $file $? || return
    done
  done

  if (( ! has_global )); then
    has_global=1
    local -A local_versions=(${(kv)versions})
    versions=()
  fi

  if [[ -r $ASDF_DEFAULT_TOOL_VERSIONS_FILENAME ]]; then
    _p9k_asdf_parse_version_file $ASDF_DEFAULT_TOOL_VERSIONS_FILENAME 0 || return
  fi

  local plugin
  for plugin in ${(k)_p9k_asdf_plugins}; do
    local upper=${${(U)plugin//-/_}//İ/I}
    if (( $+parameters[_POWERLEVEL9K_ASDF_${upper}_SOURCES] )); then
      local sources=(${(P)${:-_POWERLEVEL9K_ASDF_${upper}_SOURCES}})
    else
      local sources=($_POWERLEVEL9K_ASDF_SOURCES)
    fi

    local version="${(P)${:-ASDF_${upper}_VERSION}}"
    if [[ -n $version ]]; then
      (( $sources[(I)shell] )) || continue
    else
      version=$local_versions[$plugin]
      if [[ -n $version ]]; then
        (( $sources[(I)local] )) || continue
      else
        version=$versions[$plugin]
        [[ -n $version ]] || continue
        (( $sources[(I)global] )) || continue
      fi
    fi

    if [[ $version == $versions[$plugin] ]]; then
      if (( $+parameters[_POWERLEVEL9K_ASDF_${upper}_PROMPT_ALWAYS_SHOW] )); then
        (( _POWERLEVEL9K_ASDF_${upper}_PROMPT_ALWAYS_SHOW )) || continue
      else
        (( _POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW )) || continue
      fi
    fi

    if [[ $version == system ]]; then
      if (( $+parameters[_POWERLEVEL9K_ASDF_${upper}_SHOW_SYSTEM] )); then
        (( _POWERLEVEL9K_ASDF_${upper}_SHOW_SYSTEM )) || continue
      else
        (( _POWERLEVEL9K_ASDF_SHOW_SYSTEM )) || continue
      fi
    fi

    _p9k_get_icon $0_$upper ${upper}_ICON $plugin
    _p9k_prompt_segment $0_$upper green $_p9k_color1 $'\1'$_p9k__ret 0 '' ${version//\%/%%}
  done
}

_p9k_prompt_asdf_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='${commands[asdf]:-${${+functions[asdf]}:#0}}'
}

_p9k_haskell_stack_version() {
  if ! _p9k_cache_stat_get $0 $1 ${STACK_ROOT:-~/.stack}/{pantry/pantry.sqlite3,stack.sqlite3}; then
    local v
    v="$(STACK_YAML=$1 stack \
      --silent                 \
      --no-install-ghc         \
      --skip-ghc-check         \
      --no-terminal            \
      --color=never            \
      --lock-file=read-only    \
      query compiler actual)" || v=
    _p9k_cache_stat_set "$v"
  fi
  _p9k__ret=$_p9k__cache_val[1]
}

prompt_haskell_stack() {
  if [[ -n $STACK_YAML ]]; then
    (( ${_POWERLEVEL9K_HASKELL_STACK_SOURCES[(I)shell]} )) || return
    _p9k_haskell_stack_version $STACK_YAML
  else
    (( ${_POWERLEVEL9K_HASKELL_STACK_SOURCES[(I)local|global]} )) || return
    if _p9k_upglob stack.yaml; then
      (( _POWERLEVEL9K_HASKELL_STACK_PROMPT_ALWAYS_SHOW )) || return
      (( ${_POWERLEVEL9K_HASKELL_STACK_SOURCES[(I)global]} )) || return
      _p9k_haskell_stack_version ${STACK_ROOT:-~/.stack}/global-project/stack.yaml
    else
      local -i idx=$?
      (( ${_POWERLEVEL9K_HASKELL_STACK_SOURCES[(I)local]} )) || return
      _p9k_haskell_stack_version $_p9k__parent_dirs[idx]/stack.yaml
    fi
  fi

  [[ -n $_p9k__ret ]] || return

  local v=$_p9k__ret

  if (( !_POWERLEVEL9K_HASKELL_STACK_PROMPT_ALWAYS_SHOW )); then
    _p9k_haskell_stack_version ${STACK_ROOT:-~/.stack}/global-project/stack.yaml
    [[ $v == $_p9k__ret ]] && return
  fi

  _p9k_prompt_segment "$0" "yellow" "$_p9k_color1" 'HASKELL_ICON' 0 '' "${v//\%/%%}"
}

_p9k_prompt_haskell_stack_init() {
  typeset -g "_p9k__segment_cond_${_p9k__prompt_side}[_p9k__segment_index]"='$commands[stack]'
}

# Use two preexec hooks to survive https://github.com/MichaelAquilina/zsh-you-should-use with
# YSU_HARDCORE=1. See https://github.com/romkatv/powerlevel10k/issues/427.
_p9k_preexec1() {
  _p9k_restore_special_params
  unset __p9k_trapint
  trap - INT
}

_p9k_preexec2() {
  typeset -g _p9k__preexec_cmd=$2
  _p9k__timer_start=EPOCHREALTIME
  P9K_TTY=old
  (( ! $+_p9k__iterm_cmd )) || _p9k_iterm2_preexec
}

function _p9k_prompt_net_iface_init() {
  typeset -g _p9k__public_ip_vpn=
  typeset -g _p9k__public_ip_not_vpn=
  typeset -g P9K_IP_IP=
  typeset -g P9K_IP_INTERFACE=
  typeset -g P9K_IP_TX_BYTES=
  typeset -g P9K_IP_RX_BYTES=
  typeset -g P9K_IP_TX_BYTES_DELTA=
  typeset -g P9K_IP_RX_BYTES_DELTA=
  typeset -g P9K_IP_TX_RATE=
  typeset -g P9K_IP_RX_RATE=
  typeset -g _p9__ip_timestamp=
  typeset -g _p9k__vpn_ip_ips=()
  [[ -z $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ]] && _p9k__public_ip_not_vpn=1
  _p9k__async_segments_compute+='_p9k_worker_invoke net_iface _p9k_prompt_net_iface_compute'
}

# reads `iface2ip` and sets `ifaces` and `ips`
function _p9k_prompt_net_iface_match() {
  local iface_regex="^($1)\$" iface ip
  ips=()
  ifaces=()
  for iface ip in "${(@)iface2ip}"; do
    [[ $iface =~ $iface_regex ]] || continue
    ifaces+=$iface
    ips+=$ip
  done
  return $(($#ips == 0))
}

function _p9k_prompt_net_iface_compute() {
  _p9k_worker_async _p9k_prompt_net_iface_async _p9k_prompt_net_iface_sync
}

function _p9k_prompt_net_iface_async() {
  # netstat -inbI en0
  local iface ip line var
  typeset -a iface2ip ips ifaces
  if (( $+commands[ifconfig] )); then
    for line in ${(f)"$(command ifconfig 2>/dev/null)"}; do
      if [[ $line == (#b)([^[:space:]]##):[[:space:]]##flags=([[:xdigit:]]##)'<'* ]]; then
        [[ $match[2] == *[13579bdfBDF] ]] && iface=$match[1] || iface=
      elif [[ -n $iface && $line == (#b)[[:space:]]##inet[[:space:]]##([0-9.]##)* ]]; then
        iface2ip+=($iface $match[1])
        iface=
      fi
    done
  elif (( $+commands[ip] )); then
    for line in ${(f)"$(command ip -4 a show 2>/dev/null)"}; do
      if [[ $line == (#b)<->:[[:space:]]##([^:]##):[[:space:]]##\<([^\>]#)\>* ]]; then
        [[ ,$match[2], == *,UP,* ]] && iface=$match[1] || iface=
      elif [[ -n $iface && $line == (#b)[[:space:]]##inet[[:space:]]##([0-9.]##)* ]]; then
        iface2ip+=($iface $match[1])
        iface=
      fi
    done
  fi

  if _p9k_prompt_net_iface_match $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE; then
    local public_ip_vpn=1
    local public_ip_not_vpn=
  else
    local public_ip_vpn=
    local public_ip_not_vpn=1
  fi
  if _p9k_prompt_net_iface_match $_POWERLEVEL9K_IP_INTERFACE; then
    local ip_ip=$ips[1] ip_interface=$ifaces[1] ip_timestamp=$EPOCHREALTIME
    local ip_tx_bytes ip_rx_bytes ip_tx_rate ip_rx_rate
    if [[ $_p9k_os == (Linux|Android) ]]; then
      if [[ -r /sys/class/net/$ifaces[1]/statistics/tx_bytes &&
            -r /sys/class/net/$ifaces[1]/statistics/rx_bytes ]]; then
        _p9k_read_file /sys/class/net/$ifaces[1]/statistics/tx_bytes &&
          [[ $_p9k__ret == <-> ]] && ip_tx_bytes=$_p9k__ret &&
        _p9k_read_file /sys/class/net/$ifaces[1]/statistics/rx_bytes &&
          [[ $_p9k__ret == <-> ]] && ip_rx_bytes=$_p9k__ret || { ip_tx_bytes=; ip_rx_bytes=; }
      fi
    elif [[ $_p9k_os == (BSD|OSX) && $+commands[netstat] == 1 ]]; then
      local -a lines
      if lines=(${(f)"$(netstat -inbI $ifaces[1])"}); then
        local header=($=lines[1])
        local -i rx_idx=$header[(Ie)Ibytes]
        local -i tx_idx=$header[(Ie)Obytes]
        if (( rx_idx && tx_idx )); then
          ip_tx_bytes=0
          ip_rx_bytes=0
          for line in ${lines:1}; do
            (( ip_rx_bytes += ${line[(w)rx_idx]} ))
            (( ip_tx_bytes += ${line[(w)tx_idx]} ))
          done
        fi
      fi
    fi
    if [[ -n $ip_rx_bytes ]]; then
      if [[ $ip_ip == $P9K_IP_IP && $ifaces[1] == $P9K_IP_INTERFACE ]]; then
        local -F t='ip_timestamp - _p9__ip_timestamp'
        if (( t <= 0 )); then
          ip_tx_rate=${P9K_IP_TX_RATE:-0 B/s}
          ip_rx_rate=${P9K_IP_RX_RATE:-0 B/s}
        else
          _p9k_human_readable_bytes $(((ip_tx_bytes - P9K_IP_TX_BYTES) / t))
          [[ $_p9k__ret == *B ]] && ip_tx_rate="$_p9k__ret[1,-2] B/s" || ip_tx_rate="$_p9k__ret[1,-2] $_p9k__ret[-1]iB/s"
          _p9k_human_readable_bytes $(((ip_rx_bytes - P9K_IP_RX_BYTES) / t))
          [[ $_p9k__ret == *B ]] && ip_rx_rate="$_p9k__ret[1,-2] B/s" || ip_rx_rate="$_p9k__ret[1,-2] $_p9k__ret[-1]iB/s"
        fi
      else
        ip_tx_rate='0 B/s'
        ip_rx_rate='0 B/s'
      fi
    fi
  else
    local ip_ip= ip_interface= ip_tx_bytes= ip_rx_bytes= ip_tx_rate= ip_rx_rate= ip_timestamp=
  fi
  if _p9k_prompt_net_iface_match $_POWERLEVEL9K_VPN_IP_INTERFACE; then
    if (( _POWERLEVEL9K_VPN_IP_SHOW_ALL )); then
      local vpn_ip_ips=($ips)
    else
      local vpn_ip_ips=($ips[1])
    fi
  else
    local vpn_ip_ips=()
  fi
  [[ $_p9k__public_ip_vpn == $public_ip_vpn &&
     $_p9k__public_ip_not_vpn == $public_ip_not_vpn &&
     $P9K_IP_IP == $ip_ip &&
     $P9K_IP_INTERFACE == $ip_interface &&
     $P9K_IP_TX_BYTES == $ip_tx_bytes &&
     $P9K_IP_RX_BYTES == $ip_rx_bytes &&
     $P9K_IP_TX_RATE == $ip_tx_rate &&
     $P9K_IP_RX_RATE == $ip_rx_rate &&
     "$_p9k__vpn_ip_ips" == "$vpn_ip_ips" ]] && return 1
  if [[ "$_p9k__vpn_ip_ips" == "$vpn_ip_ips" ]]; then
    echo -n 0
  else
    echo -n 1
  fi
  _p9k__public_ip_vpn=$public_ip_vpn
  _p9k__public_ip_not_vpn=$public_ip_not_vpn
  P9K_IP_IP=$ip_ip
  P9K_IP_INTERFACE=$ip_interface
  if [[ -n $ip_tx_bytes && -n $P9K_IP_TX_BYTES ]]; then
    P9K_IP_TX_BYTES_DELTA=$((ip_tx_bytes - P9K_IP_TX_BYTES))
  else
    P9K_IP_TX_BYTES_DELTA=
  fi
  if [[ -n $ip_rx_bytes && -n $P9K_IP_RX_BYTES ]]; then
    P9K_IP_RX_BYTES_DELTA=$((ip_rx_bytes - P9K_IP_RX_BYTES))
  else
    P9K_IP_RX_BYTES_DELTA=
  fi
  P9K_IP_TX_BYTES=$ip_tx_bytes
  P9K_IP_RX_BYTES=$ip_rx_bytes
  P9K_IP_TX_RATE=$ip_tx_rate
  P9K_IP_RX_RATE=$ip_rx_rate
  _p9__ip_timestamp=$ip_timestamp
  _p9k__vpn_ip_ips=($vpn_ip_ips)
  _p9k_print_params         \
    _p9k__public_ip_vpn     \
    _p9k__public_ip_not_vpn \
    P9K_IP_IP               \
    P9K_IP_INTERFACE        \
    P9K_IP_TX_BYTES         \
    P9K_IP_RX_BYTES         \
    P9K_IP_TX_BYTES_DELTA   \
    P9K_IP_RX_BYTES_DELTA   \
    P9K_IP_TX_RATE          \
    P9K_IP_RX_RATE          \
    _p9__ip_timestamp       \
    _p9k__vpn_ip_ips
  echo -E - 'reset=1'
}

_p9k_prompt_net_iface_sync() {
  local -i vpn_ip_changed=$REPLY[1]
  REPLY[1]=""
  eval $REPLY
  (( vpn_ip_changed )) && REPLY+='; _p9k_vpn_ip_render'
  _p9k_worker_reply $REPLY
}

function _p9k_set_prompt() {
  local -i _p9k__vcs_called

  PROMPT=
  RPROMPT=
  [[ $1 == instant_ ]] || PROMPT+='${$((_p9k_on_expand()))+}%{${_p9k__raw_msg-}${_p9k__raw_msg::=}%}'
  PROMPT+=$_p9k_prompt_prefix_left

  local -i _p9k__has_upglob

  local -i left_idx=1 right_idx=1 num_lines=$#_p9k_line_segments_left
  for _p9k__line_index in {1..$num_lines}; do
    local right=
    if (( !_POWERLEVEL9K_DISABLE_RPROMPT )); then
      _p9k__dir=
      _p9k__prompt=
      _p9k__segment_index=right_idx
      _p9k__prompt_side=right
      if [[ $1 == instant_ ]]; then
        for _p9k__segment_name in ${${(0)_p9k_line_segments_right[_p9k__line_index]}%_joined}; do
          if (( $+functions[instant_prompt_$_p9k__segment_name] )); then
            local disabled=_POWERLEVEL9K_${${(U)_p9k__segment_name}//İ/I}_DISABLED_DIR_PATTERN
            if [[ $_p9k__cwd != ${(P)~disabled} ]]; then
              local -i len=$#_p9k__prompt
              _p9k__non_hermetic_expansion=0
              instant_prompt_$_p9k__segment_name
              if (( _p9k__non_hermetic_expansion )); then
                _p9k__prompt[len+1,-1]=
              fi
            fi
          fi
          ((++_p9k__segment_index))
        done
      else
        for _p9k__segment_name in ${${(0)_p9k_line_segments_right[_p9k__line_index]}%_joined}; do
          local cond=$_p9k__segment_cond_right[_p9k__segment_index]
          if [[ -z $cond || -n ${(e)cond} ]]; then
            local disabled=_POWERLEVEL9K_${${(U)_p9k__segment_name}//İ/I}_DISABLED_DIR_PATTERN
            if [[ $_p9k__cwd != ${(P)~disabled} ]]; then
              local val=$_p9k__segment_val_right[_p9k__segment_index]
              if [[ -n $val ]]; then
                _p9k__prompt+=$val
              else
                if [[ $_p9k__segment_name == custom_* ]]; then
                  _p9k_custom_prompt $_p9k__segment_name[8,-1]
                elif (( $+functions[prompt_$_p9k__segment_name] )); then
                  prompt_$_p9k__segment_name
                fi
              fi
            fi
          fi
          ((++_p9k__segment_index))
        done
      fi
      _p9k__prompt=${${_p9k__prompt//$' %{\b'/'%{%G'}//$' \b'}
      right_idx=_p9k__segment_index
      if [[ -n $_p9k__prompt || $_p9k_line_never_empty_right[_p9k__line_index] == 1 ]]; then
        right=$_p9k_line_prefix_right[_p9k__line_index]$_p9k__prompt$_p9k_line_suffix_right[_p9k__line_index]
      fi
    fi
    unset _p9k__dir
    _p9k__prompt=$_p9k_line_prefix_left[_p9k__line_index]
    _p9k__segment_index=left_idx
    _p9k__prompt_side=left
    if [[ $1 == instant_ ]]; then
      for _p9k__segment_name in ${${(0)_p9k_line_segments_left[_p9k__line_index]}%_joined}; do
        if (( $+functions[instant_prompt_$_p9k__segment_name] )); then
          local disabled=_POWERLEVEL9K_${${(U)_p9k__segment_name}//İ/I}_DISABLED_DIR_PATTERN
          if [[ $_p9k__cwd != ${(P)~disabled} ]]; then
            local -i len=$#_p9k__prompt
            _p9k__non_hermetic_expansion=0
            instant_prompt_$_p9k__segment_name
            if (( _p9k__non_hermetic_expansion )); then
              _p9k__prompt[len+1,-1]=
            fi
          fi
        fi
        ((++_p9k__segment_index))
      done
    else
      for _p9k__segment_name in ${${(0)_p9k_line_segments_left[_p9k__line_index]}%_joined}; do
        local cond=$_p9k__segment_cond_left[_p9k__segment_index]
        if [[ -z $cond || -n ${(e)cond} ]]; then
          local disabled=_POWERLEVEL9K_${${(U)_p9k__segment_name}//İ/I}_DISABLED_DIR_PATTERN
          if [[ $_p9k__cwd != ${(P)~disabled} ]]; then
            local val=$_p9k__segment_val_left[_p9k__segment_index]
            if [[ -n $val ]]; then
              _p9k__prompt+=$val
            else
              if [[ $_p9k__segment_name == custom_* ]]; then
                _p9k_custom_prompt $_p9k__segment_name[8,-1]
              elif (( $+functions[prompt_$_p9k__segment_name] )); then
                prompt_$_p9k__segment_name
              fi
            fi
          fi
        fi
        ((++_p9k__segment_index))
      done
    fi
    _p9k__prompt=${${_p9k__prompt//$' %{\b'/'%{%G'}//$' \b'}
    left_idx=_p9k__segment_index
    _p9k__prompt+=$_p9k_line_suffix_left[_p9k__line_index]
    if (( $+_p9k__dir || (_p9k__line_index != num_lines && $#right) )); then
      _p9k__prompt='${${:-${_p9k__d::=0}${_p9k__rprompt::='$right'}${_p9k__lprompt::='$_p9k__prompt'}}+}'
      _p9k__prompt+=$_p9k_gap_pre
      if (( $+_p9k__dir )); then
        if (( _p9k__line_index == num_lines && (_POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS > 0 || _POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT > 0) )); then
          local a=$_POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS
          local f=$((0.01*_POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT))'*_p9k__clm'
          _p9k__prompt+="\${\${_p9k__h::=$((($a<$f)*$f+($a>=$f)*$a))}+}"
        else
          _p9k__prompt+='${${_p9k__h::=0}+}'
        fi
        if [[ $_POWERLEVEL9K_DIR_MAX_LENGTH == <->('%'|) ]]; then
          local lim=
          if [[ $_POWERLEVEL9K_DIR_MAX_LENGTH[-1] == '%' ]]; then
            lim="$_p9k__dir_len-$((0.01*$_POWERLEVEL9K_DIR_MAX_LENGTH[1,-2]))*_p9k__clm"
          else
            lim=$((_p9k__dir_len-_POWERLEVEL9K_DIR_MAX_LENGTH))
            ((lim <= 0)) && lim=
          fi
          if [[ -n $lim ]]; then
            _p9k__prompt+='${${${$((_p9k__h<_p9k__m+'$lim')):#1}:-${_p9k__h::=$((_p9k__m+'$lim'))}}+}'
          fi
        fi
        _p9k__prompt+='${${_p9k__d::=$((_p9k__m-_p9k__h))}+}'
        _p9k__prompt+='${_p9k__lprompt/\%\{d\%\}*\%\{d\%\}/${_p9k__'$_p9k__line_index'ldir-'$_p9k__dir'}}'
        _p9k__prompt+='${${_p9k__m::=$((_p9k__d+_p9k__h))}+}'
      else
        _p9k__prompt+='${_p9k__lprompt}'
      fi
      ((_p9k__line_index != num_lines && $#right)) && _p9k__prompt+=$_p9k_line_gap_post[_p9k__line_index]
    fi
    if (( _p9k__line_index == num_lines )); then
      [[ -n $right ]] && RPROMPT=$_p9k_prompt_prefix_right$right$_p9k_prompt_suffix_right
      _p9k__prompt='${_p9k__'$_p9k__line_index'-'$_p9k__prompt'}'$_p9k_prompt_suffix_left
      [[ $1 == instant_ ]] || PROMPT+=$_p9k__prompt
    else
      [[ -n $right ]] || _p9k__prompt+=$'\n'
      PROMPT+='${_p9k__'$_p9k__line_index'-'$_p9k__prompt'}'
    fi
  done

  _p9k__prompt_side=
  (( $#_p9k_cache < _POWERLEVEL9K_MAX_CACHE_SIZE )) || _p9k_cache=()
  (( $#_p9k__cache_ephemeral < _POWERLEVEL9K_MAX_CACHE_SIZE )) || _p9k__cache_ephemeral=()

  [[ -n $RPROMPT ]] || unset RPROMPT
}

_p9k_set_instant_prompt() {
  local saved_prompt=$PROMPT
  local saved_rprompt=$RPROMPT
  _p9k_set_prompt instant_
  typeset -g _p9k__instant_prompt=$PROMPT$'\x1f'$_p9k__prompt$'\x1f'$RPROMPT
  PROMPT=$saved_prompt
  RPROMPT=$saved_rprompt
  [[ -n $RPROMPT ]] || unset RPROMPT
}

typeset -gri __p9k_instant_prompt_version=47

_p9k_dump_instant_prompt() {
  local user=${(%):-%n}
  local root_dir=${__p9k_dump_file:h}
  local prompt_dir=${root_dir}/p10k-$user
  local root_file=$root_dir/p10k-instant-prompt-$user.zsh
  local prompt_file=$prompt_dir/prompt-${#_p9k__cwd}
  [[ -d $prompt_dir ]] || mkdir -p $prompt_dir || return
  [[ -w $root_dir && -w $prompt_dir ]] || return

  if [[ ! -e $root_file  ]]; then
    local tmp=$root_file.tmp.$$
    local -i fd
    sysopen -a -m 600 -o creat,trunc -u fd -- $tmp || return
    {
      [[ $TERM == (screen*|tmux*) ]] && local screen='-n' || local screen='-z'
      local -a display_v=("${_p9k__display_v[@]}")
      local -i i
      for ((i = 6; i <= $#display_v; i+=2)); do display_v[i]=show; done
      display_v[2]=hide
      display_v[4]=hide
      local gitstatus_dir=${${_POWERLEVEL9K_GITSTATUS_DIR:A}:-${__p9k_root_dir}/gitstatus}
      local gitstatus_header
      if [[ -r $gitstatus_dir/install.info ]]; then
        IFS= read -r gitstatus_header <$gitstatus_dir/install.info || return
      fi
      >&$fd print -r -- '[[ -t 0 && -t 1 && -t 2 && -o interactive && -o zle && -o no_xtrace ]] &&
  ! (( ${+__p9k_instant_prompt_disabled} || ZSH_SUBSHELL || ${+ZSH_SCRIPT} || ${+ZSH_EXECUTION_STRING} )) || return 0'
      >&$fd print -r -- "() {
  $__p9k_intro_no_locale
  typeset -gi __p9k_instant_prompt_disabled=1
  [[ \$ZSH_VERSION == ${(q)ZSH_VERSION} && \$ZSH_PATCHLEVEL == ${(q)ZSH_PATCHLEVEL} &&
     $screen \${(M)TERM:#(screen*|tmux*)} &&
     \${#\${(M)VTE_VERSION:#(<1-4602>|4801)}} == "${#${(M)VTE_VERSION:#(<1-4602>|4801)}}" &&
     \$POWERLEVEL9K_DISABLE_INSTANT_PROMPT != 'true' &&
     \$POWERLEVEL9K_INSTANT_PROMPT != 'off' ]] || return
  typeset -g __p9k_instant_prompt_param_sig=${(q+)_p9k__param_sig}
  local gitstatus_dir=${(q)gitstatus_dir}
  local gitstatus_header=${(q)gitstatus_header}
  local -i ZLE_RPROMPT_INDENT=${ZLE_RPROMPT_INDENT:-1}
  local PROMPT_EOL_MARK=${(q)PROMPT_EOL_MARK-%B%S%#%s%b}
  [[ -n \$SSH_CLIENT || -n \$SSH_TTY || -n \$SSH_CONNECTION ]] && local ssh=1 || local ssh=0
  local cr=\$'\r' lf=\$'\n' esc=\$'\e[' rs=$'\x1e' us=$'\x1f'
  local -i height=${_POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES-1}
  local prompt_dir=${(q)prompt_dir}"
      if (( ! ${+_POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES} )); then
        >&$fd print -r -- '
  (( _z4h_can_save_restore_screen == 1 )) && height=0'
      fi
      >&$fd print -r -- '
  local real_gitstatus_header
  if [[ -r $gitstatus_dir/install.info ]]; then
    IFS= read -r real_gitstatus_header <$gitstatus_dir/install.info || real_gitstatus_header=borked
  fi
  [[ $real_gitstatus_header == $gitstatus_header ]] || return
  zmodload zsh/langinfo zsh/terminfo zsh/system || return
  if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]]; then
    local loc_cmd=$commands[locale]
    [[ -z $loc_cmd ]] && loc_cmd='${(q)commands[locale]}'
    if [[ -x $loc_cmd ]]; then
      local -a locs
      if locs=(${(@M)$(locale -a 2>/dev/null):#*.(utf|UTF)(-|)8}) && (( $#locs )); then
        local loc=${locs[(r)(#i)C.UTF(-|)8]:-${locs[(r)(#i)en_US.UTF(-|)8]:-$locs[1]}}
        [[ -n $LC_ALL ]] && local LC_ALL=$loc || local LC_CTYPE=$loc
      fi
    fi
  fi
  (( terminfo[colors] == '${terminfo[colors]:-0}' )) || return
  (( $+terminfo[cuu] && $+terminfo[cuf] && $+terminfo[ed] && $+terminfo[sc] && $+terminfo[rc] )) || return
  local pwd=${(%):-%/}
  [[ $pwd == /* ]] || return
  local prompt_file=$prompt_dir/prompt-${#pwd}
  local key=$pwd:$ssh:${(%):-%#}
  local content
  if [[ ! -e $prompt_file ]]; then
    typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version'
    return 1
  fi
  { content="$(<$prompt_file)" } 2>/dev/null || return
  local tail=${content##*$rs$key$us}
  if (( ${#tail} == ${#content} )); then
    typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version'
    return 1
  fi
  local _p9k__ipe
  local P9K_PROMPT=instant
  if [[ -z $P9K_TTY || $P9K_TTY == old && -n ${_P9K_TTY:#$TTY} ]]; then'
      if (( _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS < 0 )); then
        >&$fd print -r -- '    typeset -gx P9K_TTY=new'
      else
        >&$fd print -r -- '
    typeset -gx P9K_TTY=old
    zmodload -F zsh/stat b:zstat || return
    zmodload zsh/datetime || return
    local -a stat
    if zstat -A stat +ctime -- $TTY 2>/dev/null &&
      (( EPOCHREALTIME - stat[1] < '$_POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS' )); then
      P9K_TTY=new
    fi'
      fi
      >&$fd print -r -- '  fi
  typeset -gx _P9K_TTY=$TTY
  local -i _p9k__empty_line_i=3 _p9k__ruler_i=3
  local -A _p9k_display_k=('${(j: :)${(@q)${(kv)_p9k_display_k}}}')
  local -a _p9k__display_v=('${(j: :)${(@q)display_v}}')
  function p10k() {
    '$__p9k_intro'
    [[ $1 == display ]] || return
    shift
    local -i k dump
    local opt prev new pair list name var
    while getopts ":ha" opt; do
      case $opt in
        a) dump=1;;
        h) return 0;;
        ?) return 1;;
      esac
    done
    if (( dump )); then
      reply=()
      shift $((OPTIND-1))
      (( ARGC )) || set -- "*"
      for opt; do
        for k in ${(u@)_p9k_display_k[(I)$opt]:/(#m)*/$_p9k_display_k[$MATCH]}; do
          reply+=($_p9k__display_v[k,k+1])
        done
      done
      return 0
    fi
    for opt in "${@:$OPTIND}"; do
      pair=(${(s:=:)opt})
      list=(${(s:,:)${pair[2]}})
      if [[ ${(b)pair[1]} == $pair[1] ]]; then
        local ks=($_p9k_display_k[$pair[1]])
      else
        local ks=(${(u@)_p9k_display_k[(I)$pair[1]]:/(#m)*/$_p9k_display_k[$MATCH]})
      fi
      for k in $ks; do
        if (( $#list == 1 )); then
          [[ $_p9k__display_v[k+1] == $list[1] ]] && continue
          new=$list[1]
        else
          new=${list[list[(I)$_p9k__display_v[k+1]]+1]:-$list[1]}
          [[ $_p9k__display_v[k+1] == $new ]] && continue
        fi
        _p9k__display_v[k+1]=$new
        name=$_p9k__display_v[k]
        if [[ $name == (empty_line|ruler) ]]; then
          var=_p9k__${name}_i
          [[ $new == hide ]] && typeset -gi $var=3 || unset $var
        elif [[ $name == (#b)(<->)(*) ]]; then
          var=_p9k__${match[1]}${${${${match[2]//\/}/#left/l}/#right/r}/#gap/g}
          [[ $new == hide ]] && typeset -g $var= || unset $var
        fi
      done
    done
  }'
      if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE )); then
        >&$fd print -r -- '  [[ $P9K_TTY == old ]] && { unset _p9k__empty_line_i; _p9k__display_v[2]=print }'
      fi
      if (( _POWERLEVEL9K_SHOW_RULER )); then
        >&$fd print -r -- '[[ $P9K_TTY == old ]] && { unset _p9k__ruler_i; _p9k__display_v[4]=print }'
      fi
      if (( $+functions[p10k-on-init] )); then
        >&$fd print -r -- '
  p10k-on-init() { '$functions[p10k-on-init]' }'
      fi
      if (( $+functions[p10k-on-pre-prompt] )); then
        >&$fd print -r -- '
  p10k-on-pre-prompt() { '$functions[p10k-on-pre-prompt]' }'
      fi
      if (( $+functions[p10k-on-post-prompt] )); then
        >&$fd print -r -- '
  p10k-on-post-prompt() { '$functions[p10k-on-post-prompt]' }'
      fi
      if (( $+functions[p10k-on-post-widget] )); then
        >&$fd print -r -- '
  p10k-on-post-widget() { '$functions[p10k-on-post-widget]' }'
      fi
      if (( $+functions[p10k-on-init] )); then
        >&$fd print -r -- '
  p10k-on-init'
      fi
      local pat idx var
      for pat idx var in $_p9k_show_on_command; do
        >&$fd print -r -- "
  local $var=
  _p9k__display_v[$idx]=hide"
      done
      if (( $+functions[p10k-on-pre-prompt] )); then
        >&$fd print -r -- '
  p10k-on-pre-prompt'
      fi
      if (( $+functions[p10k-on-init] )); then
        >&$fd print -r -- '
  unfunction p10k-on-init'
      fi
      if (( $+functions[p10k-on-pre-prompt] )); then
        >&$fd print -r -- '
  unfunction p10k-on-pre-prompt'
      fi
      if (( $+functions[p10k-on-post-prompt] )); then
        >&$fd print -r -- '
  unfunction p10k-on-post-prompt'
      fi
      if (( $+functions[p10k-on-post-widget] )); then
        >&$fd print -r -- '
  unfunction p10k-on-post-widget'
      fi
      >&$fd print -r -- '
  () {
'$functions[_p9k_init_toolbox]'
  }
  trap "unset -m _p9k__\*; unfunction p10k" EXIT
  local -a _p9k_t=("${(@ps:$us:)${tail%%$rs*}}")
  if [[ $+VTE_VERSION == 1 || $TERM_PROGRAM == Hyper ]] && (( $+commands[stty] )); then
    if [[ $TERM_PROGRAM == Hyper ]]; then
      local bad_lines=40 bad_columns=100
    else
      local bad_lines=24 bad_columns=80
    fi
    if (( LINES == bad_lines && COLUMNS == bad_columns )); then
      zmodload -F zsh/stat b:zstat || return
      zmodload zsh/datetime || return
      local -a tty_ctime
      if ! zstat -A tty_ctime +ctime -- $TTY 2>/dev/null || (( tty_ctime[1] + 2 > EPOCHREALTIME )); then
        local -F deadline=$((EPOCHREALTIME+0.025))
        local tty_size
        while true; do
          if (( EPOCHREALTIME > deadline )) || ! tty_size="$(command stty size 2>/dev/null)" || [[ $tty_size != <->" "<-> ]]; then
            (( $+_p9k__ruler_i )) || local -i _p9k__ruler_i=1
            local _p9k__g= _p9k__'$#_p9k_line_segments_right'r= _p9k__'$#_p9k_line_segments_right'r_frame=
            break
          fi
          if [[ $tty_size != "$bad_lines $bad_columns" ]]; then
            local lines_columns=(${=tty_size})
            local LINES=$lines_columns[1]
            local COLUMNS=$lines_columns[2]
            break
          fi
        done
      fi
    fi
  fi'
      (( __p9k_ksh_arrays )) && >&$fd print -r -- '  setopt ksh_arrays'
      (( __p9k_sh_glob )) && >&$fd print -r -- '  setopt sh_glob'
      >&$fd print -r -- '  typeset -ga __p9k_used_instant_prompt=("${(@e)_p9k_t[-3,-1]}")'
      (( __p9k_ksh_arrays )) && >&$fd print -r -- '  unsetopt ksh_arrays'
      (( __p9k_sh_glob )) && >&$fd print -r -- '  unsetopt sh_glob'
      >&$fd print -r -- '
  local -i prompt_height=${#${__p9k_used_instant_prompt[1]//[^$lf]}}
  (( height += prompt_height ))
  local _p9k__ret
  function _p9k_prompt_length() {
    local -i COLUMNS=1024
    local -i x y=${#1} m
    if (( y )); then
      while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
        x=y
        (( y *= 2 ))
      done
      while (( y > x + 1 )); do
        (( m = x + (y - x) / 2 ))
        (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
      done
    fi
    typeset -g _p9k__ret=$x
  }
  local out=${(%):-%b%k%f%s%u}
  if [[ $P9K_TTY == old && ( $+VTE_VERSION == 0 && $TERM_PROGRAM != Hyper || $+_p9k__g == 0 ) ]]; then
    local mark=${(e)PROMPT_EOL_MARK}
    [[ $mark == "%B%S%#%s%b" ]] && _p9k__ret=1 || _p9k_prompt_length $mark
    local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0))
    out+="${(%):-$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}"
  else
    out+="${(%):-$cr%E}"
  fi
  if (( _z4h_can_save_restore_screen != 1 )); then
    (( height )) && out+="${(pl.$height..$lf.)}$esc${height}A"
    out+="$terminfo[sc]"
  fi
  out+=${(%):-"$__p9k_used_instant_prompt[1]$__p9k_used_instant_prompt[2]"}
  if [[ -n $__p9k_used_instant_prompt[3] ]]; then
    _p9k_prompt_length "$__p9k_used_instant_prompt[2]"
    local -i left_len=_p9k__ret
    _p9k_prompt_length "$__p9k_used_instant_prompt[3]"
    if (( _p9k__ret )); then
      local -i gap=$((COLUMNS - left_len - _p9k__ret - ZLE_RPROMPT_INDENT))
      if (( gap >= 40 )); then
        out+="${(pl.$gap.. .)}${(%):-${__p9k_used_instant_prompt[3]}%b%k%f%s%u}$cr$esc${left_len}C"
      fi
    fi
  fi
  if (( _z4h_can_save_restore_screen == 1 )); then
    if (( height )); then
      out+="$cr${(pl:$((height-prompt_height))::\n:)}$esc${height}A$terminfo[sc]$out"
    else
      out+="$cr${(pl:$((height-prompt_height))::\n:)}$terminfo[sc]$out"
    fi
  fi
  if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
    local tmpdir=$TMPDIR
  else
    local tmpdir=/tmp
  fi
  typeset -g __p9k_instant_prompt_output=$tmpdir/p10k-instant-prompt-output-${(%):-%n}-$$
  { : > $__p9k_instant_prompt_output } || return
  print -rn -- "${out}${esc}?2004h" || return
  if (( $+commands[stty] )); then
    command stty -icanon 2>/dev/null
  fi
  local fd_null
  sysopen -ru fd_null /dev/null || return
  exec {__p9k_fd_0}<&0 {__p9k_fd_1}>&1 {__p9k_fd_2}>&2 0<&$fd_null 1>$__p9k_instant_prompt_output
  exec 2>&1 {fd_null}>&-
  typeset -gi __p9k_instant_prompt_active=1
  if (( _z4h_can_save_restore_screen == 1 )); then
    typeset -g _z4h_saved_screen
    -z4h-save-screen
  fi
  typeset -g __p9k_instant_prompt_dump_file=${XDG_CACHE_HOME:-~/.cache}/p10k-dump-${(%):-%n}.zsh
  if builtin source $__p9k_instant_prompt_dump_file 2>/dev/null && (( $+functions[_p9k_preinit] )); then
    _p9k_preinit
  fi
  function _p9k_instant_prompt_cleanup() {
    (( ZSH_SUBSHELL == 0 && ${+__p9k_instant_prompt_active} )) || return 0
    '$__p9k_intro_no_locale'
    unset __p9k_instant_prompt_active
    exec 0<&$__p9k_fd_0 1>&$__p9k_fd_1 2>&$__p9k_fd_2 {__p9k_fd_0}>&- {__p9k_fd_1}>&- {__p9k_fd_2}>&-
    unset __p9k_fd_0 __p9k_fd_1 __p9k_fd_2
    typeset -gi __p9k_instant_prompt_erased=1
    if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 )); then
      -z4h-restore-screen
      unset _z4h_saved_screen
    fi
    print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
    if [[ -s $__p9k_instant_prompt_output ]]; then
      command cat $__p9k_instant_prompt_output 2>/dev/null
      if (( $1 )); then
        local _p9k__ret mark="${(e)${PROMPT_EOL_MARK-%B%S%#%s%b}}"
        _p9k_prompt_length $mark
        local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0))
        echo -nE - "${(%):-%b%k%f%s%u$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}"
      fi
    fi
    zshexit_functions=(${zshexit_functions:#_p9k_instant_prompt_cleanup})
    zmodload -F zsh/files b:zf_rm || return
    local user=${(%):-%n}
    local root_dir=${__p9k_instant_prompt_dump_file:h}
    zf_rm -f -- $__p9k_instant_prompt_output $__p9k_instant_prompt_dump_file{,.zwc} $root_dir/p10k-instant-prompt-$user.zsh{,.zwc} $root_dir/p10k-$user/prompt-*(N) 2>/dev/null
  }
  function _p9k_instant_prompt_precmd_first() {
    '$__p9k_intro'
    function _p9k_instant_prompt_sched_last() {
      (( ${+__p9k_instant_prompt_active} )) || return 0
      _p9k_instant_prompt_cleanup 1
      setopt no_local_options prompt_cr prompt_sp
    }
    zmodload zsh/sched
    sched +0 _p9k_instant_prompt_sched_last
    precmd_functions=(${(@)precmd_functions:#_p9k_instant_prompt_precmd_first})
  }
  zshexit_functions=(_p9k_instant_prompt_cleanup $zshexit_functions)
  precmd_functions=(_p9k_instant_prompt_precmd_first $precmd_functions)
  DISABLE_UPDATE_PROMPT=true
} && unsetopt prompt_cr prompt_sp && typeset -gi __p9k_instant_prompt_sourced='$__p9k_instant_prompt_version' ||
  typeset -gi __p9k_instant_prompt_sourced=${__p9k_instant_prompt_sourced:-0}'
    } always {
      exec {fd}>&-
    }
    {
      (( ! $? ))                          || return
      # `zf_mv -f src dst` fails on NTFS if `dst` is not writable, hence `zf_rm`.
      zf_rm -f -- $root_file.zwc          || return
      zf_mv -f -- $tmp $root_file         || return
      zcompile -R -- $tmp.zwc $root_file  || return
      zf_mv -f -- $tmp.zwc $root_file.zwc || return
    } always {
      (( $? )) && zf_rm -f -- $tmp $tmp.zwc 2>/dev/null
    }
  fi

  local tmp=$prompt_file.tmp.$$
  zf_mv -f -- $prompt_file $tmp 2>/dev/null
  if [[ "$(<$tmp)" == *$'\x1e'$_p9k__instant_prompt_sig$'\x1f'* ]] 2>/dev/null; then
    echo -n >$tmp || return
  fi

  local -i fd
  sysopen -a -m 600 -o creat -u fd -- $tmp || return
  {
    {
      print -rnu $fd -- $'\x1e'$_p9k__instant_prompt_sig$'\x1f'${(pj:\x1f:)_p9k_t}$'\x1f'$_p9k__instant_prompt || return
    } always {
      exec {fd}>&-
    }
    zf_mv -f -- $tmp $prompt_file || return
  } always {
    (( $? )) && zf_rm -f -- $tmp 2>/dev/null
  }
}

typeset -gi __p9k_sh_glob
typeset -gi __p9k_ksh_arrays
typeset -gi __p9k_new_status
typeset -ga __p9k_new_pipestatus

_p9k_save_status() {
  local -i pipe
  if (( !$+_p9k__line_finished )); then
    :  # SIGINT
  elif (( !$+_p9k__preexec_cmd )); then
    # Empty line, comment or parse error.
    #
    # This case is handled incorrectly:
    #
    #   true | false
    #   |
    #
    # Here status=1 and pipestatus=(0 1). Ideally we should ignore pipestatus but we won't.
    #
    # This works though (unless pipefail is set):
    #
    #   false | true
    #   |
    #
    # We get status=1 and pipestatus=(1 0) and correctly ignore pipestatus.
    (( _p9k__status == __p9k_new_status )) && return
  elif (( $__p9k_new_pipestatus[(I)$__p9k_new_status] )); then  # just in case
    local cmd=(${(z)_p9k__preexec_cmd})
    if [[ $#cmd != 0 && $cmd[1] != '!' && ${(Q)cmd[1]} != coproc ]]; then
      local arg
      for arg in ${(z)_p9k__preexec_cmd}; do
        # '()' is for functions, *';' is for complex commands.
        if [[ $arg == ('()'|'&&'|'||'|'&'|'&|'|'&!'|*';') ]]; then
          pipe=0
          break
        elif [[ $arg == *('|'|'|&')* ]]; then
          pipe=1
        fi
      done
    fi
  fi
  _p9k__status=$__p9k_new_status
  if (( pipe )); then
    _p9k__pipestatus=($__p9k_new_pipestatus)
  else
    _p9k__pipestatus=($_p9k__status)
  fi
}

function _p9k_dump_state() {
  local dir=${__p9k_dump_file:h}
  [[ -d $dir ]] || mkdir -p -- $dir || return
  [[ -w $dir ]] || return
  local tmp=$__p9k_dump_file.tmp.$$
  local -i fd
  sysopen -a -m 600 -o creat,trunc -u fd -- $tmp || return
  {
    {
      typeset -g __p9k_cached_param_pat=$_p9k__param_pat
      typeset -g __p9k_cached_param_sig=$_p9k__param_sig
      typeset -pm __p9k_cached_param_pat __p9k_cached_param_sig >&$fd || return
      unset __p9k_cached_param_pat __p9k_cached_param_sig
      (( $+_p9k_preinit )) && { print -r -- $_p9k_preinit >&$fd || return }
      print -r -- '_p9k_restore_state_impl() {' >&$fd || return
      typeset -pm '_POWERLEVEL9K_*|_p9k_[^_]*|icons' >&$fd || return
      print -r -- '}' >&$fd || return
    } always {
      exec {fd}>&-
    }
    # `zf_mv -f src dst` fails on NTFS if `dst` is not writable, hence `zf_rm`.
    zf_rm -f -- $__p9k_dump_file.zwc          || return
    zf_mv -f -- $tmp $__p9k_dump_file         || return
    zcompile -R -- $tmp.zwc $__p9k_dump_file  || return
    zf_mv -f -- $tmp.zwc $__p9k_dump_file.zwc || return
  } always {
    (( $? )) && zf_rm -f -- $tmp $tmp.zwc 2>/dev/null
  }
}

function _p9k_delete_instant_prompt() {
  local user=${(%):-%n}
  local root_dir=${__p9k_dump_file:h}
  zf_rm -f -- $root_dir/p10k-instant-prompt-$user.zsh{,.zwc} ${root_dir}/p10k-$user/prompt-*(N) 2>/dev/null
}

function _p9k_restore_state() {
  {
    [[ $__p9k_cached_param_pat == $_p9k__param_pat && $__p9k_cached_param_sig == $_p9k__param_sig ]] || return
    (( $+functions[_p9k_restore_state_impl] )) || return
    _p9k_restore_state_impl
    return 0
  } always {
    if (( $? )); then
      if (( $+functions[_p9k_preinit] )); then
        unfunction _p9k_preinit
        (( $+functions[gitstatus_stop_p9k_] )) && gitstatus_stop_p9k_ POWERLEVEL9K
      fi
      _p9k_delete_instant_prompt
      zf_rm -f -- $__p9k_dump_file{,.zwc} 2>/dev/null
    elif [[ $__p9k_instant_prompt_param_sig != $_p9k__param_sig ]]; then
      _p9k_delete_instant_prompt
      _p9k_dumped_instant_prompt_sigs=()
    fi
    unset __p9k_cached_param_sig
  }
}

function _p9k_clear_instant_prompt() {
  if (( $+__p9k_fd_0 )); then
    exec 0<&$__p9k_fd_0 {__p9k_fd_0}>&-
    unset __p9k_fd_0
  fi
  exec 1>&$__p9k_fd_1 2>&$__p9k_fd_2 {__p9k_fd_1}>&- {__p9k_fd_2}>&-
  unset __p9k_fd_1 __p9k_fd_2
  zshexit_functions=(${zshexit_functions:#_p9k_instant_prompt_cleanup})
  if (( _p9k__can_hide_cursor )); then
    echoti civis
    _p9k__cursor_hidden=1
  fi
  if [[ -s $__p9k_instant_prompt_output ]]; then
    {
      local content
      [[ $_POWERLEVEL9K_INSTANT_PROMPT == verbose ]] && content="$(<$__p9k_instant_prompt_output)"
      local mark="${(e)${PROMPT_EOL_MARK-%B%S%#%s%b}}"
      _p9k_prompt_length $mark
      local -i fill=$((COLUMNS > _p9k__ret ? COLUMNS - _p9k__ret : 0))
      local cr=$'\r'
      local sp="${(%):-%b%k%f%s%u$mark${(pl.$fill.. .)}$cr%b%k%f%s%u%E}"
      if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 )); then
        -z4h-restore-screen
        unset _z4h_saved_screen
      fi
      print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
      local unexpected=${(S)${${content//$'\e[?'<->'c'}//$'\e['<->' q'}//$'\e'[^$'\a\e']#($'\a'|$'\e\\')}
      # Visual Studio Code prints this garbage.
      unexpected=${unexpected//$'\033[1;32mShell integration activated\033[0m\n'}
      if [[ -n $unexpected ]]; then
        local omz1='[Oh My Zsh] Would you like to update? [Y/n]: '
        local omz2='Updating Oh My Zsh'
        local omz3='https://shop.planetargon.com/collections/oh-my-zsh'
        local omz4='There was an error updating. Try again later?'
        if [[ $unexpected != ($omz1|)$omz2*($omz3|$omz4)[^$'\n']#($'\n'|) ]]; then
          echo -E - ""
          echo -E - "${(%):-[%3FWARNING%f]: Console output during zsh initialization detected.}"
          echo -E - ""
          echo -E - "${(%):-When using Powerlevel10k with instant prompt, console output during zsh}"
          echo -E - "${(%):-initialization may indicate issues.}"
          echo -E - ""
          echo -E - "${(%):-You can:}"
          echo -E - ""
          echo -E - "${(%):-  - %BRecommended%b: Change %B$__p9k_zshrc_u%b so that it does not perform console I/O}"
          echo -E - "${(%):-    after the instant prompt preamble. See the link below for details.}"
          echo -E - ""
          echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
          echo -E - "${(%):-    * Zsh will start %Bquickly%b and prompt will update %Bsmoothly%b.}"
          echo -E - ""
          echo -E - "${(%):-  - Suppress this warning either by running %Bp10k configure%b or by manually}"
          echo -E - "${(%):-    defining the following parameter:}"
          echo -E - ""
          echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=quiet}"
          echo -E - ""
          echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
          echo -E - "${(%):-    * Zsh will start %Bquickly%b but prompt will %Bjump down%b after initialization.}"
          echo -E - ""
          echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}"
          echo -E - "${(%):-    defining the following parameter:}"
          echo -E - ""
          echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}"
          echo -E - ""
          echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
          echo -E - "${(%):-    * Zsh will start %Bslowly%b.}"
          echo -E - ""
          echo -E - "${(%):-  - Do nothing.}"
          echo -E - ""
          echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}"
          echo -E - "${(%):-    * Zsh will start %Bquickly%b but prompt will %Bjump down%b after initialization.}"
          echo -E - ""
          echo -E - "${(%):-For details, see:}"
          if (( _p9k_term_has_href )); then
            echo    - "${(%):-\e]8;;https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt\ahttps://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt\e]8;;\a}"
          else
            echo    - "${(%):-https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt}"
          fi
          echo -E - ""
          echo    - "${(%):-%3F-- console output produced during zsh initialization follows --%f}"
          echo -E - ""
        fi
      fi
      command cat -- $__p9k_instant_prompt_output
      echo -nE - $sp
      zf_rm -f -- $__p9k_instant_prompt_output
    } 2>/dev/null
  else
    zf_rm -f -- $__p9k_instant_prompt_output 2>/dev/null
    if (( _z4h_can_save_restore_screen == 1 && __p9k_instant_prompt_sourced >= 35 )); then
      -z4h-restore-screen
      unset _z4h_saved_screen
    fi
    print -rn -- $terminfo[rc]${(%):-%b%k%f%s%u}$terminfo[ed]
  fi
  prompt_opts=(percent subst sp cr)
  if [[ $_POWERLEVEL9K_DISABLE_INSTANT_PROMPT == 0 && $__p9k_instant_prompt_active == 2 ]]; then
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-[%1FERROR%f]: When using Powerlevel10k with instant prompt, %Bprompt_cr%b must be unset.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-You can:}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-  - %BRecommended%b: call %Bp10k finalize%b at the end of %B$__p9k_zshrc_u%b.}"
    >&2 echo -E - "${(%):-    You can do this by running the following command:}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-      %2Fecho%f %3F'(( ! \${+functions[p10k]\} )) || p10k finalize'%f >>! $__p9k_zshrc_u}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
    >&2 echo -E - "${(%):-    * Zsh will start %Bquickly%b and %Bwithout%b prompt flickering.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-  - Find where %Bprompt_cr%b option gets sets in your zsh configs and stop setting it.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
    >&2 echo -E - "${(%):-    * Zsh will start %Bquickly%b and %Bwithout%b prompt flickering.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}"
    >&2 echo -E - "${(%):-    defining the following parameter:}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
    >&2 echo -E - "${(%):-    * Zsh will start %Bslowly%b.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-  - Do nothing.}"
    >&2 echo -E - ""
    >&2 echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}"
    >&2 echo -E - "${(%):-    * Zsh will start %Bquckly%b but %Bwith%b prompt flickering.}"
    >&2 echo -E - ""
  fi
}

function _p9k_do_dump() {
  eval "$__p9k_intro"
  zle -F $1
  exec {1}>&-
  (( _p9k__state_dump_fd )) || return
  if (( ! _p9k__instant_prompt_disabled )); then
    _p9k__instant_prompt_sig=$_p9k__cwd:$P9K_SSH:${(%):-%#}
    _p9k_set_instant_prompt
    _p9k_dump_instant_prompt
    _p9k_dumped_instant_prompt_sigs[$_p9k__instant_prompt_sig]=1
  fi
  _p9k_dump_state
  _p9k__state_dump_scheduled=0
  _p9k__state_dump_fd=0
}

function _p9k_should_dump() {
  (( __p9k_dumps_enabled && ! _p9k__state_dump_fd )) || return
  (( _p9k__state_dump_scheduled || _p9k__prompt_idx == 1 )) && return
  _p9k__instant_prompt_sig=$_p9k__cwd:$P9K_SSH:${(%):-%#}
  (( ! $+_p9k_dumped_instant_prompt_sigs[$_p9k__instant_prompt_sig] ))
}

# Must not run under `eval "$__p9k_intro_locale"`. Safe to run with any options.
function _p9k_restore_special_params() {
  (( ! ${+_p9k__real_zle_rprompt_indent} )) || {
    [[ -n "$_p9k__real_zle_rprompt_indent" ]]             &&
      ZLE_RPROMPT_INDENT="$_p9k__real_zle_rprompt_indent" ||
      unset ZLE_RPROMPT_INDENT
    unset _p9k__real_zle_rprompt_indent
  }
  (( ! ${+_p9k__real_lc_ctype} )) || {
    LC_CTYPE="$_p9k__real_lc_ctype"
    unset _p9k__real_lc_ctype
  }
  (( ! ${+_p9k__real_lc_all} )) || {
    LC_ALL="$_p9k__real_lc_all"
    unset _p9k__real_lc_all
  }
}

function _p9k_on_expand() {
  (( _p9k__expanded && ! ${+__p9k_instant_prompt_active} )) && [[ "${langinfo[CODESET]}" == (utf|UTF)(-|)8 ]] && return

  eval "$__p9k_intro_no_locale"

  if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]]; then
    _p9k_restore_special_params
    if [[ $langinfo[CODESET] != (utf|UTF)(-|)8 ]] && _p9k_init_locale; then
      if [[ -n $LC_ALL ]]; then
        _p9k__real_lc_all=$LC_ALL
        LC_ALL=$__p9k_locale
      else
        _p9k__real_lc_ctype=$LC_CTYPE
        LC_CTYPE=$__p9k_locale
      fi
    fi
  fi

  (( _p9k__expanded && ! $+__p9k_instant_prompt_active )) && return

  eval "$__p9k_intro_locale"

  if (( ! _p9k__expanded )); then
    if _p9k_should_dump; then
      sysopen -o cloexec -ru _p9k__state_dump_fd /dev/null
      zle -F $_p9k__state_dump_fd _p9k_do_dump
    fi

    if [[ -z $P9K_TTY || $P9K_TTY == old && -n ${_P9K_TTY:#$TTY} ]]; then
      typeset -gx P9K_TTY=old
      if (( _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS < 0 )); then
        P9K_TTY=new
      else
        local -a stat
        if zstat -A stat +ctime -- $TTY 2>/dev/null &&
          (( EPOCHREALTIME - stat[1] < _POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS )); then
          P9K_TTY=new
        fi
      fi
    fi

    typeset -gx _P9K_TTY=$TTY

    __p9k_reset_state=1

    if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE )); then
      if [[ $P9K_TTY == new ]]; then
        _p9k__empty_line_i=3
        _p9k__display_v[2]=hide
      elif [[ -z $_p9k_transient_prompt && $+functions[p10k-on-post-prompt] == 0 ]]; then
        _p9k__empty_line_i=3
        _p9k__display_v[2]=print
      else
        unset _p9k__empty_line_i
        _p9k__display_v[2]=show
      fi
    fi

    if (( _POWERLEVEL9K_SHOW_RULER )); then
      if [[ $P9K_TTY == new ]]; then
        _p9k__ruler_i=3
        _p9k__display_v[4]=hide
      elif [[ -z $_p9k_transient_prompt && $+functions[p10k-on-post-prompt] == 0 ]]; then
        _p9k__ruler_i=3
        _p9k__display_v[4]=print
      else
        unset _p9k__ruler_i
        _p9k__display_v[4]=show
      fi
    fi

    (( _p9k__fully_initialized )) || _p9k_wrap_widgets
  fi

  if (( $+__p9k_instant_prompt_active )); then
    _p9k_clear_instant_prompt
    unset __p9k_instant_prompt_active
  fi

  if (( ! _p9k__expanded )); then
    _p9k__expanded=1

    (( _p9k__fully_initialized || ! $+functions[p10k-on-init] )) || p10k-on-init

    local pat idx var
    for pat idx var in $_p9k_show_on_command; do
      _p9k_display_segment $idx $var hide
    done

    (( $+functions[p10k-on-pre-prompt] )) && p10k-on-pre-prompt

    if zle; then
      local -a P9K_COMMANDS=($_p9k__last_commands)
      local pat idx var
      for pat idx var in $_p9k_show_on_command; do
        if (( $P9K_COMMANDS[(I)$pat] )); then
          _p9k_display_segment $idx $var show
        else
          _p9k_display_segment $idx $var hide
        fi
      done
      if (( $+functions[p10k-on-post-widget] )); then
        local -h WIDGET
        unset WIDGET
        p10k-on-post-widget
      fi
    else
      if [[ $_p9k__display_v[2] == print && -n $_p9k_t[_p9k_empty_line_idx] ]]; then
        print -rnP -- '%b%k%f%E'$_p9k_t[_p9k_empty_line_idx]
      fi
      if [[ $_p9k__display_v[4] == print ]]; then
        () {
          local ruler=$_p9k_t[_p9k_ruler_idx]
          local -i _p9k__clm=COLUMNS _p9k__ind=${ZLE_RPROMPT_INDENT:-1}
          (( __p9k_ksh_arrays )) && setopt ksh_arrays
          (( __p9k_sh_glob )) && setopt sh_glob
          setopt prompt_subst
          print -rnP -- '%b%k%f%E'$ruler
        }
      fi
    fi

    __p9k_reset_state=0
    _p9k__fully_initialized=1
  fi
}
functions -M _p9k_on_expand

_p9k_precmd_impl() {
  eval "$__p9k_intro"

  (( __p9k_enabled )) || return

  if ! zle || [[ -z $_p9k__param_sig ]]; then
    if zle; then
      __p9k_new_status=0
      __p9k_new_pipestatus=(0)
    else
      _p9k__must_restore_prompt=0
    fi

    if _p9k_must_init; then
      local -i instant_prompt_disabled
      if (( !__p9k_configured )); then
        __p9k_configured=1
        if [[ -z "${parameters[(I)POWERLEVEL9K_*~POWERLEVEL9K_(MODE|CONFIG_FILE|GITSTATUS_DIR)]}" ]]; then
          _p9k_can_configure -q
          local -i ret=$?
          if (( ret == 2 && $+__p9k_instant_prompt_active )); then
            _p9k_clear_instant_prompt
            unset __p9k_instant_prompt_active
            _p9k_delete_instant_prompt
            zf_rm -f -- $__p9k_dump_file{,.zwc} 2>/dev/null
            () {
              local key
              while true; do
                [[ -t 2 ]]
                read -t0 -k key || break
              done 2>/dev/null
            }
            _p9k_can_configure -q
            ret=$?
          fi
          if (( ret == 0 )); then
            if (( $+commands[git] )); then
              (
                local -i pid
                {
                  { /bin/sh "$__p9k_root_dir"/gitstatus/install </dev/null &>/dev/null & } && pid=$!
                  ( builtin source "$__p9k_root_dir"/internal/wizard.zsh )
                } always {
                  if (( pid )); then
                    kill -- $pid 2>/dev/null
                    wait -- $pid 2>/dev/null
                  fi
                }
              )
            else
              ( builtin source "$__p9k_root_dir"/internal/wizard.zsh )
            fi
            if (( $? )); then
              instant_prompt_disabled=1
            else
              builtin source "$__p9k_cfg_path"
              _p9k__force_must_init=1
              _p9k_must_init
            fi
          fi
        fi
      fi
      typeset -gi _p9k__instant_prompt_disabled=instant_prompt_disabled
      _p9k_init
    fi

    if (( _p9k__timer_start )); then
      typeset -gF P9K_COMMAND_DURATION_SECONDS=$((EPOCHREALTIME - _p9k__timer_start))
    else
      unset P9K_COMMAND_DURATION_SECONDS
    fi
    _p9k_save_status

    if [[ $_p9k__preexec_cmd == [[:space:]]#(clear([[:space:]]##-(|x)(|T[a-zA-Z0-9-_\'\"]#))#|reset)[[:space:]]# &&
          $_p9k__status == 0 ]]; then
      P9K_TTY=new
    elif [[ $P9K_TTY == new && $_p9k__fully_initialized == 1 ]] && ! zle; then
      P9K_TTY=old
    fi

    _p9k__timer_start=0
    _p9k__region_active=0

    unset _p9k__line_finished _p9k__preexec_cmd
    _p9k__keymap=main
    _p9k__zle_state=insert

    (( ++_p9k__prompt_idx ))

    if (( $+_p9k__iterm_cmd )); then
      _p9k_iterm2_precmd $__p9k_new_status
    fi
  fi

  _p9k_fetch_cwd

  _p9k__refresh_reason=precmd
  __p9k_reset_state=1

  local -i fast_vcs
  if (( _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
    if [[ $_p9k__cwd != $~_POWERLEVEL9K_VCS_DISABLED_DIR_PATTERN ]]; then
      local -F start_time=EPOCHREALTIME
      unset _p9k__vcs
      unset _p9k__vcs_timeout
      local -i _p9k__vcs_called
      _p9k_vcs_gitstatus
      local -i fast_vcs=1
    fi
  fi

  (( $+functions[_p9k_async_segments_compute] )) && _p9k_async_segments_compute

  _p9k__expanded=0

  _p9k_set_prompt

  _p9k__refresh_reason=''

  if [[ $precmd_functions[1] != _p9k_do_nothing && $precmd_functions[(I)_p9k_do_nothing] != 0 ]]; then
    precmd_functions=(_p9k_do_nothing ${(@)precmd_functions:#_p9k_do_nothing})
  fi
  if [[ $precmd_functions[-1] != _p9k_precmd && $precmd_functions[(I)_p9k_precmd] != 0 ]]; then
    precmd_functions=(${(@)precmd_functions:#_p9k_precmd} _p9k_precmd)
  fi
  if [[ $preexec_functions[1] != _p9k_preexec1 && $preexec_functions[(I)_p9k_preexec1] != 0 ]]; then
    preexec_functions=(_p9k_preexec1 ${(@)preexec_functions:#_p9k_preexec1})
  fi
  if [[ $preexec_functions[-1] != _p9k_preexec2 && $preexec_functions[(I)_p9k_preexec2] != 0 ]]; then
    preexec_functions=(${(@)preexec_functions:#_p9k_preexec2} _p9k_preexec2)
  fi

  if (( fast_vcs && _p9k_vcs_index && $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
    if (( $+_p9k__vcs_timeout )); then
      (( _p9k__vcs_timeout = _POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS + start_time - EPOCHREALTIME ))
      (( _p9k__vcs_timeout >= 0 )) || (( _p9k__vcs_timeout = 0 ))
      gitstatus_process_results_p9k_ -t $_p9k__vcs_timeout POWERLEVEL9K
    fi
    if (( ! $+_p9k__vcs )); then
      local _p9k__prompt _p9k__prompt_side=$_p9k_vcs_side _p9k__segment_name=vcs
      local -i _p9k__has_upglob _p9k__segment_index=_p9k_vcs_index _p9k__line_index=_p9k_vcs_line_index
      _p9k_vcs_render
      typeset -g _p9k__vcs=$_p9k__prompt
    fi
  fi

  _p9k_worker_receive
  __p9k_reset_state=0
}

_p9k_trapint() {
  if (( __p9k_enabled )); then
    eval "$__p9k_intro"
    _p9k_deschedule_redraw
    zle && _p9k_on_widget_zle-line-finish int
  fi
  return 0
}

_p9k_precmd() {
  __p9k_new_status=$?
  __p9k_new_pipestatus=($pipestatus)

  trap ":" INT

  [[ -o ksh_arrays ]] && __p9k_ksh_arrays=1 || __p9k_ksh_arrays=0
  [[ -o sh_glob ]] && __p9k_sh_glob=1 || __p9k_sh_glob=0
  _p9k_restore_special_params

  _p9k_precmd_impl

  [[ ${+__p9k_instant_prompt_active} == 0 || -o no_prompt_cr ]] || __p9k_instant_prompt_active=2
  setopt no_local_options no_prompt_bang prompt_percent prompt_subst prompt_cr prompt_sp

  # See https://www.zsh.org/mla/workers/2020/msg00612.html for the reason behind __p9k_trapint.
  typeset -g __p9k_trapint='_p9k_trapint; return 130'
  trap "$__p9k_trapint" INT

  : ${(%):-%b%k%s%u}
}

function _p9k_reset_prompt() {
  if (( __p9k_reset_state != 1 )) && zle && [[ -z $_p9k__line_finished ]]; then
    __p9k_reset_state=0
    setopt prompt_subst
    (( __p9k_ksh_arrays )) && setopt ksh_arrays
    (( __p9k_sh_glob )) && setopt sh_glob
    {
      (( _p9k__can_hide_cursor )) && echoti civis
      zle .reset-prompt
      (( ${+functions[z4h]} )) || zle -R
    } always {
      (( _p9k__can_hide_cursor )) && print -rn -- $_p9k__cnorm
      _p9k__cursor_hidden=0
    }
  fi
}

# Does ZSH have a certain off-by-one bug that triggers when PROMPT overflows to a new line?
#
# Bug: https://github.com/zsh-users/zsh/commit/d8d9fee137a5aa2cf9bf8314b06895bfc2a05518.
# ZSH_PATCHLEVEL=zsh-5.4.2-159-gd8d9fee13. Released in 5.5.
#
# Fix: https://github.com/zsh-users/zsh/commit/64d13738357c9b9c212adbe17f271716abbcf6ea.
# ZSH_PATCHLEVEL=zsh-5.7.1-50-g64d137383.
#
# Test: PROMPT="${(pl:$((COLUMNS))::-:)}<%1(l.%2(l.FAIL.PASS).FAIL)> " zsh -dfis <<<exit
# Workaround: PROMPT="${(pl:$((COLUMNS))::-:)}%{%G%}<%1(l.%2(l.FAIL.PASS).FAIL)> " zsh -dfis <<<exit
function _p9k_prompt_overflow_bug() {
  [[ $ZSH_PATCHLEVEL =~ '^zsh-5\.4\.2-([0-9]+)-' ]] && return $(( match[1] < 159 ))
  [[ $ZSH_PATCHLEVEL =~ '^zsh-5\.7\.1-([0-9]+)-' ]] && return $(( match[1] >= 50 ))
  is-at-least 5.5 && ! is-at-least 5.7.2
}

typeset -g  _p9k__param_pat
typeset -g  _p9k__param_sig

_p9k_init_vars() {
  typeset -gF _p9k__gcloud_last_fetch_ts
  typeset -g  _p9k_gcloud_configuration
  typeset -g  _p9k_gcloud_account
  typeset -g  _p9k_gcloud_project_id
  typeset -g  _p9k_gcloud_project_name

  typeset -gi _p9k_term_has_href

  typeset -gi _p9k_vcs_index
  typeset -gi _p9k_vcs_line_index
  typeset -g  _p9k_vcs_side

  typeset -ga _p9k_taskwarrior_meta_files
  typeset -ga _p9k_taskwarrior_meta_non_files
  typeset -g  _p9k_taskwarrior_meta_sig
  typeset -g  _p9k_taskwarrior_data_dir
  typeset -g  _p9k__taskwarrior_functional=1
  typeset -ga _p9k_taskwarrior_data_files
  typeset -ga _p9k_taskwarrior_data_non_files
  typeset -g  _p9k_taskwarrior_data_sig
  typeset -gA _p9k_taskwarrior_counters
  typeset -gF _p9k_taskwarrior_next_due

  typeset -ga _p9k_asdf_meta_files
  typeset -ga _p9k_asdf_meta_non_files
  typeset -g  _p9k_asdf_meta_sig

  # plugin => installed_version_pattern
  # example: (ruby '2.7.0|2.6.3|system' lua 'system' chubaka '1.0.0|system')
  typeset -gA _p9k_asdf_plugins

  # example: (.ruby-version "ruby 1 chubaka 0")
  #
  # - "1" means parse-legacy-file is present
  # - "chubaka" is another plugin that claims to be able to parse .ruby-version
  typeset -gA _p9k_asdf_file_info

  # dir => mtime ':' ${(pj:\0:)files}
  typeset -gA _p9k__asdf_dir2files

  # :file       => mtime ':' ${(pj:\0:)tool_versions}
  # plugin:file => mtime ':' version
  typeset -gA _p9k_asdf_file2versions

  # filepath => mtime ':' word
  typeset -gA _p9k__read_word_cache
  # filepath:prefix => mtime ':' versions
  typeset -gA _p9k__read_pyenv_like_version_file_cache

  # _p9k__parent_dirs and _p9k__parent_mtimes are parallel arrays. They are updated
  # together with _p9k__cwd. _p9k__parent_mtimes[i] is mtime for _p9k__parent_dirs[i].
  #
  # When _p9k__cwd is / or ~, both arrays are empty. When _p9k__cwd is ~/foo/bar,
  # _p9k__parent_dirs is (/home/user/foo/bar /home/user/foo). When _p9k__cwd is
  # /foo/bar, it's (/foo/bar /foo).
  #
  # $_p9k__parent_mtimes_i[i] == "$i:$_p9k__parent_mtimes[i]"
  # $_p9k__parent_mtimes_s == "$_p9k__parent_mtimes_i".
  typeset -ga _p9k__parent_dirs
  typeset -ga _p9k__parent_mtimes
  typeset -ga _p9k__parent_mtimes_i
  typeset -g  _p9k__parent_mtimes_s

  typeset -g  _p9k__cwd
  typeset -g  _p9k__cwd_a

  # dir/pattern => dir mtime ':' num_matches
  typeset -gA _p9k__glob_cache

  # dir/pattern => space-separated parent dir mtimes ' :' the first matching parent dir
  # Note: ' :' is indeed the delimiter.
  typeset -gA _p9k__upsearch_cache

  typeset -g  _p9k_timewarrior_dir
  typeset -gi _p9k_timewarrior_dir_mtime
  typeset -gi _p9k_timewarrior_file_mtime
  typeset -g  _p9k_timewarrior_file_name
  typeset -gA _p9k__prompt_char_saved
  typeset -g  _p9k__worker_pid
  typeset -g  _p9k__worker_req_fd
  typeset -g  _p9k__worker_resp_fd
  typeset -g  _p9k__worker_shell_pid
  typeset -g  _p9k__worker_file_prefix
  typeset -gA _p9k__worker_request_map
  typeset -ga _p9k__segment_cond_left
  typeset -ga _p9k__segment_cond_right
  typeset -ga _p9k__segment_val_left
  typeset -ga _p9k__segment_val_right
  typeset -ga _p9k_show_on_command
  typeset -g  _p9k__last_buffer
  typeset -ga _p9k__last_commands
  typeset -gi  _p9k__fully_initialized
  typeset -gi _p9k__must_restore_prompt
  typeset -gi _p9k__restore_prompt_fd
  typeset -gi _p9k__redraw_fd
  typeset -gi _p9k__can_hide_cursor=$(( $+terminfo[civis] && $+terminfo[cnorm] ))
  if (( _p9k__can_hide_cursor )); then
    # See https://github.com/romkatv/powerlevel10k/issues/1699
    if [[ $terminfo[cnorm] == *$'\e[?25h'(|'\e'*) ]]; then
      typeset -g _p9k__cnorm=$'\e[?25h'
    else
      typeset -g _p9k__cnorm=$terminfo[cnorm]
    fi
  fi
  typeset -gi _p9k__cursor_hidden
  typeset -gi _p9k__non_hermetic_expansion
  typeset -g  _p9k__time
  typeset -g  _p9k__date
  typeset -gA _p9k_dumped_instant_prompt_sigs
  typeset -g  _p9k__instant_prompt_sig
  typeset -g  _p9k__instant_prompt
  typeset -gi _p9k__state_dump_scheduled
  typeset -gi _p9k__state_dump_fd
  typeset -gi _p9k__prompt_idx
  typeset -gi _p9k_reset_on_line_finish
  typeset -gF _p9k__timer_start
  typeset -gi _p9k__status
  typeset -ga _p9k__pipestatus
  typeset -g  _p9k__ret
  typeset -g  _p9k__cache_key
  typeset -ga _p9k__cache_val
  typeset -g  _p9k__cache_stat_meta
  typeset -g  _p9k__cache_stat_fprint
  typeset -g  _p9k__cache_fprint_key
  typeset -gA _p9k_cache
  typeset -gA _p9k__cache_ephemeral
  typeset -ga _p9k_t
  typeset -g  _p9k__n
  typeset -gi _p9k__i
  typeset -g  _p9k__bg
  typeset -ga _p9k_left_join
  typeset -ga _p9k_right_join
  typeset -g  _p9k__public_ip
  typeset -g  _p9k__todo_command
  typeset -g  _p9k__todo_file
  typeset -g  _p9k__git_dir
  # git workdir => 1 if gitstatus is slow on it, 0 if it's fast.
  typeset -gA _p9k_git_slow
  # git workdir => the last state we've seen for it
  typeset -gA _p9k__gitstatus_last
  typeset -gF _p9k__gitstatus_start_time
  typeset -g  _p9k__prompt
  typeset -g  _p9k__rprompt
  typeset -g  _p9k__lprompt
  typeset -g  _p9k__prompt_side
  typeset -g  _p9k__segment_name
  typeset -gi _p9k__segment_index
  typeset -gi _p9k__line_index
  typeset -g  _p9k__refresh_reason
  typeset -gi _p9k__region_active
  typeset -ga _p9k_line_segments_left
  typeset -ga _p9k_line_segments_right
  typeset -ga _p9k_line_prefix_left
  typeset -ga _p9k_line_prefix_right
  typeset -ga _p9k_line_suffix_left
  typeset -ga _p9k_line_suffix_right
  typeset -ga _p9k_line_never_empty_right
  typeset -ga _p9k_line_gap_post
  typeset -g  _p9k__xy
  typeset -g  _p9k__clm
  typeset -g  _p9k__p
  typeset -gi _p9k__x
  typeset -gi _p9k__y
  typeset -gi _p9k__m
  typeset -gi _p9k__d
  typeset -gi _p9k__h
  typeset -gi _p9k__ind
  typeset -g  _p9k_gap_pre
  typeset -gi _p9k__ruler_i=3
  typeset -gi _p9k_ruler_idx
  typeset -gi _p9k__empty_line_i=3
  typeset -gi _p9k_empty_line_idx
  typeset -g  _p9k_prompt_prefix_left
  typeset -g  _p9k_prompt_prefix_right
  typeset -g  _p9k_prompt_suffix_left
  typeset -g  _p9k_prompt_suffix_right
  typeset -gi _p9k_emulate_zero_rprompt_indent
  typeset -gA _p9k_battery_states
  typeset -g  _p9k_os
  typeset -g  _p9k_os_icon
  typeset -g  _p9k_color1
  typeset -g  _p9k_color2
  typeset -g  _p9k__s
  typeset -g  _p9k__ss
  typeset -g  _p9k__sss
  typeset -g  _p9k__v
  typeset -g  _p9k__c
  typeset -g  _p9k__e
  typeset -g  _p9k__w
  typeset -gi _p9k__dir_len
  typeset -gi _p9k_num_cpus
  typeset -g  _p9k__keymap
  typeset -g  _p9k__zle_state
  typeset -g  _p9k_uname
  typeset -g  _p9k_uname_o
  typeset -g  _p9k_uname_m
  typeset -g  _p9k_transient_prompt
  typeset -g  _p9k__last_prompt_pwd
  typeset -gA _p9k_display_k
  typeset -ga _p9k__display_v

  typeset -gA _p9k__dotnet_stat_cache
  typeset -gA _p9k__dir_stat_cache
  typeset -gi _p9k__expanded
  typeset -gi _p9k__force_must_init

  typeset -g  P9K_VISUAL_IDENTIFIER
  typeset -g  P9K_CONTENT
  typeset -g  P9K_GAP
  typeset -g  P9K_PROMPT=regular
}

_p9k_init_params() {
  _p9k_declare -F POWERLEVEL9K_GCLOUD_REFRESH_PROJECT_NAME_SECONDS 60

  # invarint:  _POWERLEVEL9K_INSTANT_PROMPT == (verbose|quiet|off)
  # invariant: [[ ($_POWERLEVEL9K_INSTANT_PROMPT == off) == $_POWERLEVEL9K_DISABLE_INSTANT_PROMPT ]]
  _p9k_declare -s POWERLEVEL9K_INSTANT_PROMPT  # verbose, quiet, off
  if [[ $_POWERLEVEL9K_INSTANT_PROMPT == off ]]; then
    typeset -gi _POWERLEVEL9K_DISABLE_INSTANT_PROMPT=1
  else
    _p9k_declare -b POWERLEVEL9K_DISABLE_INSTANT_PROMPT 0
    if (( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT )); then
      _POWERLEVEL9K_INSTANT_PROMPT=off
    elif [[ $_POWERLEVEL9K_INSTANT_PROMPT != quiet ]]; then
      _POWERLEVEL9K_INSTANT_PROMPT=verbose
    fi
  fi

  (( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT )) && _p9k__instant_prompt_disabled=1

  _p9k_declare -s POWERLEVEL9K_TRANSIENT_PROMPT off
  [[ $_POWERLEVEL9K_TRANSIENT_PROMPT == (off|always|same-dir) ]] || _POWERLEVEL9K_TRANSIENT_PROMPT=off

  _p9k_declare -b POWERLEVEL9K_TERM_SHELL_INTEGRATION 0
  if [[ __p9k_force_term_shell_integration -eq 1 || $ITERM_SHELL_INTEGRATION_INSTALLED == Yes ]]; then
    _POWERLEVEL9K_TERM_SHELL_INTEGRATION=1
  fi

  _p9k_declare -s POWERLEVEL9K_WORKER_LOG_LEVEL
  _p9k_declare -i POWERLEVEL9K_COMMANDS_MAX_TOKEN_COUNT 64
  _p9k_declare -a POWERLEVEL9K_HOOK_WIDGETS --
  _p9k_declare -b POWERLEVEL9K_TODO_HIDE_ZERO_TOTAL 0
  _p9k_declare -b POWERLEVEL9K_TODO_HIDE_ZERO_FILTERED 0
  _p9k_declare -b POWERLEVEL9K_DISABLE_HOT_RELOAD 0
  _p9k_declare -F POWERLEVEL9K_NEW_TTY_MAX_AGE_SECONDS 5
  _p9k_declare -i POWERLEVEL9K_INSTANT_PROMPT_COMMAND_LINES
  _p9k_declare -a POWERLEVEL9K_LEFT_PROMPT_ELEMENTS -- context dir vcs
  _p9k_declare -a POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS -- status root_indicator background_jobs history time
  _p9k_declare -b POWERLEVEL9K_DISABLE_RPROMPT 0
  _p9k_declare -b POWERLEVEL9K_PROMPT_ADD_NEWLINE 0
  _p9k_declare -b POWERLEVEL9K_PROMPT_ON_NEWLINE 0
  _p9k_declare -b POWERLEVEL9K_RPROMPT_ON_NEWLINE 0
  _p9k_declare -b POWERLEVEL9K_SHOW_RULER 0
  _p9k_declare -i POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT 1
  _p9k_declare -s POWERLEVEL9K_COLOR_SCHEME dark
  _p9k_declare -s POWERLEVEL9K_GITSTATUS_DIR ""
  _p9k_declare -s POWERLEVEL9K_VCS_DISABLED_WORKDIR_PATTERN
  _p9k_declare -b POWERLEVEL9K_VCS_SHOW_SUBMODULE_DIRTY 0
  _p9k_declare -i POWERLEVEL9K_VCS_SHORTEN_LENGTH
  _p9k_declare -i POWERLEVEL9K_VCS_SHORTEN_MIN_LENGTH
  _p9k_declare -s POWERLEVEL9K_VCS_SHORTEN_STRATEGY
  if [[ $langinfo[CODESET] == (utf|UTF)(-|)8 ]]; then
    _p9k_declare -e POWERLEVEL9K_VCS_SHORTEN_DELIMITER '\u2026'
  else
    _p9k_declare -e POWERLEVEL9K_VCS_SHORTEN_DELIMITER '..'
  fi
  _p9k_declare -b POWERLEVEL9K_VCS_CONFLICTED_STATE 0
  _p9k_declare -b POWERLEVEL9K_HIDE_BRANCH_ICON 0
  _p9k_declare -b POWERLEVEL9K_VCS_HIDE_TAGS 0
  _p9k_declare -i POWERLEVEL9K_CHANGESET_HASH_LENGTH 8
  # Specifies the maximum number of elements in the cache. When the cache grows over this limit,
  # it gets cleared. This is meant to avoid memory leaks when a rogue prompt is filling the cache
  # with data.
  _p9k_declare -i POWERLEVEL9K_MAX_CACHE_SIZE 10000
  _p9k_declare -e POWERLEVEL9K_ANACONDA_LEFT_DELIMITER "("
  _p9k_declare -e POWERLEVEL9K_ANACONDA_RIGHT_DELIMITER ")"
  _p9k_declare -b POWERLEVEL9K_ANACONDA_SHOW_PYTHON_VERSION 1
  _p9k_declare -b POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE 1
  _p9k_declare -b POWERLEVEL9K_BACKGROUND_JOBS_VERBOSE_ALWAYS 0
  _p9k_declare -b POWERLEVEL9K_DISK_USAGE_ONLY_WARNING 0
  _p9k_declare -i POWERLEVEL9K_DISK_USAGE_WARNING_LEVEL 90
  _p9k_declare -i POWERLEVEL9K_DISK_USAGE_CRITICAL_LEVEL 95
  _p9k_declare -i POWERLEVEL9K_BATTERY_LOW_THRESHOLD 10
  _p9k_declare -i POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD 999
  _p9k_declare -b POWERLEVEL9K_BATTERY_VERBOSE 1
  _p9k_declare -a POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND --
  _p9k_declare -a POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND --
  case $parameters[POWERLEVEL9K_BATTERY_STAGES] in
    scalar*) typeset -ga _POWERLEVEL9K_BATTERY_STAGES=("${(@s::)${(g::)POWERLEVEL9K_BATTERY_STAGES}}");;
    array*)  typeset -ga _POWERLEVEL9K_BATTERY_STAGES=("${(@g::)POWERLEVEL9K_BATTERY_STAGES}");;
    *)       typeset -ga _POWERLEVEL9K_BATTERY_STAGES=();;
  esac
  local state
  for state in CHARGED CHARGING LOW DISCONNECTED; do
    _p9k_declare -i POWERLEVEL9K_BATTERY_${state}_HIDE_ABOVE_THRESHOLD $_POWERLEVEL9K_BATTERY_HIDE_ABOVE_THRESHOLD
    local var=POWERLEVEL9K_BATTERY_${state}_STAGES
    case $parameters[$var] in
      scalar*) eval "typeset -ga _$var=(${(@qq)${(@s::)${(g::)${(P)var}}}})";;
      array*)  eval "typeset -ga _$var=(${(@qq)${(@g::)${(@P)var}}})";;
      *)       eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_STAGES})";;
    esac
    local var=POWERLEVEL9K_BATTERY_${state}_LEVEL_BACKGROUND
    case $parameters[$var] in
      array*)  eval "typeset -ga _$var=(${(@qq)${(@P)var}})";;
      *)       eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_LEVEL_BACKGROUND})";;
    esac
    local var=POWERLEVEL9K_BATTERY_${state}_LEVEL_FOREGROUND
    case $parameters[$var] in
      array*)  eval "typeset -ga _$var=(${(@qq)${(@P)var}})";;
      *)       eval "typeset -ga _$var=(${(@qq)_POWERLEVEL9K_BATTERY_LEVEL_FOREGROUND})";;
    esac
  done
  _p9k_declare -F POWERLEVEL9K_PUBLIC_IP_TIMEOUT 300
  _p9k_declare -a POWERLEVEL9K_PUBLIC_IP_METHODS -- dig curl wget
  _p9k_declare -e POWERLEVEL9K_PUBLIC_IP_NONE ""
  _p9k_declare -s POWERLEVEL9K_PUBLIC_IP_HOST "https://v4.ident.me/"
  _p9k_declare -s POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ""
  _p9k_segment_in_use public_ip || _POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE=
  _p9k_declare -b POWERLEVEL9K_ALWAYS_SHOW_CONTEXT 0
  _p9k_declare -b POWERLEVEL9K_ALWAYS_SHOW_USER 0
  _p9k_declare -e POWERLEVEL9K_CONTEXT_TEMPLATE "%n@%m"
  _p9k_declare -e POWERLEVEL9K_USER_TEMPLATE "%n"
  _p9k_declare -e POWERLEVEL9K_HOST_TEMPLATE "%m"
  _p9k_declare -F POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD 3
  _p9k_declare -i POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION 2
  # Other options: "d h m s".
  _p9k_declare -s POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT "H:M:S"
  _p9k_declare -e POWERLEVEL9K_HOME_FOLDER_ABBREVIATION "~"
  _p9k_declare -b POWERLEVEL9K_DIR_PATH_ABSOLUTE 0
  _p9k_declare -s POWERLEVEL9K_DIR_SHOW_WRITABLE ''
  case $_POWERLEVEL9K_DIR_SHOW_WRITABLE in
    true) _POWERLEVEL9K_DIR_SHOW_WRITABLE=1;;
    v2)   _POWERLEVEL9K_DIR_SHOW_WRITABLE=2;;
    v3)   _POWERLEVEL9K_DIR_SHOW_WRITABLE=3;;
    *)    _POWERLEVEL9K_DIR_SHOW_WRITABLE=0;;
  esac
  typeset -gi _POWERLEVEL9K_DIR_SHOW_WRITABLE
  _p9k_declare -b POWERLEVEL9K_DIR_OMIT_FIRST_CHARACTER 0
  _p9k_declare -b POWERLEVEL9K_DIR_HYPERLINK 0
  _p9k_declare -s POWERLEVEL9K_SHORTEN_STRATEGY ""
  local markers=(
    .bzr
    .citc
    .git
    .hg
    .node-version
    .python-version
    .ruby-version
    .shorten_folder_marker
    .svn
    .terraform
    CVS
    Cargo.toml
    composer.json
    go.mod
    package.json
  )
  _p9k_declare -s POWERLEVEL9K_SHORTEN_FOLDER_MARKER "(${(j:|:)markers})"
  # Shorten directory if it's longer than this even if there is space for it.
  # The value can be either absolute (e.g., '80') or a percentage of terminal
  # width (e.g, '50%'). If empty, directory will be shortened only when prompt
  # doesn't fit. Applies only when POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique.
  _p9k_declare -s POWERLEVEL9K_DIR_MAX_LENGTH 0
  # Individual elements are patterns. They are expanded with the options set
  # by `emulate zsh && setopt extended_glob`.
  _p9k_declare -a POWERLEVEL9K_DIR_PACKAGE_FILES -- package.json composer.json
  # When dir is on the last prompt line, try to shorten it enough to leave at least this many
  # columns for typing commands. Applies only when POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique.
  _p9k_declare -i POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS 40
  # When dir is on the last prompt line, try to shorten it enough to leave at least
  # COLUMNS * POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT * 0.01 columns for typing commands. Applies
  # only when POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique.
  _p9k_declare -F POWERLEVEL9K_DIR_MIN_COMMAND_COLUMNS_PCT 50
  # POWERLEVEL9K_DIR_CLASSES allow you to specify custom styling and icons for different
  # directories.
  #
  # POWERLEVEL9K_DIR_CLASSES must be an array with 3 * N elements. Each triplet consists of:
  #
  #   1. A pattern against which the current directory is matched. Matching is done with
  #      extended_glob option enabled.
  #   2. Directory class for the purpose of styling.
  #   3. Icon.
  #
  # Triplets are tried in order. The first triplet whose pattern matches $PWD wins. If there are no
  # matches, there will be no icon and the styling is done according to POWERLEVEL9K_DIR_BACKGROUND,
  # POWERLEVEL9K_DIR_FOREGROUND, etc.
  #
  # Example:
  #
  #   POWERLEVEL9K_DIR_CLASSES=(
  #       '~/work(/*)#'  WORK     '(╯°□°）╯︵ ┻━┻'
  #       '~(/*)#'       HOME     '⌂'
  #       '*'            DEFAULT  '')
  #
  #   POWERLEVEL9K_DIR_WORK_BACKGROUND=red
  #   POWERLEVEL9K_DIR_HOME_BACKGROUND=blue
  #   POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=yellow
  #
  # With these settings, the current directory in the prompt may look like this:
  #
  #   (╯°□°）╯︵ ┻━┻ ~/work/projects/important/urgent
  #
  #   ⌂ ~/best/powerlevel10k
  _p9k_declare -a POWERLEVEL9K_DIR_CLASSES
  _p9k_declare -i POWERLEVEL9K_SHORTEN_DELIMITER_LENGTH
  _p9k_declare -e POWERLEVEL9K_SHORTEN_DELIMITER
  _p9k_declare -s POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER ''
  case $_POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER in
    first|last) _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER+=:0;;
    (first|last):(|-)<->);;
    *)     _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=;;
  esac
  [[ -z $_POWERLEVEL9K_SHORTEN_FOLDER_MARKER ]] && _POWERLEVEL9K_DIR_TRUNCATE_BEFORE_MARKER=
  _p9k_declare -i POWERLEVEL9K_SHORTEN_DIR_LENGTH
  _p9k_declare -s POWERLEVEL9K_IP_INTERFACE ""
  : ${_POWERLEVEL9K_IP_INTERFACE:='.*'}
  _p9k_segment_in_use ip || _POWERLEVEL9K_IP_INTERFACE=
  _p9k_declare -s POWERLEVEL9K_VPN_IP_INTERFACE "(gpd|wg|(.*tun)|tailscale)[0-9]*)|(zt.*)"
  : ${_POWERLEVEL9K_VPN_IP_INTERFACE:='.*'}
  _p9k_segment_in_use vpn_ip || _POWERLEVEL9K_VPN_IP_INTERFACE=
  _p9k_declare -b POWERLEVEL9K_VPN_IP_SHOW_ALL 0
  _p9k_declare -i POWERLEVEL9K_LOAD_WHICH 5
  case $_POWERLEVEL9K_LOAD_WHICH in
    1) _POWERLEVEL9K_LOAD_WHICH=1;;
    15) _POWERLEVEL9K_LOAD_WHICH=3;;
    *) _POWERLEVEL9K_LOAD_WHICH=2;;
  esac
  _p9k_declare -F POWERLEVEL9K_LOAD_WARNING_PCT 50
  _p9k_declare -F POWERLEVEL9K_LOAD_CRITICAL_PCT 70
  _p9k_declare -b POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY 0
  _p9k_declare -b POWERLEVEL9K_PHP_VERSION_PROJECT_ONLY 0
  _p9k_declare -b POWERLEVEL9K_DOTNET_VERSION_PROJECT_ONLY 1
  _p9k_declare -b POWERLEVEL9K_GO_VERSION_PROJECT_ONLY 1
  _p9k_declare -b POWERLEVEL9K_RUST_VERSION_PROJECT_ONLY 1
  _p9k_declare -b POWERLEVEL9K_PERLBREW_PROJECT_ONLY 1
  _p9k_declare -b POWERLEVEL9K_PERLBREW_SHOW_PREFIX 0
  _p9k_declare -b POWERLEVEL9K_JAVA_VERSION_PROJECT_ONLY 0
  _p9k_declare -b POWERLEVEL9K_NODENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_NODENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_NODENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_RBENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_RBENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_RBENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_SCALAENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_SCALAENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_SCALAENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_PHPENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_PHPENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_PHPENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_LUAENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_LUAENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_LUAENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_JENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_JENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_JENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_PLENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_PLENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_PLENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -b POWERLEVEL9K_PYENV_SHOW_SYSTEM 1
  _p9k_declare -a POWERLEVEL9K_PYENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -a POWERLEVEL9K_GOENV_SOURCES -- shell local global
  _p9k_declare -b POWERLEVEL9K_GOENV_SHOW_SYSTEM 1
  _p9k_declare -b POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW 0
  _p9k_declare -b POWERLEVEL9K_ASDF_SHOW_SYSTEM 1
  _p9k_declare -a POWERLEVEL9K_ASDF_SOURCES -- shell local global
  local var
  for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_PROMPT_ALWAYS_SHOW]}; do
    _p9k_declare -b $var $_POWERLEVEL9K_ASDF_PROMPT_ALWAYS_SHOW
  done
  for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_SHOW_SYSTEM]}; do
    _p9k_declare -b $var $_POWERLEVEL9K_ASDF_SHOW_SYSTEM
  done
  for var in ${parameters[(I)POWERLEVEL9K_ASDF_*_SOURCES]}; do
    _p9k_declare -a $var -- $_POWERLEVEL9K_ASDF_SOURCES
  done
  _p9k_declare -b POWERLEVEL9K_HASKELL_STACK_PROMPT_ALWAYS_SHOW 1
  _p9k_declare -a POWERLEVEL9K_HASKELL_STACK_SOURCES -- shell local
  _p9k_declare -b POWERLEVEL9K_RVM_SHOW_GEMSET 0
  _p9k_declare -b POWERLEVEL9K_RVM_SHOW_PREFIX 0
  _p9k_declare -b POWERLEVEL9K_CHRUBY_SHOW_VERSION 1
  _p9k_declare -b POWERLEVEL9K_CHRUBY_SHOW_ENGINE 1
  _p9k_declare -b POWERLEVEL9K_STATUS_CROSS 0
  _p9k_declare -b POWERLEVEL9K_STATUS_OK 1
  _p9k_declare -b POWERLEVEL9K_STATUS_OK_PIPE 1
  _p9k_declare -b POWERLEVEL9K_STATUS_ERROR 1
  _p9k_declare -b POWERLEVEL9K_STATUS_ERROR_PIPE 1
  _p9k_declare -b POWERLEVEL9K_STATUS_ERROR_SIGNAL 1
  _p9k_declare -b POWERLEVEL9K_STATUS_SHOW_PIPESTATUS 1
  _p9k_declare -b POWERLEVEL9K_STATUS_HIDE_SIGNAME 0
  _p9k_declare -b POWERLEVEL9K_STATUS_VERBOSE_SIGNAME 1
  _p9k_declare -b POWERLEVEL9K_STATUS_EXTENDED_STATES 0
  _p9k_declare -b POWERLEVEL9K_STATUS_VERBOSE 1
  _p9k_declare -b POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE 0
  _p9k_declare -e POWERLEVEL9K_DATE_FORMAT "%D{%d.%m.%y}"
  _p9k_declare -s POWERLEVEL9K_VCS_ACTIONFORMAT_FOREGROUND 1
  _p9k_declare -b POWERLEVEL9K_SHOW_CHANGESET 0
  _p9k_declare -e POWERLEVEL9K_VCS_LOADING_TEXT loading
  _p9k_declare -a POWERLEVEL9K_VCS_GIT_HOOKS -- vcs-detect-changes git-untracked git-aheadbehind git-stash git-remotebranch git-tagname
  _p9k_declare -a POWERLEVEL9K_VCS_HG_HOOKS -- vcs-detect-changes
  _p9k_declare -a POWERLEVEL9K_VCS_SVN_HOOKS -- vcs-detect-changes svn-detect-changes
  # If it takes longer than this to fetch git repo status, display the prompt with a greyed out
  # vcs segment and fix it asynchronously when the results come it.
  _p9k_declare -F POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS 0.01
  (( POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS >= 0 )) || (( POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS = 0 ))
  _p9k_declare -a POWERLEVEL9K_VCS_BACKENDS -- git
  (( $+commands[git] )) || _POWERLEVEL9K_VCS_BACKENDS=(${_POWERLEVEL9K_VCS_BACKENDS:#git})
  _p9k_declare -b POWERLEVEL9K_VCS_DISABLE_GITSTATUS_FORMATTING 0
  _p9k_declare -i POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY -1
  _p9k_declare -i POWERLEVEL9K_VCS_STAGED_MAX_NUM 1
  _p9k_declare -i POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM 1
  _p9k_declare -i POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM 1
  _p9k_declare -i POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM 1
  _p9k_declare -i POWERLEVEL9K_VCS_COMMITS_AHEAD_MAX_NUM -1
  _p9k_declare -i POWERLEVEL9K_VCS_COMMITS_BEHIND_MAX_NUM -1
  _p9k_declare -b POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS 0
  _p9k_declare -b POWERLEVEL9K_DISABLE_GITSTATUS 0
  _p9k_declare -e POWERLEVEL9K_VI_INSERT_MODE_STRING "INSERT"
  _p9k_declare -e POWERLEVEL9K_VI_COMMAND_MODE_STRING "NORMAL"
  # VISUAL mode is shown as NORMAL unless POWERLEVEL9K_VI_VISUAL_MODE_STRING is explicitly set.
  _p9k_declare -e POWERLEVEL9K_VI_VISUAL_MODE_STRING
  # OVERWRITE mode is shown as INSERT unless POWERLEVEL9K_VI_OVERWRITE_MODE_STRING is explicitly set.
  _p9k_declare -e POWERLEVEL9K_VI_OVERWRITE_MODE_STRING
  _p9k_declare -s POWERLEVEL9K_VIRTUALENV_SHOW_WITH_PYENV true
  _p9k_declare -b POWERLEVEL9K_VIRTUALENV_SHOW_PYTHON_VERSION 1
  _p9k_declare -e POWERLEVEL9K_VIRTUALENV_LEFT_DELIMITER "("
  _p9k_declare -e POWERLEVEL9K_VIRTUALENV_RIGHT_DELIMITER ")"
  _p9k_declare -a POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES -- virtualenv venv .venv env
  _POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES="${(j.|.)_POWERLEVEL9K_VIRTUALENV_GENERIC_NAMES}"
  _p9k_declare -b POWERLEVEL9K_NODEENV_SHOW_NODE_VERSION 1
  _p9k_declare -e POWERLEVEL9K_NODEENV_LEFT_DELIMITER "["
  _p9k_declare -e POWERLEVEL9K_NODEENV_RIGHT_DELIMITER "]"
  _p9k_declare -b POWERLEVEL9K_KUBECONTEXT_SHOW_DEFAULT_NAMESPACE 1
  _p9k_declare -a POWERLEVEL9K_KUBECONTEXT_SHORTEN --
  # Defines context classes for the purpose of applying different styling to different contexts.
  #
  # POWERLEVEL9K_KUBECONTEXT_CLASSES must be an array with even number of elements. The first
  # element in each pair defines a pattern against which the current context (in the format it is
  # displayed in the prompt) gets matched. The second element defines context class. Patterns are
  # tried in order. The first match wins.
  #
  # If a non-empty class <C> is assigned to a context, the segment is styled with
  # POWERLEVEL9K_KUBECONTEXT_<U>_BACKGROUND and POWERLEVEL9K_KUBECONTEXT_<U>_FOREGROUND where <U> is
  # uppercased <C>. Otherwise with POWERLEVEL9K_KUBECONTEXT_BACKGROUND and
  # POWERLEVEL9K_KUBECONTEXT_FOREGROUND.
  #
  # Example: Use red background for contexts containing "prod", green for "testing" and yellow for
  # everything else.
  #
  #   POWERLEVEL9K_KUBECONTEXT_CLASSES=(
  #       '*prod*'    prod
  #       '*testing*' testing
  #       '*'         other)
  #
  #   POWERLEVEL9K_KUBECONTEXT_PROD_BACKGROUND=red
  #   POWERLEVEL9K_KUBECONTEXT_TESTING_BACKGROUND=green
  #   POWERLEVEL9K_KUBECONTEXT_OTHER_BACKGROUND=yellow
  _p9k_declare -a POWERLEVEL9K_KUBECONTEXT_CLASSES --
  _p9k_declare -a POWERLEVEL9K_AWS_CLASSES --
  _p9k_declare -a POWERLEVEL9K_AZURE_CLASSES --
  _p9k_declare -a POWERLEVEL9K_TERRAFORM_CLASSES --
  _p9k_declare -b POWERLEVEL9K_TERRAFORM_SHOW_DEFAULT 0
  _p9k_declare -a POWERLEVEL9K_GOOGLE_APP_CRED_CLASSES -- 'service_account:*' SERVICE_ACCOUNT
  # Specifies the format of java version.
  #
  #   POWERLEVEL9K_JAVA_VERSION_FULL=true  => 1.8.0_212-8u212-b03-0ubuntu1.18.04.1-b03
  #   POWERLEVEL9K_JAVA_VERSION_FULL=false => 1.8.0_212
  #
  # These correspond to `java -fullversion` and `java -version` respectively.
  _p9k_declare -b POWERLEVEL9K_JAVA_VERSION_FULL 1
  _p9k_declare -b POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE 0

  # Format for the current time: 09:51:02. See `man 3 strftime`.
  _p9k_declare -e POWERLEVEL9K_TIME_FORMAT "%D{%H:%M:%S}"
  # If set to true, time will update when you hit enter. This way prompts for the past
  # commands will contain the start times of their commands as opposed to the default
  # behavior where they contain the end times of their preceding commands.
  _p9k_declare -b POWERLEVEL9K_TIME_UPDATE_ON_COMMAND 0
  # If set to true, time will update every second.
  _p9k_declare -b POWERLEVEL9K_EXPERIMENTAL_TIME_REALTIME 0

  local -i i=1
  while (( i <= $#_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS )); do
    local segment=${${(U)_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[i]}//İ/I}
    local var=POWERLEVEL9K_${segment}_LEFT_DISABLED
    (( $+parameters[$var] )) || var=POWERLEVEL9K_${segment}_DISABLED
    if [[ ${(P)var} == true ]]; then
      _POWERLEVEL9K_LEFT_PROMPT_ELEMENTS[i,i]=()
    else
      (( ++i ))
    fi
  done

  local -i i=1
  while (( i <= $#_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS )); do
    local segment=${${(U)_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[i]}//İ/I}
    local var=POWERLEVEL9K_${segment}_RIGHT_DISABLED
    (( $+parameters[$var] )) || var=POWERLEVEL9K_${segment}_DISABLED
    if [[ ${(P)var} == true ]]; then
      _POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS[i,i]=()
    else
      (( ++i ))
    fi
  done

  local var
  for var in ${(@)${parameters[(I)POWERLEVEL9K_*]}/(#m)*/${(M)${parameters[_$MATCH]-$MATCH}:#$MATCH}}; do
    case $parameters[$var] in
      (scalar|integer|float)*) typeset -g _$var=${(P)var};;
      array*)                  eval 'typeset -ga '_$var'=("${'$var'[@]}")';;
    esac
  done
}

function _p9k_on_widget_zle-keymap-select() { _p9k_check_visual_mode; __p9k_reset_state=2; }
function _p9k_on_widget_overwrite-mode()    { _p9k_check_visual_mode; __p9k_reset_state=2; }
function _p9k_on_widget_vi-replace()        { _p9k_check_visual_mode; __p9k_reset_state=2; }

if is-at-least 5.3; then
  function _p9k_check_visual_mode() {
    [[ ${KEYMAP:-} == vicmd ]] || return 0
    local region=${${REGION_ACTIVE:-0}/2/1}
    [[ $region != $_p9k__region_active ]] || return 0
    _p9k__region_active=$region
    __p9k_reset_state=2
  }
else
  function _p9k_check_visual_mode() {}
fi

function _p9k_on_widget_visual-mode()       { _p9k_check_visual_mode; }
function _p9k_on_widget_visual-line-mode()  { _p9k_check_visual_mode; }
function _p9k_on_widget_deactivate-region() { _p9k_check_visual_mode; }

function _p9k_on_widget_zle-line-init() {
  (( _p9k__cursor_hidden )) || return 0
  _p9k__cursor_hidden=0
  print -rn -- $_p9k__cnorm
}

function _p9k_on_widget_zle-line-finish() {
  (( $+_p9k__line_finished )) && return

  local P9K_PROMPT=transient

  _p9k__line_finished=
  (( _p9k_reset_on_line_finish )) && __p9k_reset_state=2
  (( $+functions[p10k-on-post-prompt] )) && p10k-on-post-prompt

  local -i optimized

  if [[ -n $_p9k_transient_prompt ]]; then
    if [[ $_POWERLEVEL9K_TRANSIENT_PROMPT == always || $_p9k__cwd == $_p9k__last_prompt_pwd ]]; then
      optimized=1
      __p9k_reset_state=2
    else
      _p9k__last_prompt_pwd=$_p9k__cwd
    fi
  fi

  if [[ $1 == int ]]; then
    _p9k__must_restore_prompt=1
    if (( !_p9k__restore_prompt_fd )); then
      sysopen -o cloexec -ru _p9k__restore_prompt_fd /dev/null
      zle -F $_p9k__restore_prompt_fd _p9k_restore_prompt
    fi
  fi

  if (( __p9k_reset_state == 2 )); then
    if (( optimized )); then
      RPROMPT= PROMPT=$_p9k_transient_prompt _p9k_reset_prompt
    else
      _p9k_reset_prompt
    fi
  fi

  _p9k__line_finished='%{%}'
}

function _p9k_on_widget_send-break() {
  _p9k_on_widget_zle-line-finish int
}

# Usage example: _p9k_display_segment 58 _p9k__1rkubecontext hide
function _p9k_display_segment() {
  [[ $_p9k__display_v[$1] == $3 ]] && return
  _p9k__display_v[$1]=$3
  [[ $3 == hide ]] && typeset -g $2= || unset $2
  __p9k_reset_state=2
}

function _p9k_redraw() {
  zle -F $1
  exec {1}>&-
  _p9k__redraw_fd=0

  () {
    local -h WIDGET=zle-line-pre-redraw
    _p9k_widget_hook ''
  }
}

function _p9k_deschedule_redraw() {
  (( _p9k__redraw_fd )) || return
  zle -F $_p9k__redraw_fd
  exec {_p9k__redraw_fd}>&-
  _p9k__redraw_fd=0
}

function _p9k_widget_hook() {
  _p9k_deschedule_redraw

  if (( ${+functions[p10k-on-post-widget]} || ${#_p9k_show_on_command} )); then
    local -a P9K_COMMANDS
    if [[ "$_p9k__last_buffer" == "$PREBUFFER$BUFFER" ]]; then
      P9K_COMMANDS=(${_p9k__last_commands[@]})
    else
      _p9k__last_buffer="$PREBUFFER$BUFFER"
      if [[ -n "$_p9k__last_buffer" ]]; then
        # this must run with user options
        _p9k_parse_buffer "$_p9k__last_buffer" $_POWERLEVEL9K_COMMANDS_MAX_TOKEN_COUNT
      fi
      _p9k__last_commands=(${P9K_COMMANDS[@]})
    fi
  fi

  eval "$__p9k_intro"
  (( _p9k__restore_prompt_fd )) && _p9k_restore_prompt $_p9k__restore_prompt_fd
  if [[ $1 == (clear-screen|z4h-clear-screen-*-top) ]]; then
    P9K_TTY=new
    _p9k__expanded=0
    _p9k_reset_prompt
  fi
  __p9k_reset_state=1
  _p9k_check_visual_mode
  local pat idx var
  for pat idx var in $_p9k_show_on_command; do
    if (( $P9K_COMMANDS[(I)$pat] )); then
      _p9k_display_segment $idx $var show
    else
      _p9k_display_segment $idx $var hide
    fi
  done
  (( $+functions[p10k-on-post-widget] )) && p10k-on-post-widget "${@:2}"
  (( $+functions[_p9k_on_widget_$1] )) && _p9k_on_widget_$1
  (( __p9k_reset_state == 2 )) && _p9k_reset_prompt
  __p9k_reset_state=0
}

function _p9k_widget() {
  local f=${widgets[._p9k_orig_$1]:-}
  local -i res
  [[ -z $f ]] || {
    [[ $f == user:-z4h-* ]] && {
      "${f#user:}" "${@:2}"
      res=$?
    } || {
      zle ._p9k_orig_$1 -- "${@:2}"
      res=$?
    }
  }
  (( ! __p9k_enabled )) || [[ $CONTEXT != start ]] || _p9k_widget_hook "$@"
  return res
}

function _p9k_widget_zle-line-pre-redraw-impl() {
  (( __p9k_enabled )) && [[ $CONTEXT == start ]] || return 0
  ! (( ${+functions[p10k-on-post-widget]} || ${#_p9k_show_on_command} || _p9k__restore_prompt_fd || _p9k__redraw_fd )) &&
      [[ ${KEYMAP:-} != vicmd ]] &&
      return
  (( PENDING || KEYS_QUEUED_COUNT )) && {
    (( _p9k__redraw_fd )) || {
      sysopen -o cloexec -ru _p9k__redraw_fd /dev/null
      zle -F $_p9k__redraw_fd _p9k_redraw
    }
    return
  }
  _p9k_widget_hook zle-line-pre-redraw
}

function _p9k_widget_send-break() {
  (( ! __p9k_enabled )) || [[ $CONTEXT != start ]] || {
    _p9k_widget_hook send-break "$@"
  }
  local f=${widgets[._p9k_orig_send-break]:-}
  [[ -z $f ]] || zle ._p9k_orig_send-break -- "$@"
}

typeset -gi __p9k_widgets_wrapped=0

function _p9k_wrap_widgets() {
  (( __p9k_widgets_wrapped )) && return

  typeset -gir __p9k_widgets_wrapped=1
  local -a widget_list
  if is-at-least 5.3; then
    local -aU widget_list=(
      zle-line-pre-redraw
      zle-line-init
      zle-line-finish
      zle-keymap-select
      overwrite-mode
      vi-replace
      visual-mode
      visual-line-mode
      deactivate-region
      clear-screen
      z4h-clear-screen-soft-top
      z4h-clear-screen-hard-top
      send-break
      $_POWERLEVEL9K_HOOK_WIDGETS
    )
  else
    # There is no zle-line-pre-redraw in zsh < 5.3, so we have to wrap all widgets
    # with key bindings. This costs extra 3ms: 1.5ms to fetch the list of widgets and
    # another 1.5ms to wrap them.
    if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
      local tmpdir=$TMPDIR
    else
      local tmpdir=/tmp
    fi
    local keymap tmp=$tmpdir/p10k.bindings.$sysparams[pid]
    {
      for keymap in $keymaps; do bindkey -M $keymap; done >$tmp
      local -aU widget_list=(
        zle-isearch-exit
        zle-isearch-update
        zle-line-init
        zle-line-finish
        zle-history-line-set
        zle-keymap-select
        send-break
        $_POWERLEVEL9K_HOOK_WIDGETS
        ${${${(f)"$(<$tmp)"}##* }:#(*\"|.*)}
      )
    } always {
      zf_rm -f -- $tmp
    }
  fi

  local widget
  for widget in $widget_list; do
    if (( ! $+functions[_p9k_widget_$widget] )); then
      functions[_p9k_widget_$widget]='_p9k_widget '${(q)widget}' "$@"'
    fi
    if [[ $widget == zle-* &&
          $widgets[$widget] == user:azhw:* &&
          $functions[add-zle-hook-widget] ]]; then
      add-zle-hook-widget $widget _p9k_widget_$widget
    else
      # The leading dot is to work around bugs in zsh-syntax-highlighting.
      zle -A $widget ._p9k_orig_$widget
      zle -N $widget _p9k_widget_$widget
    fi
  done 2>/dev/null  # `zle -A` fails for inexisting widgets and complains to stderr

  case ${widgets[._p9k_orig_zle-line-pre-redraw]:-} in
    user:-z4h-zle-line-pre-redraw)
      function _p9k_widget_zle-line-pre-redraw() {
        -z4h-zle-line-pre-redraw "$@"
        _p9k_widget_zle-line-pre-redraw-impl
      }
    ;;
    ?*)
      function _p9k_widget_zle-line-pre-redraw() {
        zle ._p9k_orig_zle-line-pre-redraw -- "$@"
        local -i res=$?
        _p9k_widget_zle-line-pre-redraw-impl
        return res
      }
    ;;
    '')
      function _p9k_widget_zle-line-pre-redraw() {
        _p9k_widget_zle-line-pre-redraw-impl
      }
    ;;
  esac
}

function _p9k_restore_prompt() {
  eval "$__p9k_intro"
  zle -F $1
  exec {1}>&-
  _p9k__restore_prompt_fd=0

  (( _p9k__must_restore_prompt )) || return 0
  _p9k__must_restore_prompt=0

  unset _p9k__line_finished
  _p9k__refresh_reason=restore
  _p9k_set_prompt
  _p9k__refresh_reason=

  _p9k__expanded=0
  _p9k_reset_prompt
}

prompt__p9k_internal_nothing() { _p9k__prompt+='${_p9k__sss::=}'; }
instant_prompt__p9k_internal_nothing() { prompt__p9k_internal_nothing; }

# _p9k_build_gap_post line_number
_p9k_build_gap_post() {
  if [[ $1 == 1 ]]; then
    local kind_l=first kind_u=FIRST
  else
    local kind_l=newline kind_u=NEWLINE
  fi
  _p9k_get_icon '' MULTILINE_${kind_u}_PROMPT_GAP_CHAR
  local char=${_p9k__ret:- }
  _p9k_prompt_length $char
  if (( _p9k__ret != 1 || $#char != 1 )); then
    >&2 print -rP -- "%F{red}WARNING!%f %BMULTILINE_${kind_u}_PROMPT_GAP_CHAR%b is not one character long. Will use ' '."
    >&2 print -rP -- "Either change the value of %BPOWERLEVEL9K_MULTILINE_${kind_u}_PROMPT_GAP_CHAR%b or remove it."
    char=' '
  fi
  local style
  _p9k_color prompt_multiline_${kind_l}_prompt_gap BACKGROUND ""
  [[ -n $_p9k__ret ]] && _p9k_background $_p9k__ret
  style+=$_p9k__ret
  _p9k_color prompt_multiline_${kind_l}_prompt_gap FOREGROUND ""
  [[ -n $_p9k__ret ]] && _p9k_foreground $_p9k__ret
  style+=$_p9k__ret
  _p9k_escape_style $style
  style=$_p9k__ret
  local exp=_POWERLEVEL9K_MULTILINE_${kind_u}_PROMPT_GAP_EXPANSION
  (( $+parameters[$exp] )) && exp=${(P)exp} || exp='${P9K_GAP}'
  [[ $char == '.' ]] && local s=',' || local s='.'
  _p9k__ret=$'${${_p9k__g+\n}:-'$style'${${${_p9k__m:#-*}:+'
  _p9k__ret+='${${_p9k__'$1'g+${(pl.$((_p9k__m+1)).. .)}}:-'
  if [[ $exp == '${P9K_GAP}' ]]; then
    _p9k__ret+='${(pl'$s'$((_p9k__m+1))'$s$s$char$s')}'
  else
    _p9k__ret+='${${P9K_GAP::=${(pl'$s'$((_p9k__m+1))'$s$s$char$s')}}+}'
    _p9k__ret+='${:-"'$exp'"}'
    style=1
  fi
  _p9k__ret+='}'
  if (( __p9k_ksh_arrays )); then
    _p9k__ret+=$'$_p9k__rprompt${_p9k_t[$((!_p9k__ind))]}}:-\n}'
  else
    _p9k__ret+=$'$_p9k__rprompt${_p9k_t[$((1+!_p9k__ind))]}}:-\n}'
  fi
  [[ -n $style ]] && _p9k__ret+='%b%k%f'
  _p9k__ret+='}'
}

_p9k_init_lines() {
  local -a left_segments=($_POWERLEVEL9K_LEFT_PROMPT_ELEMENTS)
  local -a right_segments=($_POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS)

  if (( _POWERLEVEL9K_PROMPT_ON_NEWLINE )); then
    left_segments+=(newline _p9k_internal_nothing)
  fi

  local -i num_left_lines=$((1 + ${#${(@M)left_segments:#newline}}))
  local -i num_right_lines=$((1 + ${#${(@M)right_segments:#newline}}))
  if (( num_right_lines > num_left_lines )); then
    repeat $((num_right_lines - num_left_lines)) left_segments=(newline $left_segments)
    local -i num_lines=num_right_lines
  else
    if (( _POWERLEVEL9K_RPROMPT_ON_NEWLINE )); then
      repeat $((num_left_lines - num_right_lines)) right_segments=(newline $right_segments)
    else
      repeat $((num_left_lines - num_right_lines)) right_segments+=newline
    fi
    local -i num_lines=num_left_lines
  fi

  local -i i
  for i in {1..$num_lines}; do
    local -i left_end=${left_segments[(i)newline]}
    local -i right_end=${right_segments[(i)newline]}
    _p9k_line_segments_left+="${(pj:\0:)left_segments[1,left_end-1]}"
    _p9k_line_segments_right+="${(pj:\0:)right_segments[1,right_end-1]}"
    (( left_end > $#left_segments )) && left_segments=() || shift left_end left_segments
    (( right_end > $#right_segments )) && right_segments=() || shift right_end right_segments

    _p9k_get_icon '' LEFT_SEGMENT_SEPARATOR
    _p9k_get_icon 'prompt_empty_line' LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL $_p9k__ret
    _p9k_escape $_p9k__ret
    _p9k_line_prefix_left+='${_p9k__'$i'l-${${:-${_p9k__bg::=NONE}${_p9k__i::=0}${_p9k__sss::=%f'$_p9k__ret'}}+}'
    _p9k_line_suffix_left+='%b%k$_p9k__sss%b%k%f'

    _p9k_escape ${(g::)_POWERLEVEL9K_EMPTY_LINE_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL}
    [[ -n $_p9k__ret ]] && _p9k_line_never_empty_right+=1 || _p9k_line_never_empty_right+=0
    _p9k_line_prefix_right+='${_p9k__'$i'r-${${:-${_p9k__bg::=NONE}${_p9k__i::=0}${_p9k__sss::='$_p9k__ret'}}+}'
    _p9k_line_suffix_right+='$_p9k__sss%b%k%f}'  # gets overridden for _p9k_emulate_zero_rprompt_indent
    if (( i == num_lines )); then
      # it's safe to use _p9k_prompt_length on the last line because it cannot have prompt connection
      _p9k_prompt_length ${(e)_p9k__ret}
      (( _p9k__ret )) || _p9k_line_never_empty_right[-1]=0
    fi
  done

  _p9k_get_icon '' LEFT_SEGMENT_END_SEPARATOR
  if [[ -n $_p9k__ret ]]; then
    _p9k__ret+=%b%k%f
    # Not escaped for historical reasons.
    _p9k__ret='${:-"'$_p9k__ret'"}'
    if (( _POWERLEVEL9K_PROMPT_ON_NEWLINE )); then
      _p9k_line_suffix_left[-2]+=$_p9k__ret
    else
      _p9k_line_suffix_left[-1]+=$_p9k__ret
    fi
  fi

  for i in {1..$num_lines}; do _p9k_line_suffix_left[i]+='}'; done

  if (( num_lines > 1 )); then
    for i in {1..$((num_lines-1))}; do
      _p9k_build_gap_post $i
      _p9k_line_gap_post+=$_p9k__ret
    done

    if [[ $+_POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]; then
      _p9k_get_icon '' MULTILINE_FIRST_PROMPT_PREFIX
      if [[ -n $_p9k__ret ]]; then
        [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
        # Not escaped for historical reasons.
        _p9k__ret='${_p9k__1l_frame-"'$_p9k__ret'"}'
        _p9k_line_prefix_left[1]=$_p9k__ret$_p9k_line_prefix_left[1]
      fi
    fi

    if [[ $+_POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]; then
      _p9k_get_icon '' MULTILINE_LAST_PROMPT_PREFIX
      if [[ -n $_p9k__ret ]]; then
        [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
        # Not escaped for historical reasons.
        _p9k__ret='${_p9k__'$num_lines'l_frame-"'$_p9k__ret'"}'
        _p9k_line_prefix_left[-1]=$_p9k__ret$_p9k_line_prefix_left[-1]
      fi
    fi

    _p9k_get_icon '' MULTILINE_FIRST_PROMPT_SUFFIX
    if [[ -n $_p9k__ret ]]; then
      [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
      _p9k_line_suffix_right[1]+='${_p9k__1r_frame-'${(qqq)_p9k__ret}'}'
      _p9k_line_never_empty_right[1]=1
    fi

    _p9k_get_icon '' MULTILINE_LAST_PROMPT_SUFFIX
    if [[ -n $_p9k__ret ]]; then
      [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
      _p9k_line_suffix_right[-1]+='${_p9k__'$num_lines'r_frame-'${(qqq)_p9k__ret}'}'
      # it's safe to use _p9k_prompt_length on the last line because it cannot have prompt connection
      _p9k_prompt_length $_p9k__ret
      (( _p9k__ret )) && _p9k_line_never_empty_right[-1]=1
    fi

    if (( num_lines > 2 )); then
      if [[ $+_POWERLEVEL9K_MULTILINE_NEWLINE_PROMPT_PREFIX == 1 || $_POWERLEVEL9K_PROMPT_ON_NEWLINE == 1 ]]; then
        _p9k_get_icon '' MULTILINE_NEWLINE_PROMPT_PREFIX
        if [[ -n $_p9k__ret ]]; then
          [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
          for i in {2..$((num_lines-1))}; do
            # Not escaped for historical reasons.
            _p9k_line_prefix_left[i]='${_p9k__'$i'l_frame-"'$_p9k__ret'"}'$_p9k_line_prefix_left[i]
          done
        fi
      fi

      _p9k_get_icon '' MULTILINE_NEWLINE_PROMPT_SUFFIX
      if [[ -n $_p9k__ret ]]; then
        [[ _p9k__ret == *%* ]] && _p9k__ret+=%b%k%f
        for i in {2..$((num_lines-1))}; do
          _p9k_line_suffix_right[i]+='${_p9k__'$i'r_frame-'${(qqq)_p9k__ret}'}'
        done
        _p9k_line_never_empty_right[2,-2]=${(@)_p9k_line_never_empty_right[2,-2]/0/1}
      fi
    fi
  fi
}

_p9k_all_params_eq() {
  local key
  for key in ${parameters[(I)${~1}]}; do
    [[ ${(P)key} == $2 ]] || return
  done
}

_p9k_init_display() {
  _p9k_display_k=(empty_line 1 ruler 3)
  local -i n=3 i
  local name
  for i in {1..$#_p9k_line_segments_left}; do
    local -i j=$((-$#_p9k_line_segments_left+i-1))
    _p9k_display_k+=(
      $i              $((n+=2)) $j             $n
      $i/left_frame   $((n+=2)) $j/left_frame  $n
      $i/right_frame  $((n+=2)) $j/right_frame $n
      $i/left         $((n+=2)) $j/left        $n
      $i/right        $((n+=2)) $j/right       $n
      $i/gap          $((n+=2)) $j/gap         $n)
    for name in ${${(@0)_p9k_line_segments_left[i]}%_joined}; do
      _p9k_display_k+=($i/left/$name $((n+=2)) $j/left/$name $n)
    done
    for name in ${${(@0)_p9k_line_segments_right[i]}%_joined}; do
      _p9k_display_k+=($i/right/$name $((n+=2)) $j/right/$name $n)
    done
  done
}

_p9k_init_prompt() {
  _p9k_t=($'\n' $'%{\n%}' '')
  _p9k_prompt_overflow_bug && _p9k_t[2]=$'%{%G\n%}'

  _p9k_init_lines

  _p9k_gap_pre='${${:-${_p9k__x::=0}${_p9k__y::=1024}${_p9k__p::=$_p9k__lprompt$_p9k__rprompt}'
  repeat 10; do
    _p9k_gap_pre+='${_p9k__m::=$(((_p9k__x+_p9k__y)/2))}'
    _p9k_gap_pre+='${_p9k__xy::=${${(%):-$_p9k__p%$_p9k__m(l./$_p9k__m;$_p9k__y./$_p9k__x;$_p9k__m)}##*/}}'
    _p9k_gap_pre+='${_p9k__x::=${_p9k__xy%;*}}'
    _p9k_gap_pre+='${_p9k__y::=${_p9k__xy#*;}}'
  done
  _p9k_gap_pre+='${_p9k__m::=$((_p9k__clm-_p9k__x-_p9k__ind-1))}'
  _p9k_gap_pre+='}+}'

  _p9k_prompt_prefix_left='${${_p9k__clm::=$COLUMNS}+}${${COLUMNS::=1024}+}'
  _p9k_prompt_prefix_right='${_p9k__'$#_p9k_line_segments_left'-${${_p9k__clm::=$COLUMNS}+}${${COLUMNS::=1024}+}'
  _p9k_prompt_suffix_left='${${COLUMNS::=$_p9k__clm}+}'
  _p9k_prompt_suffix_right='${${COLUMNS::=$_p9k__clm}+}}'

  if _p9k_segment_in_use vi_mode || _p9k_segment_in_use prompt_char; then
    _p9k_prompt_prefix_left+='${${_p9k__keymap::=${KEYMAP:-$_p9k__keymap}}+}'
  fi
  if { _p9k_segment_in_use vi_mode && (( $+_POWERLEVEL9K_VI_OVERWRITE_MODE_STRING )) } ||
     { _p9k_segment_in_use prompt_char && (( _POWERLEVEL9K_PROMPT_CHAR_OVERWRITE_STATE )) }; then
    _p9k_prompt_prefix_left+='${${_p9k__zle_state::=${ZLE_STATE:-$_p9k__zle_state}}+}'
  fi
  _p9k_prompt_prefix_left+='%b%k%f'

  # Bug fixed in: https://github.com/zsh-users/zsh/commit/3eea35d0853bddae13fa6f122669935a01618bf9.
  # If affects most terminals when RPROMPT is non-empty and ZLE_RPROMPT_INDENT is zero.
  # We can work around it as long as RPROMPT ends with a space.
  if [[ -n $_p9k_line_segments_right[-1] && $_p9k_line_never_empty_right[-1] == 0 &&
        $ZLE_RPROMPT_INDENT == 0 ]] &&
       _p9k_all_params_eq '_POWERLEVEL9K_*WHITESPACE_BETWEEN_RIGHT_SEGMENTS' ' ' &&
       _p9k_all_params_eq '_POWERLEVEL9K_*RIGHT_RIGHT_WHITESPACE' ' ' &&
       _p9k_all_params_eq '_POWERLEVEL9K_*RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL' '' &&
       ! is-at-least 5.7.2; then
    _p9k_emulate_zero_rprompt_indent=1
    _p9k_prompt_prefix_left+='${${:-${_p9k__real_zle_rprompt_indent:=$ZLE_RPROMPT_INDENT}${ZLE_RPROMPT_INDENT::=1}${_p9k__ind::=0}}+}'
    _p9k_line_suffix_right[-1]='${_p9k__sss:+${_p9k__sss% }%E}}'
  else
    _p9k_emulate_zero_rprompt_indent=0
    _p9k_prompt_prefix_left+='${${_p9k__ind::=${${ZLE_RPROMPT_INDENT:-1}/#-*/0}}+}'
  fi

  if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION )); then
    _p9k_prompt_prefix_left+=$'%{\e]133;A\a%}'
    _p9k_prompt_suffix_left+=$'%{\e]133;B\a%}'
    if (( $+_z4h_iterm_cmd && _z4h_can_save_restore_screen == 1 )); then
      _p9k_prompt_prefix_left+=$'%{\ePtmux;\e\e]133;A\a\e\\%}'
      _p9k_prompt_suffix_left+=$'%{\ePtmux;\e\e]133;B\a\e\\%}'
    fi
  fi

  if (( _POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT > 0 )); then
    _p9k_t+=${(pl.$_POWERLEVEL9K_PROMPT_ADD_NEWLINE_COUNT..\n.)}
  else
    _p9k_t+=''
  fi
  _p9k_empty_line_idx=$#_p9k_t
  if (( __p9k_ksh_arrays )); then
    _p9k_prompt_prefix_left+='${_p9k_t[${_p9k__empty_line_i:-'$#_p9k_t'}-1]}'
  else
    _p9k_prompt_prefix_left+='${_p9k_t[${_p9k__empty_line_i:-'$#_p9k_t'}]}'
  fi

  local -i num_lines=$#_p9k_line_segments_left
  if (( $+terminfo[cuu1] )); then
    _p9k_escape $terminfo[cuu1]
    if (( __p9k_ksh_arrays )); then
      local scroll=$'${_p9k_t[${_p9k__ruler_i:-1}-1]:+\n'$_p9k__ret'}'
    else
      local scroll=$'${_p9k_t[${_p9k__ruler_i:-1}]:+\n'$_p9k__ret'}'
    fi
    if (( num_lines > 1 )); then
      local -i line_index=
      for line_index in {1..$((num_lines-1))}; do
        scroll='${_p9k__'$line_index-$'\n}'$scroll'${_p9k__'$line_index-$_p9k__ret'}'
      done
    fi
    _p9k_prompt_prefix_left+='%{${_p9k__ipe-'$scroll'}%}'
  fi

  _p9k_get_icon '' RULER_CHAR
  local ruler_char=$_p9k__ret
  _p9k_prompt_length $ruler_char
  (( _p9k__ret == 1 && $#ruler_char == 1 )) || ruler_char=' '
  _p9k_color prompt_ruler BACKGROUND ""
  if [[ -z $_p9k__ret && $ruler_char == ' ' ]]; then
    local ruler=$'\n'
  else
    _p9k_background $_p9k__ret
    local ruler=%b$_p9k__ret
    _p9k_color prompt_ruler FOREGROUND ""
    _p9k_foreground $_p9k__ret
    ruler+=$_p9k__ret
    [[ $ruler_char == '.' ]] && local sep=',' || local sep='.'
    ruler+='${(pl'$sep'${$((_p9k__clm-_p9k__ind))/#-*/0}'$sep$sep$ruler_char$sep')}%k%f'
    if (( __p9k_ksh_arrays )); then
      ruler+='${_p9k_t[$((!_p9k__ind))]}'
    else
      ruler+='${_p9k_t[$((1+!_p9k__ind))]}'
    fi
  fi
  _p9k_t+=$ruler
  _p9k_ruler_idx=$#_p9k_t
  if (( __p9k_ksh_arrays )); then
    _p9k_prompt_prefix_left+='${(e)_p9k_t[${_p9k__ruler_i:-'$#_p9k_t'}-1]}'
  else
    _p9k_prompt_prefix_left+='${(e)_p9k_t[${_p9k__ruler_i:-'$#_p9k_t'}]}'
  fi

  ( _p9k_segment_in_use time && (( _POWERLEVEL9K_TIME_UPDATE_ON_COMMAND )) )
  _p9k_reset_on_line_finish=$((!$?))

  _p9k_t+=$_p9k_gap_pre
  _p9k_gap_pre='${(e)_p9k_t['$(($#_p9k_t - __p9k_ksh_arrays))']}'
  _p9k_t+=$_p9k_prompt_prefix_left
  _p9k_prompt_prefix_left='${(e)_p9k_t['$(($#_p9k_t - __p9k_ksh_arrays))']}'
}

_p9k_init_ssh() {
  # The following code is based on Pure:
  # https://github.com/sindresorhus/pure/blob/e8abf9d37185ec9b7b4398ca9c5eba555a1028eb/pure.zsh.
  #
  # License: https://github.com/sindresorhus/pure/blob/e8abf9d37185ec9b7b4398ca9c5eba555a1028eb/license.

  [[ -n $P9K_SSH ]] && return
  typeset -gix P9K_SSH=0
  if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
    P9K_SSH=1
    return 0
  fi

  # When changing user on a remote system, the $SSH_CONNECTION environment variable can be lost.
  # Attempt detection via `who`.
  (( $+commands[who] )) || return

  local ipv6='(([0-9a-fA-F]+:)|:){2,}[0-9a-fA-F]+'  # Simplified, only checks partial pattern.
  local ipv4='([0-9]{1,3}\.){3}[0-9]+'              # Simplified, allows invalid ranges.
  # Assume two non-consecutive periods represents a hostname. Matches `x.y.z`, but not `x.y`.
  local hostname='([.][^. ]+){2}'

  local w
  w="$(who -m 2>/dev/null)" || w=${(@M)${(f)"$(who 2>/dev/null)"}:#*[[:space:]]${TTY#/dev/}[[:space:]]*}

  # Usually the remote address is surrounded by parenthesis but not on all systems (e.g., Busybox).
  [[ $w =~ "\(?($ipv4|$ipv6|$hostname)\)?\$" ]] && P9K_SSH=1
}

_p9k_init_toolbox() {
  [[ -z $P9K_TOOLBOX_NAME ]] || return 0
  if [[ -f /run/.containerenv && -r /run/.containerenv ]]; then
    local name=(${(Q)${${(@M)${(f)"$(</run/.containerenv)"}:#name=*}#name=}})
    [[ ${#name} -eq 1 && -n ${name[1]} ]] || return 0
    typeset -g P9K_TOOLBOX_NAME=${name[1]}
  elif [[ -n $DISTROBOX_ENTER_PATH ]]; then
    local name=${(%):-%m}
    # $NAME can be empty, see https://github.com/romkatv/powerlevel10k/pull/1916.
    if [[ -n $name && $name == $NAME* ]]; then
      typeset -g P9K_TOOLBOX_NAME=$name
    fi
  fi
}

_p9k_must_init() {
  (( _POWERLEVEL9K_DISABLE_HOT_RELOAD && !_p9k__force_must_init )) && return 1
  _p9k__force_must_init=0
  local IFS sig
  if [[ -n $_p9k__param_sig ]]; then
    IFS=$'\2' sig="${(e)_p9k__param_pat}"
    [[ $sig == $_p9k__param_sig ]] && return 1
    _p9k_deinit
  fi
  _p9k__param_pat=$'v135\1'${(q)ZSH_VERSION}$'\1'${(q)ZSH_PATCHLEVEL}$'\1'
  _p9k__param_pat+=$__p9k_force_term_shell_integration$'\1'
  _p9k__param_pat+=$'${#parameters[(I)POWERLEVEL9K_*]}\1${(%):-%n%#}\1$GITSTATUS_LOG_LEVEL\1'
  _p9k__param_pat+=$'$GITSTATUS_ENABLE_LOGGING\1$GITSTATUS_DAEMON\1$GITSTATUS_NUM_THREADS\1'
  _p9k__param_pat+=$'$GITSTATUS_CACHE_DIR\1$GITSTATUS_AUTO_INSTALL\1${ZLE_RPROMPT_INDENT:-1}\1'
  _p9k__param_pat+=$'$__p9k_sh_glob\1$__p9k_ksh_arrays\1$ITERM_SHELL_INTEGRATION_INSTALLED\1'
  _p9k__param_pat+=$'${PROMPT_EOL_MARK-%B%S%#%s%b}\1$+commands[locale]\1$langinfo[CODESET]\1'
  _p9k__param_pat+=$'${(M)VTE_VERSION:#(<1-4602>|4801)}\1$DEFAULT_USER\1$P9K_SSH\1$+commands[uname]\1'
  _p9k__param_pat+=$'$__p9k_root_dir\1$functions[p10k-on-init]\1$functions[p10k-on-pre-prompt]\1'
  _p9k__param_pat+=$'$functions[p10k-on-post-widget]\1$functions[p10k-on-post-prompt]\1'
  _p9k__param_pat+=$'$+commands[git]\1$terminfo[colors]\1${+_z4h_iterm_cmd}\1'
  _p9k__param_pat+=$'$_z4h_can_save_restore_screen'
  local MATCH
  IFS=$'\1' _p9k__param_pat+="${(@)${(@o)parameters[(I)POWERLEVEL9K_*]}:/(#m)*/\${${(q)MATCH}-$IFS\}}"
  IFS=$'\2' _p9k__param_sig="${(e)_p9k__param_pat}"
}

function _p9k_set_os() {
  _p9k_os=$1
  _p9k_get_icon prompt_os_icon $2
  _p9k_os_icon=$_p9k__ret
}

function _p9k_init_cacheable() {
  _p9k_init_icons
  _p9k_init_params
  _p9k_init_prompt
  _p9k_init_display

  # https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda#backward-compatibility
  if [[ $VTE_VERSION != (<1-4602>|4801) ]]; then
    _p9k_term_has_href=1
  fi

  local elem func
  local -i i=0

  for i in {1..$#_p9k_line_segments_left}; do
    for elem in ${${${(@0)_p9k_line_segments_left[i]}%_joined}//-/_}; do
      local var=POWERLEVEL9K_${${(U)elem}//İ/I}_SHOW_ON_COMMAND
      (( $+parameters[$var] )) || continue
      _p9k_show_on_command+=(
        $'(|*[/\0])('${(j.|.)${(P)var}}')'
        $((1+_p9k_display_k[$i/left/$elem]))
        _p9k__${i}l$elem)
    done
    for elem in ${${${(@0)_p9k_line_segments_right[i]}%_joined}//-/_}; do
      local var=POWERLEVEL9K_${${(U)elem}//İ/I}_SHOW_ON_COMMAND
      (( $+parameters[$var] )) || continue
      local cmds=(${(P)var})
      _p9k_show_on_command+=(
        $'(|*[/\0])('${(j.|.)${(P)var}}')'
        $((1+$_p9k_display_k[$i/right/$elem]))
        _p9k__${i}r$elem)
    done
  done

  if [[ $_POWERLEVEL9K_TRANSIENT_PROMPT != off ]]; then
    local sep=$'\1'
    _p9k_transient_prompt='%b%k%s%u%(?'$sep
    _p9k_color prompt_prompt_char_OK_VIINS FOREGROUND 76
    _p9k_foreground $_p9k__ret
    _p9k_transient_prompt+=$_p9k__ret
    _p9k_transient_prompt+='${${P9K_CONTENT::="❯"}+}'
    _p9k_param prompt_prompt_char_OK_VIINS CONTENT_EXPANSION '${P9K_CONTENT}'
    _p9k_transient_prompt+='${:-"'$_p9k__ret'"}'
    _p9k_transient_prompt+=$sep
    _p9k_color prompt_prompt_char_ERROR_VIINS FOREGROUND 196
    _p9k_foreground $_p9k__ret
    _p9k_transient_prompt+=$_p9k__ret
    _p9k_transient_prompt+='${${P9K_CONTENT::="❯"}+}'
    _p9k_param prompt_prompt_char_ERROR_VIINS CONTENT_EXPANSION '${P9K_CONTENT}'
    _p9k_transient_prompt+='${:-"'$_p9k__ret'"}'
    _p9k_transient_prompt+=')%b%k%f%s%u '
    if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION )); then
      _p9k_transient_prompt=$'%{\e]133;A\a%}'$_p9k_transient_prompt$'%{\e]133;B\a%}'
      if (( $+_z4h_iterm_cmd && _z4h_can_save_restore_screen == 1 )); then
        _p9k_transient_prompt=$'%{\ePtmux;\e\e]133;A\a\e\\%}'$_p9k_transient_prompt$'%{\ePtmux;\e\e]133;B\a\e\\%}'
      fi
    fi
  fi

  _p9k_uname="$(uname)"
  [[ $_p9k_uname == Linux ]] && _p9k_uname_o="$(uname -o 2>/dev/null)"
  _p9k_uname_m="$(uname -m)"

  if [[ $_p9k_uname == Linux && $_p9k_uname_o == Android ]]; then
    _p9k_set_os Android ANDROID_ICON
  else
    case $_p9k_uname in
      SunOS)                     _p9k_set_os Solaris SUNOS_ICON;;
      Darwin)                    _p9k_set_os OSX     APPLE_ICON;;
      CYGWIN*|MSYS*|MINGW*)      _p9k_set_os Windows WINDOWS_ICON;;
      FreeBSD|OpenBSD|DragonFly) _p9k_set_os BSD     FREEBSD_ICON;;
      Linux)
        _p9k_os='Linux'
        local os_release_id
        if [[ -r /etc/os-release ]]; then
          local lines=(${(f)"$(</etc/os-release)"})
          lines=(${(@M)lines:#ID=*})
          (( $#lines == 1 )) && os_release_id=${lines[1]#ID=}
        elif [[ -e /etc/artix-release ]]; then
          os_release_id=artix
        fi
        case $os_release_id in
          *arch*)                  _p9k_set_os Linux LINUX_ARCH_ICON;;
          *debian*)                _p9k_set_os Linux LINUX_DEBIAN_ICON;;
          *raspbian*)              _p9k_set_os Linux LINUX_RASPBIAN_ICON;;
          *ubuntu*)                _p9k_set_os Linux LINUX_UBUNTU_ICON;;
          *elementary*)            _p9k_set_os Linux LINUX_ELEMENTARY_ICON;;
          *fedora*)                _p9k_set_os Linux LINUX_FEDORA_ICON;;
          *coreos*)                _p9k_set_os Linux LINUX_COREOS_ICON;;
          *gentoo*)                _p9k_set_os Linux LINUX_GENTOO_ICON;;
          *mageia*)                _p9k_set_os Linux LINUX_MAGEIA_ICON;;
          *centos*)                _p9k_set_os Linux LINUX_CENTOS_ICON;;
          *opensuse*|*tumbleweed*) _p9k_set_os Linux LINUX_OPENSUSE_ICON;;
          *sabayon*)               _p9k_set_os Linux LINUX_SABAYON_ICON;;
          *slackware*)             _p9k_set_os Linux LINUX_SLACKWARE_ICON;;
          *linuxmint*)             _p9k_set_os Linux LINUX_MINT_ICON;;
          *alpine*)                _p9k_set_os Linux LINUX_ALPINE_ICON;;
          *aosc*)                  _p9k_set_os Linux LINUX_AOSC_ICON;;
          *nixos*)                 _p9k_set_os Linux LINUX_NIXOS_ICON;;
          *devuan*)                _p9k_set_os Linux LINUX_DEVUAN_ICON;;
          *manjaro*)               _p9k_set_os Linux LINUX_MANJARO_ICON;;
          *void*)                  _p9k_set_os Linux LINUX_VOID_ICON;;
          *artix*)                 _p9k_set_os Linux LINUX_ARTIX_ICON;;
          *rhel*)                  _p9k_set_os Linux LINUX_RHEL_ICON;;
          amzn)                    _p9k_set_os Linux LINUX_AMZN_ICON;;
          *)                       _p9k_set_os Linux LINUX_ICON;;
        esac
        ;;
    esac
  fi

  if [[ $_POWERLEVEL9K_COLOR_SCHEME == light ]]; then
    _p9k_color1=7
    _p9k_color2=0
  else
    _p9k_color1=0
    _p9k_color2=7
  fi

  _p9k_battery_states=(
    'LOW'           'red'
    'CHARGING'      'yellow'
    'CHARGED'       'green'
    'DISCONNECTED'  "$_p9k_color2"
  )

  # This simpler construct doesn't work on zsh-5.1 with multi-line prompt:
  #
  #   ${(@0)_p9k_line_segments_left[@]}
  local -a left_segments=(${(@0)${(pj:\0:)_p9k_line_segments_left}})
  _p9k_left_join=(1)
  for ((i = 2; i <= $#left_segments; ++i)); do
    elem=$left_segments[i]
    if [[ $elem == *_joined ]]; then
      _p9k_left_join+=$_p9k_left_join[((i-1))]
    else
      _p9k_left_join+=$i
    fi
  done

  local -a right_segments=(${(@0)${(pj:\0:)_p9k_line_segments_right}})
  _p9k_right_join=(1)
  for ((i = 2; i <= $#right_segments; ++i)); do
    elem=$right_segments[i]
    if [[ $elem == *_joined ]]; then
      _p9k_right_join+=$_p9k_right_join[((i-1))]
    else
      _p9k_right_join+=$i
    fi
  done

  case $_p9k_os in
    OSX) (( $+commands[sysctl] )) && _p9k_num_cpus="$(sysctl -n hw.logicalcpu 2>/dev/null)";;
    BSD) (( $+commands[sysctl] )) && _p9k_num_cpus="$(sysctl -n hw.ncpu 2>/dev/null)";;
    *)   (( $+commands[nproc]  )) && _p9k_num_cpus="$(nproc 2>/dev/null)";;
  esac
  (( _p9k_num_cpus )) || _p9k_num_cpus=1

  if _p9k_segment_in_use dir; then
    if (( $+_POWERLEVEL9K_DIR_CLASSES )); then
      local -i i=3
      for ((; i <= $#_POWERLEVEL9K_DIR_CLASSES; i+=3)); do
        _POWERLEVEL9K_DIR_CLASSES[i]=${(g::)_POWERLEVEL9K_DIR_CLASSES[i]}
      done
    else
      typeset -ga _POWERLEVEL9K_DIR_CLASSES=()
      _p9k_get_icon prompt_dir_ETC ETC_ICON
      _POWERLEVEL9K_DIR_CLASSES+=('/etc|/etc/*' ETC "$_p9k__ret")
      _p9k_get_icon prompt_dir_HOME HOME_ICON
      _POWERLEVEL9K_DIR_CLASSES+=('~' HOME "$_p9k__ret")
      _p9k_get_icon prompt_dir_HOME_SUBFOLDER HOME_SUB_ICON
      _POWERLEVEL9K_DIR_CLASSES+=('~/*' HOME_SUBFOLDER "$_p9k__ret")
      _p9k_get_icon prompt_dir_DEFAULT FOLDER_ICON
      _POWERLEVEL9K_DIR_CLASSES+=('*' DEFAULT "$_p9k__ret")
    fi
  fi

  if _p9k_segment_in_use status; then
    typeset -g _p9k_exitcode2str=({0..255})
    local -i i=2
    if (( !_POWERLEVEL9K_STATUS_HIDE_SIGNAME )); then
      for ((; i <= $#signals; ++i)); do
        local sig=$signals[i]
        (( _POWERLEVEL9K_STATUS_VERBOSE_SIGNAME )) && sig="SIG${sig}($((i-1)))"
        _p9k_exitcode2str[$((128+i))]=$sig
      done
    fi
  fi

  if [[ $#_POWERLEVEL9K_VCS_BACKENDS == 1 && $_POWERLEVEL9K_VCS_BACKENDS[1] == git ]]; then
    local elem line
    local -i i=0 line_idx=0
    for line in $_p9k_line_segments_left; do
      (( ++line_idx ))
      for elem in ${${(0)line}%_joined}; do
        (( ++i ))
        if [[ $elem == vcs ]]; then
          if (( _p9k_vcs_index )); then
            _p9k_vcs_index=-1
          else
            _p9k_vcs_index=i
            _p9k_vcs_line_index=line_idx
            _p9k_vcs_side=left
          fi
        fi
      done
    done
    i=0
    line_idx=0
    for line in $_p9k_line_segments_right; do
      (( ++line_idx ))
      for elem in ${${(0)line}%_joined}; do
        (( ++i ))
        if [[ $elem == vcs ]]; then
          if (( _p9k_vcs_index )); then
            _p9k_vcs_index=-1
          else
            _p9k_vcs_index=i
            _p9k_vcs_line_index=line_idx
            _p9k_vcs_side=right
          fi
        fi
      done
    done
    if (( _p9k_vcs_index > 0 )); then
      local state
      for state in ${(k)__p9k_vcs_states}; do
        _p9k_param prompt_vcs_$state CONTENT_EXPANSION x
        if [[ -z $_p9k__ret ]]; then
          _p9k_vcs_index=-1
          break
        fi
      done
    fi
    if (( _p9k_vcs_index == -1 )); then
      _p9k_vcs_index=0
      _p9k_vcs_line_index=0
      _p9k_vcs_side=
    fi
  fi
}

_p9k_init_vcs() {
  if ! _p9k_segment_in_use vcs || (( ! $#_POWERLEVEL9K_VCS_BACKENDS )); then
    (( $+functions[gitstatus_stop_p9k_] )) && gitstatus_stop_p9k_ POWERLEVEL9K
    unset _p9k_preinit
    return
  fi

  _p9k_vcs_info_init
  if (( $+functions[_p9k_preinit] )); then
    if (( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )); then
      () {
        trap 'return 130' INT
        {
          gitstatus_start_p9k_ POWERLEVEL9K
        } always {
          trap ':' INT
        }
      }
    fi
    (( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )) || _p9k__instant_prompt_disabled=1
    return 0
  fi
  (( _POWERLEVEL9K_DISABLE_GITSTATUS )) && return
  (( $_POWERLEVEL9K_VCS_BACKENDS[(I)git] )) || return

  local gitstatus_dir=${_POWERLEVEL9K_GITSTATUS_DIR:-${__p9k_root_dir}/gitstatus}

  typeset -g _p9k_preinit="function _p9k_preinit() {
    (( $+commands[git] )) || { unfunction _p9k_preinit; return 1 }
    [[ \$ZSH_VERSION == ${(q)ZSH_VERSION} ]]                      || return
    [[ -r ${(q)gitstatus_dir}/gitstatus.plugin.zsh ]]             || return
    builtin source ${(q)gitstatus_dir}/gitstatus.plugin.zsh _p9k_ || return
    GITSTATUS_AUTO_INSTALL=${(q)GITSTATUS_AUTO_INSTALL}         \
      GITSTATUS_DAEMON=${(q)GITSTATUS_DAEMON}                   \
      GITSTATUS_CACHE_DIR=${(q)GITSTATUS_CACHE_DIR}             \
      GITSTATUS_NUM_THREADS=${(q)GITSTATUS_NUM_THREADS}         \
      GITSTATUS_LOG_LEVEL=${(q)GITSTATUS_LOG_LEVEL}             \
      GITSTATUS_ENABLE_LOGGING=${(q)GITSTATUS_ENABLE_LOGGING}   \
        gitstatus_start_p9k_                                    \
          -s $_POWERLEVEL9K_VCS_STAGED_MAX_NUM                  \
          -u $_POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM                \
          -d $_POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM               \
          -c $_POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM              \
          -m $_POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY            \
          ${${_POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS:#0}:+-e} \
          -a POWERLEVEL9K
  }"
  builtin source $gitstatus_dir/gitstatus.plugin.zsh _p9k_ || return
  () {
    trap 'return 130' INT
    {
      gitstatus_start_p9k_                                    \
        -s $_POWERLEVEL9K_VCS_STAGED_MAX_NUM                  \
        -u $_POWERLEVEL9K_VCS_UNSTAGED_MAX_NUM                \
        -d $_POWERLEVEL9K_VCS_UNTRACKED_MAX_NUM               \
        -c $_POWERLEVEL9K_VCS_CONFLICTED_MAX_NUM              \
        -m $_POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY            \
        ${${_POWERLEVEL9K_VCS_RECURSE_UNTRACKED_DIRS:#0}:+-e} \
        POWERLEVEL9K
    } always {
      trap ':' INT
    }
  }
  (( $+GITSTATUS_DAEMON_PID_POWERLEVEL9K )) || _p9k__instant_prompt_disabled=1
}

function _p9k_iterm2_precmd() {
  builtin zle && return
  if (( _p9k__iterm_cmd )) && [[ -t 1 ]]; then
    (( _p9k__iterm_cmd == 1 )) && builtin print -n '\e]133;C;\a'
    builtin printf '\e]133;D;%s\a' $1
  fi
  typeset -gi _p9k__iterm_cmd=1
}

function _p9k_iterm2_preexec() {
  [[ -t 1 ]] && builtin print -n '\e]133;C;\a'
  typeset -gi _p9k__iterm_cmd=2
}

_p9k_init() {
  _p9k_init_vars
  _p9k_restore_state || _p9k_init_cacheable

  typeset -g P9K_OS_ICON=$_p9k_os_icon

  local -a _p9k__async_segments_compute

  local -i i
  local elem

  _p9k__prompt_side=left
  _p9k__segment_index=1
  for i in {1..$#_p9k_line_segments_left}; do
    for elem in ${${(@0)_p9k_line_segments_left[i]}%_joined}; do
      local f_init=_p9k_prompt_${elem}_init
      (( $+functions[$f_init] )) && $f_init
      (( ++_p9k__segment_index ))
    done
  done

  _p9k__prompt_side=right
  _p9k__segment_index=1
  for i in {1..$#_p9k_line_segments_right}; do
    for elem in ${${(@0)_p9k_line_segments_right[i]}%_joined}; do
      local f_init=_p9k_prompt_${elem}_init
      (( $+functions[$f_init] )) && $f_init
      (( ++_p9k__segment_index ))
    done
  done

  if [[ -n $_POWERLEVEL9K_PUBLIC_IP_VPN_INTERFACE ||
        -n $_POWERLEVEL9K_IP_INTERFACE ||
        -n $_POWERLEVEL9K_VPN_IP_INTERFACE ]]; then
     _p9k_prompt_net_iface_init
  fi

  if [[ -n $_p9k__async_segments_compute ]]; then
    functions[_p9k_async_segments_compute]=${(pj:\n:)_p9k__async_segments_compute}
    _p9k_worker_start
  fi

  local k v
  for k v in ${(kv)_p9k_display_k}; do
    [[ $k == -* ]] && continue
    _p9k__display_v[v]=$k
    _p9k__display_v[v+1]=show
  done
  _p9k__display_v[2]=hide
  _p9k__display_v[4]=hide

  if (( $+functions[iterm2_decorate_prompt] )); then
    _p9k__iterm2_decorate_prompt=$functions[iterm2_decorate_prompt]
    function iterm2_decorate_prompt() {
      typeset -g ITERM2_PRECMD_PS1=$PROMPT
      typeset -g ITERM2_SHOULD_DECORATE_PROMPT=
    }
  fi
  if (( $+functions[iterm2_precmd] )); then
    _p9k__iterm2_precmd=$functions[iterm2_precmd]
    functions[iterm2_precmd]='local _p9k_status=$?; zle && return; () { return $_p9k_status; }; '$_p9k__iterm2_precmd
  fi

  if (( _POWERLEVEL9K_TERM_SHELL_INTEGRATION  &&
        ! $+_z4h_iterm_cmd                    &&
        ! $+functions[iterm2_decorate_prompt] &&
        ! $+functions[iterm2_precmd] )); then
    typeset -gi _p9k__iterm_cmd=0
  fi

  if _p9k_segment_in_use todo; then
    if [[ -n ${_p9k__todo_command::=${commands[todo.sh]}} ]]; then
      local todo_global=/etc/todo/config
    elif [[ -n ${_p9k__todo_command::=${commands[todo-txt]}} ]]; then
      local todo_global=/etc/todo-txt/config
    fi
    if [[ -n $_p9k__todo_command ]]; then
      _p9k__todo_file="$(exec -a $_p9k__todo_command ${commands[bash]:-:} 3>&1 &>/dev/null -c "
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/.todo/config
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\$HOME/.todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\${XDG_CONFIG_HOME:-\$HOME/.config}/todo/config
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=${(qqq)_p9k__todo_command:h}/todo.cfg
        [ -e \"\$TODOTXT_CFG_FILE\" ] || TODOTXT_CFG_FILE=\${TODOTXT_GLOBAL_CFG_FILE:-${(qqq)todo_global}}
        [ -r \"\$TODOTXT_CFG_FILE\" ] || exit
        source \"\$TODOTXT_CFG_FILE\"
        printf "%s" \"\$TODO_FILE\" >&3")"
    fi
  fi

  if _p9k_segment_in_use dir &&
     [[ $_POWERLEVEL9K_SHORTEN_STRATEGY == truncate_with_package_name && $+commands[jq] == 0 ]]; then
    print -rP -- '%F{yellow}WARNING!%f %BPOWERLEVEL9K_SHORTEN_STRATEGY=truncate_with_package_name%b requires %F{green}jq%f.'
    print -rP -- 'Either install %F{green}jq%f or change the value of %BPOWERLEVEL9K_SHORTEN_STRATEGY%b.'
  fi

  _p9k_init_vcs

  if (( _p9k__instant_prompt_disabled )); then
    (( _POWERLEVEL9K_DISABLE_INSTANT_PROMPT )) && unset __p9k_instant_prompt_erased
    _p9k_delete_instant_prompt
    _p9k_dumped_instant_prompt_sigs=()
  fi

  if (( $+__p9k_instant_prompt_sourced && __p9k_instant_prompt_sourced != __p9k_instant_prompt_version )); then
    _p9k_delete_instant_prompt
    _p9k_dumped_instant_prompt_sigs=()
  fi

  if (( $+__p9k_instant_prompt_erased )); then
    unset __p9k_instant_prompt_erased
    if [[ -w $TTY ]]; then
      local tty=$TTY
    elif [[ -w /dev/tty ]]; then
      local tty=/dev/tty
    else
      local tty=/dev/null
    fi
    {
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-[%1FERROR%f]: When using instant prompt, Powerlevel10k must be loaded before the first prompt.}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-You can:}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-  - %BRecommended%b: Change the way Powerlevel10k is loaded from %B$__p9k_zshrc_u%b.}"
      if (( _p9k_term_has_href )); then
        >&2 echo    - "${(%):-    See \e]8;;https://github.com/romkatv/powerlevel10k/blob/master/README.md#installation\ahttps://github.com/romkatv/powerlevel10k/blob/master/README.md#installation\e]8;;\a.}"
      else
        >&2 echo    - "${(%):-    See https://github.com/romkatv/powerlevel10k/blob/master/README.md#installation.}"
      fi
      if (( $+zsh_defer_options )); then
        >&2 echo -E - ""
        >&2 echo -E - "${(%):-    NOTE: Do not use %1Fzsh-defer%f to load %Upowerlevel10k.zsh-theme%u.}"
      elif (( $+functions[zinit] )); then
        >&2 echo -E - ""
        >&2 echo -E - "${(%):-    NOTE: If using %2Fzinit%f to load %3F'romkatv/powerlevel10k'%f, %Bdo not apply%b %1Fice wait%f.}"
      elif (( $+functions[zplugin] )); then
        >&2 echo -E - ""
        >&2 echo -E - "${(%):-    NOTE: If using %2Fzplugin%f to load %3F'romkatv/powerlevel10k'%f, %Bdo not apply%b %1Fice wait%f.}"
      fi
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
      >&2 echo -E - "${(%):-    * Zsh will start %Bquickly%b.}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-  - Disable instant prompt either by running %Bp10k configure%b or by manually}"
      >&2 echo -E - "${(%):-    defining the following parameter:}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-      %3Ftypeset%f -g POWERLEVEL9K_INSTANT_PROMPT=off}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-    * You %Bwill not%b see this error message again.}"
      >&2 echo -E - "${(%):-    * Zsh will start %Bslowly%b.}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-  - Do nothing.}"
      >&2 echo -E - ""
      >&2 echo -E - "${(%):-    * You %Bwill%b see this error message every time you start zsh.}"
      >&2 echo -E - "${(%):-    * Zsh will start %Bslowly%b.}"
      >&2 echo -E - ""
    } 2>>$tty
  fi
}

_p9k_deinit() {
  (( $+functions[_p9k_preinit] )) && unfunction _p9k_preinit
  (( $+functions[gitstatus_stop_p9k_] )) && gitstatus_stop_p9k_ POWERLEVEL9K
  _p9k_worker_stop
  if (( _p9k__state_dump_fd )); then
    zle -F $_p9k__state_dump_fd
    exec {_p9k__state_dump_fd}>&-
  fi
  if (( _p9k__restore_prompt_fd )); then
    zle -F $_p9k__restore_prompt_fd
    exec {_p9k__restore_prompt_fd}>&-
  fi
  if (( _p9k__redraw_fd )); then
    zle -F $_p9k__redraw_fd
    exec {_p9k__redraw_fd}>&-
  fi
  (( $+_p9k__iterm2_precmd )) && functions[iterm2_precmd]=$_p9k__iterm2_precmd
  (( $+_p9k__iterm2_decorate_prompt )) && functions[iterm2_decorate_prompt]=$_p9k__iterm2_decorate_prompt
  unset -m '(_POWERLEVEL9K_|P9K_|_p9k_)*~(P9K_SSH|P9K_TOOLBOX_NAME|P9K_TTY|_P9K_TTY)'
  [[ -n $__p9k_locale ]] || unset __p9k_locale
}

typeset -gi __p9k_enabled=0
typeset -gi __p9k_configured=0
typeset -gri __p9k_instant_prompt_disabled=1

# `typeset -g` doesn't roundtrip in zsh prior to 5.4.
if is-at-least 5.4; then
  typeset -gri __p9k_dumps_enabled=1
else
  typeset -gri __p9k_dumps_enabled=0
fi

_p9k_do_nothing() { true; }

_p9k_precmd_first() {
  eval "$__p9k_intro"
  if [[ -n $KITTY_SHELL_INTEGRATION && KITTY_SHELL_INTEGRATION[(wIe)no-prompt-mark] -eq 0 ]]; then
    KITTY_SHELL_INTEGRATION+=' no-prompt-mark'
    (( $+__p9k_force_term_shell_integration )) || typeset -gri __p9k_force_term_shell_integration=1
  fi
  typeset -ga precmd_functions=(${precmd_functions:#_p9k_precmd_first})
}

_p9k_setup() {
  (( __p9k_enabled )) && return

  prompt_opts=(percent subst)
  if (( ! $+__p9k_instant_prompt_active )); then
    prompt_opts+=sp
    prompt_opts+=cr
  fi

  prompt_powerlevel9k_teardown
  __p9k_enabled=1
  typeset -ga preexec_functions=(_p9k_preexec1 $preexec_functions _p9k_preexec2)
  typeset -ga precmd_functions=(_p9k_do_nothing _p9k_precmd_first $precmd_functions _p9k_precmd)
}

prompt_powerlevel9k_setup() {
  _p9k_restore_special_params
  eval "$__p9k_intro"
  _p9k_setup
}

prompt_powerlevel9k_teardown() {
  _p9k_restore_special_params
  eval "$__p9k_intro"
  add-zsh-hook -D precmd '(_p9k_|powerlevel9k_)*'
  add-zsh-hook -D preexec '(_p9k_|powerlevel9k_)*'
  PROMPT='%m%# '
  RPROMPT=
  if (( __p9k_enabled )); then
    _p9k_deinit
    __p9k_enabled=0
  fi
}

typeset -gr __p9k_p10k_usage="Usage: %2Fp10k%f %Bcommand%b [options]

Commands:

  %Bconfigure%b  run interactive configuration wizard
  %Breload%b     reload configuration
  %Bsegment%b    print a user-defined prompt segment
  %Bdisplay%b    show, hide or toggle prompt parts
  %Bhelp%b       print this help message

Print help for a specific command:

  %2Fp10k%f %Bhelp%b command"

typeset -gr __p9k_p10k_segment_usage="Usage: %2Fp10k%f %Bsegment%b [-h] [{+|-}re] [-s state] [-b bg] [-f fg] [-i icon] [-c cond] [-t text]

Print a user-defined prompt segment. Can be called only during prompt rendering.

Options:
  -t text   segment's main content; will undergo prompt expansion: '%%F{blue}%%*%%f' will
            show as %F{blue}%*%f; default is empty
  -i icon   segment's icon; default is empty
  -r        icon is a symbolic reference that needs to be resolved; for example, 'LOCK_ICON'
  +r        icon is already resolved and should be printed literally; for example, '⭐';
            this is the default; you can also use \$'\u2B50' if you don't want to have
            non-ascii characters in source code
  -b bg     background color; for example, 'blue', '4', or '#0000ff'; empty value means
            transparent background, as in '%%k'; default is black
  -f fg     foreground color; for example, 'blue', '4', or '#0000ff'; empty value means
            default foreground color, as in '%%f'; default is empty
  -s state  segment's state for the purpose of applying styling options; if you want to
            to be able to use POWERLEVEL9K parameters to specify different colors or icons
            depending on some property, use different states for different values of that
            property
  -c        condition; if empty after parameter expansion and process substitution, the
            segment is hidden; this is an advanced feature, use with caution; default is '1'
  -e        segment's main content will undergo parameter expansion and process
            substitution; the content will be surrounded with double quotes and thus
            should quote its own double quotes; this is an advanced feature, use with
            caution
  +e        segment's main content should not undergo parameter expansion and process
            substitution; this is the default
  -h        print this help message

Example: 'core' segment tells you if there is a file name 'core' in the current directory.

- Segment's icon is '⭐'.
- Segment's text is the file's size in bytes.
- If you have permissions to delete the file, state is DELETABLE. If not, it's PROTECTED.

  zmodload -F zsh/stat b:zstat

  function prompt_core() {
    local size=()
    if ! zstat -A size +size core 2>/dev/null; then
      # No 'core' file in the current directory.
      return
    fi
    if [[ -w . ]]; then
      local state=DELETABLE
    else
      local state=PROTECTED
    fi
    p10k segment -s \$state -i '⭐' -f blue -t \${size[1]}b
  }

To enable this segment, add 'core' to POWERLEVEL9K_LEFT_PROMPT_ELEMENTS or
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS.

Example customizations:

  # Override default foreground.
  POWERLEVEL9K_CORE_FOREGROUND=red

  # Override foreground when DELETABLE.
  POWERLEVEL9K_CORE_DELETABLE_BACKGROUND=green

  # Override icon when PROTECTED.
  POWERLEVEL9K_CORE_PROTECTED_VISUAL_IDENTIFIER_EXPANSION='❎'

  # Don't show file size when PROTECTED.
  POWERLEVEL9K_CORE_PROTECTED_CONTENT_EXPANSION=''"

typeset -gr __p9k_p10k_configure_usage="Usage: %2Fp10k%f %Bconfigure%b

Run interactive configuration wizard."

typeset -gr __p9k_p10k_reload_usage="Usage: %2Fp10k%f %Breload%b

Reload configuration."

typeset -gr __p9k_p10k_finalize_usage="Usage: %2Fp10k%f %Bfinalize%b

Perform the final stage of initialization. Must be called at the very end of zshrc."

typeset -gr __p9k_p10k_display_usage="Usage: %2Fp10k%f %Bdisplay%b part-pattern=state-list...

  Show, hide or toggle prompt parts. If called from zle, the current
  prompt is refreshed.

Usage: %2Fp10k%f %Bdisplay%b -a [part-pattern]...

  Populate array \`reply\` with states of prompt parts matching the patterns.
  If no patterns are supplied, assume \`*\`.

Usage: %2Fp10k%f %Bdisplay%b -r

  Redisplay prompt.

Parts:
  empty_line    empty line (duh)
  ruler         ruler; if POWERLEVEL9K_RULER_CHAR=' ', it's essentially another
                new_line
  N             prompt line number N, 1-based; counting from the top if positive,
                from the bottom if negative
  N/left_frame  left frame on the Nth line
  N/left        left prompt on the Nth line
  N/gap         gap between left and right prompts on the Nth line
  N/right       right prompt on the Nth line
  N/right_frame right frame on the Nth line
  N/left/S      segment S within N/left (dir, time, etc.)
  N/right/S     segment S within N/right (dir, time, etc.)

Part States:
  show          the part is displayed
  hide          the part is not displayed
  print         the part is printed in precmd; only applicable to empty_line and
                ruler; unlike show, the effects of print cannot be undone with hide;
                print used to look better after \`clear\` but this is no longer the
                case; it's best to avoid it unless you know what you are doing

part-pattern is a glob pattern for parts. Examples:

  */kubecontext         all kubecontext prompt segments, regardless of where
                        they are
  1/(right|right_frame) all prompt segments and frame from the right side of
                        the first line

state-list is a comma-separated list of states. Must have at least one element.
If more than one, states will rotate.

Example: Bind Ctrl+P to toggle right prompt.

  function toggle-right-prompt() { p10k display '*/right'=hide,show; }
  zle -N toggle-right-prompt
  bindkey '^P' toggle-right-prompt

Example: Print the current state of all prompt parts:

  typeset -A reply
  p10k display -a '*'
  printf '%%-32s = %%q\n' \${(@kv)reply} | sort
"

# 0  -- reset-prompt not blocked
# 1  -- reset-prompt blocked and not needed
# 2  -- reset-prompt blocked and needed
typeset -gi __p9k_reset_state

function p10k() {
  [[ $# != 1 || $1 != finalize ]] || { p10k-instant-prompt-finalize; return 0 }

  eval "$__p9k_intro_no_reply"

  if (( !ARGC )); then
    print -rP -- $__p9k_p10k_usage >&2
    return 1
  fi

  case $1 in
    segment)
      local REPLY
      local -a reply
      shift
      local -i OPTIND
      local OPTARG opt state bg=0 fg icon cond text ref=0 expand=0
      while getopts ':s:b:f:i:c:t:reh' opt; do
        case $opt in
          s) state=$OPTARG;;
          b) bg=$OPTARG;;
          f) fg=$OPTARG;;
          i) icon=$OPTARG;;
          c) cond=${OPTARG:-'${:-}'};;
          t) text=$OPTARG;;
          r) ref=1;;
          e) expand=1;;
          +r) ref=0;;
          +e) expand=0;;
          h) print -rP -- $__p9k_p10k_segment_usage; return 0;;
          ?) print -rP -- $__p9k_p10k_segment_usage >&2; return 1;;
        esac
      done
      if (( OPTIND <= ARGC )); then
        print -rP -- $__p9k_p10k_segment_usage >&2
        return 1
      fi
      if [[ -z $_p9k__prompt_side ]]; then
        print -rP -- "%1F[ERROR]%f %Bp10k segment%b: can be called only during prompt rendering." >&2
        if (( !ARGC )); then
          print -rP -- ""
          print -rP -- "For help, type:" >&2
          print -rP -- ""
          print -rP -- "  %2Fp10k%f %Bhelp%b %Bsegment%b" >&2
        fi
        return 1
      fi
      (( ref )) || icon=$'\1'$icon
      typeset -i _p9k__has_upglob
      "_p9k_${_p9k__prompt_side}_prompt_segment" "prompt_${_p9k__segment_name}${state:+_${${(U)state}//İ/I}}" \
          "$bg" "${fg:-$_p9k_color1}" "$icon" "$expand" "$cond" "$text"
      return 0
      ;;
    display)
      if (( ARGC == 1 )); then
        print -rP -- $__p9k_p10k_display_usage >&2
        return 1
      fi
      shift
      local -i k dump
      local opt prev new pair list name var
      while getopts ':har' opt; do
        case $opt in
          r)
            if (( __p9k_reset_state > 0 )); then
              __p9k_reset_state=2
            else
              __p9k_reset_state=-1
            fi
          ;;
          a) dump=1;;
          h) print -rP -- $__p9k_p10k_display_usage; return 0;;
          ?) print -rP -- $__p9k_p10k_display_usage >&2; return 1;;
        esac
      done
      if (( dump )); then
        reply=()
        shift $((OPTIND-1))
        (( ARGC )) || set -- '*'
        for opt; do
          for k in ${(u@)_p9k_display_k[(I)$opt]:/(#m)*/$_p9k_display_k[$MATCH]}; do
            reply+=($_p9k__display_v[k,k+1])
          done
        done
        if (( __p9k_reset_state == -1 )); then
          _p9k_reset_prompt
        fi
        return 0
      fi
      local REPLY
      local -a reply
      for opt in "${@:$OPTIND}"; do
        pair=(${(s:=:)opt})
        list=(${(s:,:)${pair[2]}})
        if [[ ${(b)pair[1]} == $pair[1] ]]; then # this branch is purely for optimization
          local ks=($_p9k_display_k[$pair[1]])
        else
          local ks=(${(u@)_p9k_display_k[(I)$pair[1]]:/(#m)*/$_p9k_display_k[$MATCH]})
        fi
        for k in $ks; do
          if (( $#list == 1 )); then  # this branch is purely for optimization
            [[ $_p9k__display_v[k+1] == $list[1] ]] && continue
            new=$list[1]
          else
            new=${list[list[(I)$_p9k__display_v[k+1]]+1]:-$list[1]}
            [[ $_p9k__display_v[k+1] == $new ]] && continue
          fi
          _p9k__display_v[k+1]=$new
          name=$_p9k__display_v[k]
          if [[ $name == (empty_line|ruler) ]]; then
            var=_p9k__${name}_i
            [[ $new == show ]] && unset $var || typeset -gi $var=3
          elif [[ $name == (#b)(<->)(*) ]]; then
            var=_p9k__${match[1]}${${${${match[2]//\/}/#left/l}/#right/r}/#gap/g}
            [[ $new == hide ]] && typeset -g $var= || unset $var
          fi
          if (( __p9k_reset_state > 0 )); then
            __p9k_reset_state=2
          else
            __p9k_reset_state=-1
          fi
        done
      done
      if (( __p9k_reset_state == -1 )); then
        _p9k_reset_prompt
      fi
      ;;
    configure)
      if (( ARGC > 1 )); then
        print -rP -- $__p9k_p10k_configure_usage >&2
        return 1
      fi
      local REPLY
      local -a reply
      p9k_configure "$@" || return
      ;;
    reload)
      if (( ARGC > 1 )); then
        print -rP -- $__p9k_p10k_reload_usage >&2
        return 1
      fi
      (( $+_p9k__force_must_init )) || return 0
      _p9k__force_must_init=1
      ;;
    help)
      local var=__p9k_p10k_$2_usage
      if (( $+parameters[$var] )); then
        print -rP -- ${(P)var}
        return 0
      elif (( ARGC == 1 )); then
        print -rP -- $__p9k_p10k_usage
        return 0
      else
        print -rP -- $__p9k_p10k_usage >&2
        return 1
      fi
      ;;
    finalize)
      print -rP -- $__p9k_p10k_finalize_usage >&2
      return 1
      ;;
    clear-instant-prompt)
      if (( $+__p9k_instant_prompt_active )); then
        _p9k_clear_instant_prompt
        unset __p9k_instant_prompt_active
      fi
      return 0
      ;;
    *)
      print -rP -- $__p9k_p10k_usage >&2
      return 1
      ;;
  esac
}

# Hook for zplugin.
powerlevel10k_plugin_unload() { prompt_powerlevel9k_teardown; }

function p10k-instant-prompt-finalize() {
  unsetopt local_options
  (( ${+__p9k_instant_prompt_active} )) && unsetopt prompt_cr prompt_sp || setopt prompt_cr prompt_sp
}

autoload -Uz add-zsh-hook

zmodload zsh/datetime
zmodload zsh/mathfunc
zmodload zsh/parameter 2>/dev/null  # https://github.com/romkatv/gitstatus/issues/58#issuecomment-553407177
zmodload zsh/system
zmodload zsh/termcap
zmodload zsh/terminfo
zmodload zsh/zleparameter
zmodload -F zsh/stat b:zstat
zmodload -F zsh/net/socket b:zsocket
zmodload -F zsh/files b:zf_mv b:zf_rm

if [[ $__p9k_dump_file != $__p9k_instant_prompt_dump_file && -n $__p9k_instant_prompt_dump_file ]]; then
  _p9k_delete_instant_prompt
  zf_rm -f -- $__p9k_dump_file{,.zwc} 2>/dev/null
  zf_rm -f -- $__p9k_instant_prompt_dump_file{,.zwc} 2>/dev/null
fi

unset VSCODE_SHELL_INTEGRATION

_p9k_init_ssh
_p9k_init_toolbox
prompt_powerlevel9k_setup
