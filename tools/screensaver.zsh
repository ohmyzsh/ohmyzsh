#!/usr/bin/env zsh
# Shared on-demand renderer for `omz screensaver <scene>`.
# The CLI launches a separate Zsh process, keeping all state out of the caller.
{
  emulate -L zsh
  setopt extendedglob
  unsetopt multibyte

  integer tick=0 width=96 height=28 resized=1 active=0 seconds_limit=0
  integer mono=0 snapshot=0
  local saved_tty='' key='' blank='' result='' scene=''
  local -a canvas inks palette

  _zshell_usage() {
    print -r -- 'Oh My Zsh / experimental screensavers

Usage: omz screensaver [aquarium|logo|hermit|party] [--mono] [--seconds N]
       omz screensaver [aquarium|logo|hermit|party] --snapshot [FRAME]

Alias: omz shellsaver [scene] [options]

aquarium        Sea shells, a ~ hermit crab, and a quiet current (default).
logo            The Oh My Zsh wordmark takes a bouncing coffee break.
hermit          A bewildered hermit crab tries to find its working directory.
party           A rainbow terminal stage and a crowd of dancing shell fans.

Any key returns to the shell. Ctrl-C also exits safely.
--mono          Use the terminal default foreground color.
--seconds N     Exit automatically after 1-3600 seconds.
--snapshot      Print a still at 96 columns x 28 rows (no terminal needed).

Requires Zsh 5.8+, stty, and an xterm-compatible terminal with an alternate screen.
Nothing is installed or enabled automatically.'
  }
  case "${1-}" in
    --help|-h) _zshell_usage; exit 0 ;;
    ''|--*) scene=aquarium ;;
    aquarium|logo|hermit|party) scene=$1; shift ;;
    *) print -u2 -r -- "omz screensaver: unknown scene: $1 (choose aquarium, logo, hermit, or party)"; exit 2 ;;
  esac

  while (( $# )); do
    case "$1" in
      --help|-h) _zshell_usage; exit 0 ;;
      --mono) mono=1 ;;
      --seconds)
        shift
        if [[ $1 != <1-3600> ]]; then
          print -u2 -r -- 'omz screensaver: --seconds requires an integer from 1 to 3600'
          exit 2
        fi
        seconds_limit=$1 ;;
      --snapshot)
        snapshot=1
        if [[ ${2-} == <0-100000> ]]; then tick=$2; shift; fi ;;
      *) print -u2 -r -- "omz screensaver: unknown argument: $1 (try --help)"; exit 2 ;;
    esac
    shift
  done

  # Paint into separate ASCII text and color planes. Clip before slicing so a
  # creature partly outside the viewport never wraps onto another terminal row.
  _zshell_put() {
    integer x=$1 y=$2 ink=$3 count skip
    local text=$4 prefix='' suffix='' iprefix='' isuffix=''
    (( y >= 1 && y <= height && x <= width )) || return 0
    if (( x < 1 )); then
      skip=$(( 2 - x ))
      (( skip <= ${#text} )) || return 0
      text=${text[$skip,-1]}
      x=1
    fi
    count=$(( width - x + 1 ))
    text=${text[1,$count]}
    count=${#text}
    (( count )) || return 0
    if (( x > 1 )); then
      prefix=${canvas[$y][1,$((x-1))]}
      iprefix=${inks[$y][1,$((x-1))]}
    fi
    if (( x + count <= width )); then
      suffix=${canvas[$y][$((x+count)),-1]}
      isuffix=${inks[$y][$((x+count)),-1]}
    fi
    canvas[$y]="$prefix$text$suffix"
    inks[$y]="$iprefix${(pl:$count::$ink:)}$isuffix"
  }

  _zshell_sprite() {
    integer sx=$1 sy=$2 color=$3
    shift 3
    local line
    for line in "$@"; do
      _zshell_put $sx $sy $color "$line"
      (( sy++ ))
    done
  }

  _zshell_logo() {
    # The full-size artwork and per-letter color bands match tools/upgrade.sh.
    # A compact badge preserves the bounce in narrower terminal windows.
    local -a logo logo_inks quips
    local line glyph bands run
    integer logo_width=0 logo_height span_x span_y px py x y color i j n offset
    logo=(
      '         __                                     __   '
      '  ____  / /_     ____ ___  __  __   ____  _____/ /_  '
      ' / __ \/ __ \   / __ `__ \/ / / /  /_  / / ___/ __ \ '
      '/ /_/ / / / /  / / / / / / /_/ /    / /_(__  ) / / / '
      '\____/_/ /_/  /_/ /_/ /_/\__, /    /___/____/_/ /_/  '
      '                        /____/                       '
    )
    logo_inks=(
      11111111122222222333333333334444444455555556666677777
      11111111222222223333333333344444444555555566666777777
      11111112222222233333333333444444445555555666666777777
      11111112222222333333333333444444455555556666667777777
      11111122222223333333333334444444555555556666677777777
      11112222222233333333333444444445555555666667777777777
    )
    if (( width < 64 )); then
      logo=( '.------------------.' '|    Oh My Zsh     |' '|      ~  >_       |' "'------------------'" )
      logo_inks=()
      for line in "${logo[@]}"; do
        bands=''
        for (( j=1; j<=${#line}; j++ )); do
          bands+=$((1+(j-1)*7/${#line}))
        done
        logo_inks+=( "$bands" )
      done
    fi
    for line in "${logo[@]}"; do
      (( ${#line} > logo_width )) && logo_width=${#line}
    done
    logo_height=${#logo}
    span_x=$(( width-logo_width-4 ))
    span_y=$(( height-logo_height-8 ))
    px=$(( (tick/2+span_x/2) % (2*span_x) ))
    py=$(( (tick/6+span_y/2) % (2*span_y) ))
    x=$(( 3 + (px <= span_x ? px : 2*span_x-px) ))
    y=$(( 5 + (py <= span_y ? py : 2*span_y-py) ))

    _zshell_put 3 2 1 'O H  M Y  Z S H'
    _zshell_put $((width-17)) 2 0 'prompt on a break'
    for (( i=0; i<width/14; i++ )); do
      glyph='~'; (( i % 2 )) && glyph='>'
      _zshell_put $((3+(i*23+tick/20)%(width-5))) $((4+(i*7)%(height-7))) 0 "$glyph"
    done
    # Keep the updater's red-to-pink bands attached to their letters on bounce.
    for (( i=1; i<=logo_height; i++ )); do
      line=${logo[$i]} bands=${logo_inks[$i]} offset=0
      while [[ -n $bands ]]; do
        glyph=${bands[1]}
        run=${bands%%[^$glyph]*}
        n=${#run}
        _zshell_put $((x+offset)) $((y+i-1)) $glyph "${line[1,$n]}"
        (( offset += n ))
        line=${line[$((n+1)),-1]}
        bands=${bands[$((n+1)),-1]}
      done
    done
    _zshell_put $((x+logo_width-2)) $((y+logo_height)) 1 '>_'
    if (( (px == 0 || px == span_x) && (py == 0 || py == span_y) )); then
      _zshell_put $((x-2)) $((y-1)) 3 '*'
      _zshell_put $((x+logo_width+1)) $((y-1)) 3 '*'
      _zshell_put $(( (width-17)/2 )) $((height-2)) 3 'corner committed!'
    else
      quips=( 'home is where the ~ is' 'plugins on a coffee break' 'a delightful little detour' 'your prompt will be right back' )
      line=${quips[$((1+tick/80%${#quips}))]}
      _zshell_put $(( (width-${#line})/2 )) $((height-2)) 0 "$line"
    fi
    _zshell_put 3 $height 0 'SCREENSAVER / LOGO'
    _zshell_put $((width-21)) $height 0 'any key: back to work'
  }

  _zshell_hermit() {
    integer beat=$((tick/40%8)) within=$((tick%40)) shuffle=0 x y i
    local left_eye='(o )' right_eye='(o )' mouth='._.' thought='...' legs
    # Long, still looks make the tiny blinks and indecisive steps more visible.
    case $beat in
      0) thought='...where was I going?' ;;
      1) left_eye='( o)'; right_eye='( o)'; thought='...over there?' ;;
      2) left_eye='(O )'; right_eye='( O)'; mouth=' o '; thought='pwd...?' ;;
      3) left_eye='( o)'; right_eye='(o )'; mouth='-_-'; thought='I brought home. Now what?' ;;
      4) left_eye='( o)'; right_eye='( o)'; shuffle=$((within/10)); thought='maybe this way.' ;;
      5) left_eye='( o)'; right_eye='(o )'; shuffle=3; thought='wrong directory.' ;;
      6) shuffle=$((3-within/10)); thought='cd .. ?' ;;
      7) left_eye='( ^)'; right_eye='(^ )'; mouth=' u '; thought='~ sweet ~ ...wait.' ;;
    esac
    # Short blinks run independently of the longer expression cycle.
    if (( tick%73 >= 71 )); then left_eye='( -)'; right_eye='(- )'; fi
    x=$(( (width-42)/2 + shuffle ))
    y=$(( (height-12)/2 + 1 ))
    _zshell_put 3 2 1 'O H  M Y  Z S H'
    _zshell_put $((width-21)) 2 0 'a little shell-shocked'
    # Photo-inspired three-quarter silhouette: tapered shell whorls behind
    # the exposed head, unequal eyestalks, antennae and a hanging front claw.
    _zshell_sprite $x $y 3 \
      '           __...---.' \
      "       _.-'  .--.   '." \
      "    .-'    .'    '.   \\" \
      "  .'  _.-./   ~    \   |" \
      " /  .'    \        /   |" \
      "/  / .-.   |'-----'   /" \
      '| ( ( @ )  /        /' \
      "\  \ '-' .'       .'" \
      " '-._'--'______.-'"
    # Staggered eyes on stalks; the small head emerges from the shell opening.
    _zshell_put $((x+25)) $((y+2)) 5 "$left_eye"
    _zshell_put $((x+32)) $((y+1)) 5 "$right_eye"
    _zshell_put $((x+27)) $((y+3)) 4 '|'
    _zshell_put $((x+27)) $((y+4)) 4 '|'
    _zshell_put $((x+33)) $((y+2)) 4 '/'
    _zshell_put $((x+32)) $((y+3)) 4 '/'
    _zshell_put $((x+31)) $((y+4)) 4 '/'
    _zshell_put $((x+36)) $((y+3)) 5 "_.-'"
    _zshell_put $((x+33)) $((y+4)) 5 ".-'"
    _zshell_put $((x+32)) $((y+5)) 5 '/'
    _zshell_put $((x+22)) $((y+5)) 4 '/___'
    _zshell_put $((x+21)) $((y+6)) 4 '\___'
    _zshell_put $((x+20)) $((y+7)) 4 '\__'
    _zshell_put $((x+26)) $((y+5)) 4 '.----.'
    _zshell_put $((x+25)) $((y+6)) 4 '/      \'
    _zshell_put $((x+23)) $((y+7)) 4 '__\______/'
    _zshell_put $((x+21)) $((y+8)) 4 '\___/ /\    \__'
    _zshell_put $((x+27)) $((y+6)) 5 "$mouth"
    # Legs bend down and forward instead of spreading symmetrically sideways.
    _zshell_put $((x+18)) $((y+9)) 4 '\___/ /  \___'
    _zshell_put $((x+16)) $((y+10)) 4 '___/  /       \'
    legs='             _/____/         \_'
    if (( (beat == 4 || beat == 6) && within/3%2 )); then
      legs='               /___/       _/'
    fi
    _zshell_put $x $((y+11)) 4 "$legs"
    # The big claw hangs in front. The much smaller claw tucks under the face.
    if (( beat == 3 )); then
      _zshell_sprite $((x+35)) $((y+7)) 4 ' __ ' '/   \' '| / |' ' V V '
      _zshell_put $((x+32)) $((y+6)) 4 '()'
    else
      _zshell_sprite $((x+35)) $((y+8)) 4 ' __ ' '/   \' '| / |' ' V V '
      _zshell_put $((x+30)) $((y+8)) 4 '()'
    fi
    if (( beat == 2 || beat == 5 )); then
      _zshell_put $((x+39)) $y 1 '?'
    fi
    if (( height >= 24 )); then
      for (( i=3; i<width-2; i+=5 )); do
        _zshell_put $i $((height-4)) 8 '.'
      done
    fi
    _zshell_put $(( (width-${#thought})/2 )) $((height-2)) 0 "$thought"
    _zshell_put 3 $height 0 'SCREENSAVER / HERMIT'
    _zshell_put $((width-21)) $height 0 'any key: back to home'
  }

  _zshell_party() {
    integer x y i j row col sx sy glyph_width=5 scale=1 logo_width logo_x logo_y
    integer crowd count step pose bob sway base bars profile build stature outfit hair body_rows person_height leg_y
    local line bits letter pixel border
    local -a letters letter_colors rows heads builds statures hairstyles outfits
    local -A font
    # A tiny bitmap font gives the stage the chunky, rainbow look of the image.
    # Use ASCII pixels to keep the same width in every supported terminal font.
    font=(
      O '01110 10001 10001 10001 01110'
      H '10001 10001 11111 10001 10001'
      M '10001 11011 10101 10001 10001'
      Y '10001 01010 00100 00100 00100'
      Z '11111 00010 00100 01000 11111'
      S '01111 10000 01110 00001 11110'
    )
    if (( width < 64 )); then
      glyph_width=3
      font=( O '111 101 101 101 111' H '101 101 111 101 101'
             M '101 111 111 101 101' Y '101 101 010 010 010'
             Z '111 001 010 100 111' S '111 100 111 001 111' )
    elif (( width >= 120 )); then
      scale=2
    fi
    letters=( O H M Y Z S H )
    letter_colors=( 4 3 6 1 7 2 4 )
    logo_width=$(( (7*glyph_width+6+4)*scale ))
    logo_x=$(( (width-logo_width)/2+1 ))
    logo_y=$(( height/4 )); (( logo_y < 4 )) && logo_y=4

    # A terminal window behind the crowd, including tiny window controls.
    border="+${(pl:$((width-8))::-:)}+"
    _zshell_put 4 2 5 "$border"
    _zshell_put 4 $((height-5)) 5 "$border"
    for (( y=3; y<height-5; y++ )); do
      _zshell_put 4 $y 5 '|'
      _zshell_put $((width-3)) $y 5 '|'
    done
    _zshell_put 7 2 0 ' O H  M Y  Z S H '
    _zshell_put $((width-10)) 2 4 'o'
    _zshell_put $((width-8)) 2 3 'o'
    _zshell_put $((width-6)) 2 6 'o'
    x=$logo_x
    for (( i=1; i<=7; i++ )); do
      letter=${letters[$i]}
      rows=( ${=font[$letter]} )
      for (( row=1; row<=5; row++ )); do
        bits=${rows[$row]}
        line=''
        for (( col=1; col<=glyph_width; col++ )); do
          pixel=' '; [[ ${bits[$col]} == 1 ]] && pixel='#'
          line+="${(pl:$scale::$pixel:)}"
        done
        _zshell_put $x $((logo_y+row-1)) ${letter_colors[$i]} "$line"
      done
      (( x += (glyph_width+1)*scale ))
      (( i == 2 || i == 4 )) && (( x += 2*scale ))
    done

    # Small moving meters suggest music without sound or full-screen flashes.
    for (( i=0; i<10; i++ )); do
      bars=$((1+(tick/4+i*7)%3))
      x=$((logo_x+i*logo_width/10))
      for (( j=0; j<bars; j++ )); do
        _zshell_put $x $((logo_y+7-j)) 6 ':'
      done
    done

    # Stable appearance profiles are independent of the dance cycle. Hair,
    # clothing, build and height vary separately rather than forming one type.
    builds=( 0 2 1 2 0 1 2 0 )
    statures=( 1 0 2 1 0 2 0 1 )
    hairstyles=( 0 1 2 3 4 1 0 2 )
    outfits=( 0 1 0 2 1 2 0 1 )
    count=$(( (width-2)/9 ))
    base=$(( (width-count*9)/2+1 ))
    for (( crowd=0; crowd<count; crowd++ )); do
      profile=$((crowd%8+1))
      build=${builds[$profile]} stature=${statures[$profile]}
      hair=${hairstyles[$profile]} outfit=${outfits[$profile]}
      body_rows=$((1+stature))
      person_height=$((5+body_rows))
      # Different tempos and offsets prevent synchronized, marching motion.
      step=$((tick/(3+crowd%3)+crowd*3))
      pose=$((step%4))
      bob=$((step%3 == 0))
      sway=$((pose == 1 ? 1 : 0))
      sx=$((base+crowd*9+sway))
      sy=$((height-3-person_height+bob))
      for (( row=0; row<person_height; row++ )); do
        _zshell_put $sx $((sy+row)) 0 '        '
      done
      case $hair in
        0) heads=( '  __  ' ' /  \ ' ' \__/ ' ) ;;
        1) heads=( ' /~~\ ' '(|  |)' '(|__|)' ) ;;
        2) heads=( ' .~~. ' '(:  :)' ' \__/ ' ) ;;
        3) heads=( ' _()_ ' ' /  \ ' ' \__/ ' ) ;;
        4) heads=( ' .--._' ' |  |)' ' \__/ ' ) ;;
      esac
      _zshell_sprite $((sx+1)) $sy 5 "${heads[@]}"
      for (( row=0; row<body_rows; row++ )); do
        case $build in
          0) line='  | |   ' ;;
          1) line='  |  |  ' ;;
          2) line=' |    | ' ;;
        esac
        if (( row == body_rows-1 )); then
          case $build in
            0) line='  |_|   ' ;;
            1) line='  |__|  ' ;;
            2) line=' |____| ' ;;
          esac
          (( outfit == 1 )) && line=' /____\ '
        fi
        _zshell_put $sx $((sy+3+row)) 5 "$line"
      done
      # Longer hair continues beside the shoulders; outfits aren't tied to it.
      if (( hair == 1 && body_rows > 1 )); then
        _zshell_put $((sx+1)) $((sy+3)) 5 '|'
        _zshell_put $((sx+6)) $((sy+3)) 5 '|'
      fi
      leg_y=$((sy+3+body_rows))
      if (( outfit == 2 )); then
        if (( pose%2 )); then
          _zshell_sprite $sx $leg_y 5 ' | |\ \ ' ' |_/_\_\'
        else
          _zshell_sprite $sx $leg_y 5 ' | || | ' ' |_||_| '
        fi
      else
        case $pose in
          0) _zshell_sprite $sx $leg_y 5 '  /  \  ' ' _/  \_ ' ;;
          1) _zshell_sprite $sx $leg_y 5 '   > /  ' '  / /_  ' ;;
          2) _zshell_sprite $sx $leg_y 5 ' /  <   ' ' /_  \_ ' ;;
          3) _zshell_sprite $sx $leg_y 5 '  \  \  ' '  _\ _\ ' ;;
        esac
      fi
      # Arms animate around each silhouette, leaving hair and clothes stable.
      if (( pose == 1 || pose == 3 )); then
        _zshell_put $sx $sy 5 '\'
        _zshell_put $((sx+1)) $((sy+1)) 5 '\'
        _zshell_put $((sx+1)) $((sy+2)) 5 '|'
      else
        _zshell_put $((sx+1)) $((sy+3)) 5 '/'
        _zshell_put $sx $((sy+4)) 5 '/'
      fi
      if (( pose == 1 || pose == 2 )); then
        _zshell_put $((sx+7)) $sy 5 '/'
        _zshell_put $((sx+6)) $((sy+1)) 5 '/'
        _zshell_put $((sx+6)) $((sy+2)) 5 '|'
      else
        _zshell_put $((sx+6)) $((sy+3)) 5 '\'
        _zshell_put $((sx+7)) $((sy+4)) 5 '\'
      fi
    done
    _zshell_put 3 $height 0 'SCREENSAVER / PARTY'
    _zshell_put $((width-21)) $height 0 'any key: after-party'
  }

  _zshell_scene() {
    integer y x i j base phase sway drift bob floor=$(( height - 5 ))
    local leaf bubble
    blank=${(pl:$width:: :)}
    canvas=() inks=()
    for (( y=1; y<=height; y++ )); do
      canvas+=( "$blank" )
      inks+=( "${(pl:$width::0:)}" )
    done
    if (( width < 48 || height < 18 )); then
      if [[ $scene == aquarium ]]; then
        _zshell_put 2 2 1 'A little more ocean, please.'
      else
        _zshell_put 2 2 1 'A little more room, please.'
      fi
      _zshell_put 2 4 0 'Resize to at least 49 x 18.'
      _zshell_put 2 6 0 'Any key returns to your shell.'
      return
    fi
    if [[ $scene == logo ]]; then
      _zshell_logo
      return
    elif [[ $scene == hermit ]]; then
      _zshell_hermit
      return
    elif [[ $scene == party ]]; then
      _zshell_party
      return
    fi

    _zshell_put 3 2 1 'O H  M Y  Z S H'
    _zshell_put $((width-17)) 2 0 'a shell aquarium'
    _zshell_put 3 $height 0 'SCREENSAVER / AQUARIUM'
    _zshell_put $((width-22)) $height 0 'any key: back to shore'

    # Tiny particles occupy the background; bubbles rise at different speeds.
    for (( i=0; i<width/7; i++ )); do
      x=$(( 2 + (i * 31 + tick / 24) % (width - 3) ))
      y=$(( 4 + (i * 11 + 3) % (floor - 5) ))
      _zshell_put $x $y 0 '.'
    done
    for (( i=0; i<5; i++ )); do
      y=$(( floor - 1 - (tick / (3 + i % 2) + i * 5) % (floor - 4) ))
      x=$(( 5 + (i * 23 + tick / 18 + (y % 3)) % (width - 9) ))
      bubble='o'
      (( (y+i) % 3 )) && bubble='.'
      _zshell_put $x $y 7 "$bubble"
    done

    # Sand and tide marks.
    for (( x=2; x<width; x+=3 )); do
      _zshell_put $x $((floor+3)) 8 '.'
      (( x % 2 )) && _zshell_put $((x+1)) $((floor+2)) 8 '_'
    done
    for (( i=0; i<4; i++ )); do
      base=$(( i < 2 ? 3 + i * 4 : width - 4 - (i-2)*4 ))
      for (( j=0; j<4+i%2; j++ )); do
        sway=$(( (tick/7 + j + i) % 4 ))
        leaf=')'; (( sway > 1 )) && leaf='('
        _zshell_put $((base + (sway>1))) $((floor+1-j)) 6 "$leaf"
      done
    done

    # Spirals ride a slow current. A triangle wave provides gentle vertical bob.
    drift=$(( (tick / 9) % (width + 18) ))
    x=$(( (width/4 + drift) % (width+18) - 9 ))
    phase=$(( tick/12 % 6 )); bob=$(( phase < 3 ? phase : 5-phase ))
    _zshell_sprite $x $((5+bob)) 2 '  __ ' ' /@/)' ' \_/'

    # Nautilus moves in the opposite direction, tentacles trailing behind it.
    x=$(( (width*3/4 + width+20 - tick/6 % (width+20)) % (width+20) - 10 ))
    _zshell_sprite $x $((5+(tick/18%2))) 2 '  .---.  ' ' / (@) \ ' ' \  __/~~' '  `"   ~~'

    # A fan shell closes briefly, then scoots during the same part of its cycle.
    phase=$(( tick % 100 ))
    drift=$(( (tick/100*4 + (phase>80 ? (phase-80)/5 : 0)) % (width+14) ))
    x=$(( (width/2 + drift) % (width+14) - 7 ))
    y=$(( floor-4 - (phase>80 && phase<95 ? 1 : 0) ))
    if (( phase > 80 )); then
      _zshell_sprite $x $y 4 ' _______ ' '(_______)' '   \/'
    else
      _zshell_sprite $x $y 4 ' .-----.' ' /|/|\|\' ' \|||||/' '  \___/'
    fi

    # Conch and hermit crab live on different stretches of the seabed.
    x=$(( 7 + (width/5 + tick/24) % (width-22) ))
    _zshell_sprite $x $((floor-1)) 3 '   /\__' ' _/ / /\>' '(__/_/_)'
    x=$(( 8 + (width*2/3 + tick/10) % (width-22) ))
    if (( tick/5 % 2 )); then
      _zshell_sprite $x $((floor-1)) 5 '  .-~-. ' ' (  ~  )oo' ' _/___/\\_'
    else
      _zshell_sprite $x $((floor-1)) 5 '  .-~-. ' ' (  ~  )oo' ' /_/_/ /\'
    fi
  }

  # Render color runs rather than individual cells. One write per frame and no
  # per-frame subprocesses; the final column stays unused to prevent autowrap.
  _zshell_render() {
    integer row n
    local text colors ink run
    result=${terminfo[home]}
    for (( row=1; row<=height; row++ )); do
      text=${canvas[$row]} colors=${inks[$row]}
      while [[ -n $colors ]]; do
        ink=${colors[1]}
        run=${colors%%[^$ink]*}
        n=${#run}
        result+="${palette[$((ink+1))]}${text[1,$n]}"
        text=${text[$((n+1)),-1]}
        colors=${colors[$((n+1)),-1]}
      done
      result+=${terminfo[el]}
      (( row < height )) && result+=$'\r\n'
    done
    result+=${terminfo[sgr0]}
  }

  if (( snapshot )); then
    _zshell_scene
    print -r -- "${(F)canvas}"
    exit 0
  fi
  if [[ ! -t 0 || ! -t 1 || -z $TERM || $TERM == dumb ]]; then
    print -u2 -r -- 'omz screensaver: run in an interactive terminal (or use --snapshot)'
    exit 1
  fi
  zmodload zsh/terminfo || exit 1
  zmodload zsh/datetime || exit 1
  local capability
  for capability in smcup rmcup home clear civis cnorm sgr0 el; do
    if [[ -z ${terminfo[$capability]} ]]; then
      print -u2 -r -- "omz screensaver: terminal lacks $capability; try --snapshot"
      exit 1
    fi
  done

  if (( mono || ${+NO_COLOR} || ${terminfo[colors]:-0} < 8 )); then
    palette=( '' '' '' '' '' '' '' '' '' )
  elif (( ${terminfo[colors]} >= 256 )); then
    palette=( $'\e[38;5;60m' $'\e[38;5;159m' $'\e[38;5;183m'
              $'\e[38;5;222m' $'\e[38;5;210m' $'\e[38;5;230m'
              $'\e[38;5;72m' $'\e[38;5;110m' $'\e[38;5;137m' )
  else
    palette=( $'\e[34m' $'\e[36m' $'\e[35m' $'\e[33m' $'\e[31m'
              $'\e[37m' $'\e[32m' $'\e[36m' $'\e[33m' )
  fi

  # Match the updater's exact truecolor and 256-color rainbow. The other
  # scenes retain their own palettes, and monochrome always takes precedence.
  if [[ $scene == logo ]] && (( !mono && !${+NO_COLOR} && ${terminfo[colors]:-0} >= 8 )); then
    local -a rainbow
    if [[ $COLORTERM == (truecolor|24bit) || $TERM == (iterm|tmux-truecolor|linux-truecolor|xterm-truecolor|screen-truecolor) ]]; then
      rainbow=( $'\e[38;2;255;0;0m' $'\e[38;2;255;97;0m' $'\e[38;2;247;255;0m'
                $'\e[38;2;0;255;30m' $'\e[38;2;77;0;255m' $'\e[38;2;168;0;255m'
                $'\e[38;2;245;0;172m' )
    elif (( ${terminfo[colors]} >= 256 )); then
      rainbow=( $'\e[38;5;196m' $'\e[38;5;202m' $'\e[38;5;226m'
                $'\e[38;5;082m' $'\e[38;5;021m' $'\e[38;5;093m' $'\e[38;5;163m' )
    else
      rainbow=( $'\e[31m' $'\e[33m' $'\e[33m' $'\e[32m' $'\e[34m' $'\e[35m' $'\e[35m' )
    fi
    integer color_index
    for (( color_index=1; color_index<=7; color_index++ )); do
      palette[$((color_index+1))]=${rainbow[$color_index]}
    done
  fi

  _zshell_cleanup() {
    (( active )) || return 0
    active=0
    print -rn -- "${terminfo[sgr0]}${terminfo[cnorm]}${terminfo[rmcup]}"
    command stty "$saved_tty" 2>/dev/null
  }
  _zshell_size() {
    local dimensions
    integer old_width=$width old_height=$height first=$resized
    dimensions=$(command stty size 2>/dev/null) || return 1
    local -a size=( ${=dimensions} )
    (( ${#size} == 2 && size[1] > 0 && size[2] > 1 )) || return 1
    height=$size[1] width=$((size[2]-1))
    # Very large terminals retain a calm, bounded scene in the top-left corner.
    (( width > 180 )) && width=180
    (( height > 55 )) && height=55
    resized=0
    if (( first || old_width != width || old_height != height )); then
      print -rn -- "${terminfo[clear]}"
    fi
    return 0
  }

  saved_tty=$(command stty -g) || exit 1
  trap '_zshell_cleanup' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  trap 'exit 129' HUP
  trap 'exit 131' QUIT
  # Suspending a raw terminal would strand the parent prompt. Exit on Ctrl-Z.
  trap 'exit 148' TSTP
  trap 'resized=1' WINCH
  {
    active=1
    command stty -echo -icanon -ixon min 1 time 0 || exit 1
    print -rn -- "${terminfo[smcup]}${terminfo[civis]}"
    float started=$EPOCHREALTIME deadline wait_for next_size_check=0
    while true; do
      # Zsh can defer WINCH while a timed read is active. Poll at 2 Hz as well.
      if (( resized || EPOCHREALTIME >= next_size_check )); then
        _zshell_size || exit 1
        next_size_check=$(( EPOCHREALTIME + 0.5 ))
      fi
      tick=$(( (EPOCHREALTIME-started)*10 ))
      if (( seconds_limit && EPOCHREALTIME-started >= seconds_limit )); then break; fi
      deadline=$(( EPOCHREALTIME + 0.1 ))
      _zshell_scene
      _zshell_render
      print -rn -- "$result"
      wait_for=$(( deadline-EPOCHREALTIME ))
      (( wait_for < 0.005 )) && wait_for=0.005
      if read -r -k 1 -u 0 -t $wait_for key; then
        # Drain an arrow/function-key sequence so it cannot leak into the prompt.
        integer drained=0
        while (( drained++ < 64 )) && read -r -k 1 -u 0 -t 0.01 key; do :; done
        break
      fi
    done
  } always {
    _zshell_cleanup
  }
  exit 0
}
