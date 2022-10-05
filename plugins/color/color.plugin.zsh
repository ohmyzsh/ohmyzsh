declare -a _COLOR_COMMANDS _BGCOLOR_COMMANDS
declare -A _COLOR_CODES_16 _COLOR_CODES_256 _COLOR_CODES_GRAYS
export _COLOR_COMMANDS=()
export _BGCOLOR_COMMANDS=()
export _COLOR_CODES_16=()
export _COLOR_CODES_256=()
export _COLOR_CODES_GRAYS=()

function color() {
  _color_encode "$1" "$2" "${3:-default}"
}

function _color() {
  if [ ${#_COLOR_COMMANDS[@]} -eq 0 ]; then
    _color_set_commands
  fi
  _arguments -C "1:color:->cmnds" \
                "2: :" \
                '3:no reset:((1\:"do not add reset sequence at end" default\:"add reset sequence at end"))' \
                && ret=0
  case $state in
  cmnds)
    _describe "command" _COLOR_COMMANDS && ret=0
    ;;
  esac
}
compdef _color color

function bgcolor() {
  local color_code row
  color_code=$(cut -d ',' -f 1 <<<"$1")
  row=$(cut -d ',' -f 2 <<<"$1")
  _bgcolor_encode "$color_code" "$row" "$2" "${3:-default}"
}

function _bgcolor() {
  if [ ${#_BGCOLOR_COMMANDS[@]} -eq 0 ]; then
    _bgcolor_set_commands
  fi
  _arguments -C "1:bgcolor:->cmnds" \
                "2: :" \
                '3:no reset:((1\:"do not add reset sequence at end" default\:"add reset sequence at end"))' \
                && ret=0
  case $state in
  cmnds)
    _describe "command" _BGCOLOR_COMMANDS && ret=0
    ;;
  esac
}
compdef _bgcolor bgcolor

function color_bg() {
  local color_code row
  color_code=$(cut -d ',' -f 1 <<<"$2")
  row=$(cut -d ',' -f 2 <<<"$2")
  _bgcolor_encode "$color_code" "$row" '' '1'
  _color_encode "$1" "$3" "${4:-default}"
}

function _color_bg() {
  _arguments -C "1:color:->colors" \
                "2:bgcolor:->bgcolors" \
                "3: :" \
                '4:no reset:((1\:"do not add reset sequence at end" default\:"add reset sequence at end"))' \
                && ret=0
  case $state in
  colors)
    if [ ${#_COLOR_COMMANDS[@]} -eq 0 ]; then
      _color_set_commands
    fi
    _describe "command" _COLOR_COMMANDS && ret=0
    ;;
  bgcolors)
    if [ ${#_BGCOLOR_COMMANDS[@]} -eq 0 ]; then
      _bgcolor_set_commands
    fi
    _describe "command" _BGCOLOR_COMMANDS && ret=0
    ;;
  esac
}
compdef _color_bg color_bg


function _color_encode() {
  local code=$(printf %03d $1)
  echo -ne "\033[38;5;${code}m"
  echo -ne "$2"
  if [[ "${3:-default}" != '1' ]]; then
    echo -ne "\033[0m"
  fi
}

function _bgcolor_encode() {
  local code=$(printf %03d $1)
  local precode
  if (($2 % 2 == 0)); then
    precode='1;37'
    # echo -ne "\033[1;37m"
  else
    precode='0;30'
    # echo -ne "\033[0;30m"
  fi
  echo -ne "\033[${precode}m\033[48;5;${code}m"
  echo -n "$3"
  if [[ "${4:-default}" != '1' ]]; then
    echo -ne "\033[0m"
  fi
}


function _color_set_commands() {
  local code row display_code
  _color_set_codes
  _COLOR_COMMANDS=()
  for code row in ${(kv)_COLOR_CODES_16}; do
    display_code=$(printf %03d $code)
    _COLOR_COMMANDS+=("${display_code}:$(_bgcolor_encode $code $row '   16 color   ') $(_color_encode $code "${display_code}")")
  done
  for code row in ${(kv)_COLOR_CODES_GRAYS}; do
      display_code=$(printf %03d $code)
      _COLOR_COMMANDS+=("${display_code}:$(_bgcolor_encode $code $row '   greyscale   ') $(_color_encode $code "${display_code}")")
  done
  for code row in ${(kv)_COLOR_CODES_256}; do
    display_code=$(printf %03d $code)
    _COLOR_COMMANDS+=("${display_code}:$(_bgcolor_encode $code $row '   256 color   ') $(_color_encode $code "${display_code}")")
  done
  export _COLOR_COMMANDS
}

function _bgcolor_set_commands() {
  local code display_code row
  _color_set_codes
  _BGCOLOR_COMMANDS=()
  for code row in ${(kv)_COLOR_CODES_16}; do
    display_code=$(printf %03d $code)
    _BGCOLOR_COMMANDS+=("${display_code},${row}:$(_bgcolor_encode $code $row '   16 color   ') $(_color_encode $code "${display_code}")")
  done
  for code row in ${(kv)_COLOR_CODES_GRAYS}; do
      display_code=$(printf %03d $code)
      _BGCOLOR_COMMANDS+=("${code},${row}:$(_bgcolor_encode $code $row '   greyscale   ') $(_color_encode $code "${display_code}")")
  done
  for code row in ${(kv)_COLOR_CODES_256}; do
    display_code=$(printf %03d $code)
    _BGCOLOR_COMMANDS+=("${display_code},${row}:$(_bgcolor_encode $code $row '   256 color   ') $(_color_encode $code "${display_code}")")
  done
  export _BGCOLOR_COMMANDS
}

function _color_set_codes() {
  local row col code blockrow blockcol red green blue
  if [ ${#_COLOR_CODES_16[@]} -eq 0 ]; then
    _COLOR_CODES_16=()
    for row in {0..1}; do
      for col in {0..7}; do
        code=$((row * 8 + col))
        _COLOR_CODES_16+=( [$code]="$row" )
      done
    done
    export _COLOR_CODES_16
  fi
  if [ ${#_COLOR_CODES_GRAYS[@]} -eq 0 ]; then
    _COLOR_CODES_GRAYS=()
    for row in {0..1}; do
      for col in {0..11}; do
        code=$((row * 12 + col + 232))
        _COLOR_CODES_GRAYS+=( [$code]="$row" )
      done
    done
    export _COLOR_CODES_GRAYS
  fi
  if [ ${#_COLOR_CODES_256[@]} -eq 0 ]; then
    _COLOR_CODES_256=()
    for blockrow in {0..2}; do
      for red in {0..5}; do
        for blockcol in {0..1}; do
          green=$((blockrow * 2 + blockcol))
          for blue in {0..5}; do
            code=$((red * 36 + green * 6 + blue + 16))
            _COLOR_CODES_256+=( [$code]="$green" )
          done
        done
      done
    done
    export _COLOR_CODES_256
  fi
}
