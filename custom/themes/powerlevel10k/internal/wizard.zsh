local -i force=0

local opt
while getopts 'f' opt; do
  case $opt in
    f)  force=1;;
    +f) force=0;;
    \?) return 1;;
  esac
done

if (( OPTIND <= ARGC )); then
  print -lr -- "wizard.zsh: invalid arguments: $@" >&2
  return 1
fi

local -i in_z4h_wizard=0
[[ $force == 0 && $+functions[z4h] == 1 && -n $Z4H && -e $Z4H/welcome ]] && in_z4h_wizard=1

local -i success=0

local -ri force

local -r font_base_url='https://github.com/romkatv/powerlevel10k-media/raw/master'

local -ri prompt_indent=2

local -rA pure_original=(grey 242 red 1 yellow 3 blue 4 magenta 5 cyan 6 white 7)
local -rA pure_snazzy=(grey 242 red '#FF5C57' yellow '#F3F99D' blue '#57C7FF' magenta '#FF6AC1' cyan '#9AEDFE' white '#F1F1F0')
local -ra bg_color=(240 238 236 234)
local -ra sep_color=(248 246 244 242)
local -ra prefix_color=(250 248 246 244)

local -r left_circle='\uE0B6'
local -r right_circle='\uE0B4'
local -r left_arc='\uE0B7'
local -r right_arc='\uE0B5'
local -r left_triangle='\uE0B2'
local -r right_triangle='\uE0B0'
local -r left_angle='\uE0B3'
local -r right_angle='\uE0B1'
local -r fade_in='░▒▓'
local -r fade_out='▓▒░'
local -r vertical_bar='\u2502'

local -r cursor='%1{\e[07m \e[27m%}'

local -r time_24h='16:23:42'
local -r time_12h='04:23:42 PM'

local -ra lean_left=(
  '%$frame_color[$color]F╭─ ' '${extra_icons[1]:+%f$extra_icons[1] }%31F$extra_icons[2]%B%39F~%b%31F/%B%39Fsrc%b%f $prefixes[1]%76F$extra_icons[3]master%f '
  '%$frame_color[$color]F╰─' '%76F$prompt_char%f ${buffer:-$cursor}'
)

local -ra lean_right=(
  ' $prefixes[2]%101F$extra_icons[4]5s%f${time:+ $prefixes[3]%66F$extra_icons[5]$time%f}' ' %$frame_color[$color]F─╮%f'
  '' ' %$frame_color[$color]F─╯%f'
)

local -ra lean_8colors_left=(
  '%$frame_color[$color]F╭─ ' '${extra_icons[1]:+%f$extra_icons[1] }%4F$extra_icons[2]%4F~/src%f $prefixes[1]%2F$extra_icons[3]master%f '
  '%$frame_color[$color]F╰─' '%2F$prompt_char%f ${buffer:-$cursor}'
)

local -ra lean_8colors_right=(
  ' $prefixes[2]%3F$extra_icons[4]5s%f${time:+ $prefixes[3]%6F$extra_icons[5]$time%f}' ' %$frame_color[$color]F─╮%f'
  '' ' %$frame_color[$color]F─╯%f'
)

local -ra classic_left=(
  '%$frame_color[$color]F╭─' '%F{$bg_color[$color]}$left_tail%K{$bg_color[$color]} ${extra_icons[1]:+%255F$extra_icons[1] %$sep_color[$color]F$left_subsep%f }%31F$extra_icons[2]%B%39F~%b%K{$bg_color[$color]}%31F/%B%39Fsrc%b%K{$bg_color[$color]} %$sep_color[$color]F$left_subsep%f %$prefix_color[$color]F$prefixes[1]%76F$extra_icons[3]master %k%$bg_color[$color]F$left_head%f'
  '%$frame_color[$color]F╰─' '%f ${buffer:-$cursor}'
)

local -ra classic_right=(
  '%$bg_color[$color]F$right_head%K{$bg_color[$color]}%f %$prefix_color[$color]F$prefixes[2]%101F5s $extra_icons[4]${time:+%$sep_color[$color]F$right_subsep %$prefix_color[$color]F$prefixes[3]%66F$time $extra_icons[5]}%k%F{$bg_color[$color]}$right_tail%f' '%$frame_color[$color]F─╮%f'
  '' '%$frame_color[$color]F─╯%f'
)

local -ra pure_left=(
  '' '%F{$pure_color[blue]}~/src%f %F{$pure_color[grey]}master%f ${pure_use_rprompt-%F{$pure_color[yellow]\}5s%f }'
  '' '%F{$pure_color[magenta]}$prompt_char%f ${buffer:-$cursor}'
)

local -ra pure_right=(
  '${pure_use_rprompt+%F{$pure_color[yellow]\}5s%f${time:+ }}${time:+%F{$pure_color[grey]\}$time%f}' ''
  '' ''
)

local -ra rainbow_left=(
  '%$frame_color[$color]F╭─' '%F{${${extra_icons[1]:+7}:-4}}$left_tail${extra_icons[1]:+%K{7\}%232F $extra_icons[1] %K{4\}%7F$left_sep}%K{4}%254F $extra_icons[2]%B%255F~%b%K{4}%254F/%B%255Fsrc%b%K{4} %K{2}%4F$left_sep %0F$prefixes[1]$extra_icons[3]master %k%2F$left_head%f'
  '%$frame_color[$color]F╰─' '%f ${buffer:-$cursor}'
)

local -ra rainbow_right=(
  '%3F$right_head%K{3} %0F$prefixes[2]5s $extra_icons[4]%3F${time:+%7F$right_sep%K{7\} %0F$prefixes[3]$time $extra_icons[5]%7F}%k$right_tail%f' '%$frame_color[$color]F─╮%f'
  '' '%$frame_color[$color]F─╯%f'
)

function prompt_length() {
  local -i COLUMNS=1024
  local -i x y=$#1 m
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
  typeset -g REPLY=$x
}

function print_prompt() {
  [[ $parameters[extra_icons] == scalar* ]] && eval "local -a extra_icons=$extra_icons"
  [[ $parameters[pure_color] == scalar* ]] && eval "local -A pure_color=$pure_color"
  [[ $parameters[prefixes] == scalar* ]] && eval "local -a prefixes=$prefixes"

  local left=${style}_left
  local right=${style}_right
  left=("${(@P)left}")
  right=("${(@P)right}")
  (( disable_rprompt )) && right=()
  eval "left=(${(@)left:/(#b)(*)/\"$match[1]\"})"
  eval "right=(${(@)right:/(#b)(*)/\"$match[1]\"})"
  if (( num_lines == 1)); then
    left=($left[2] $left[4])
    right=($right[1] $right[3])
  else
    local c=76
    [[ $style == pure ]] && c=$pure_color[magenta]
    [[ $style == lean_8colors ]] && c=2
    (( left_frame )) || left=('' $left[2] '' "%F{$c}$prompt_char%f ${buffer:-$cursor}")
    (( right_frame )) || right=($right[1] '' '' '')
  fi
  local -i left_indent=prompt_indent
  local -i right_indent=prompt_indent
  prompt_length ${(g::):-$left[1]$left[2]$right[1]$right[2]}
  local -i width=REPLY
  while (( wizard_columns - width <= left_indent + right_indent )); do
    if (( right_indent )); then
      (( --right_indent ))
    elif (( left_indent )); then
      (( --left_indent ))
    else
      print -P '  [%3Fnot enough horizontal space to display this%f]'
      return 0
    fi
  done
  local -i i
  for ((i = 1; i < $#left; i+=2)); do
    local l=${(g::):-$left[i]$left[i+1]}
    local r=${(g::):-$right[i]$right[i+1]}
    prompt_length $l$r
    local -i gap=$((wizard_columns - left_indent - right_indent - REPLY))
    (( num_lines == 2 && i == 1 )) && local fill=$gap_char || local fill=' '
    print -n  -- ${(pl:$left_indent:: :)}
    print -nP -- $l
    print -nP -- "%$frame_color[$color]F${(pl:$gap::$fill:)}%f"
    print -P  -- $r
  done
}

function href() {
  local url=${${1//\%/%%}//\\/\\\\}
  if (( _p9k_term_has_href )); then
    print -r -- '%{\e]8;;'$url'\a%}'$url'%{\e]8;;\a%}'
  else
    print -r -- $url
  fi
}

function flowing() {
  (( ${wizard_columns:-0} )) || local -i wizard_columns=COLUMNS
  local opt
  local -i centered indentation
  while getopts 'ci:' opt; do
    case $opt in
      i)  indentation=$OPTARG;;
      c)  centered=1;;
      +c) centered=0;;
      \?) exit 1;;
    esac
  done
  shift $((OPTIND-1))
  local line word lines=()
  for word in "$@"; do
    prompt_length ${(g::):-"$line $word"}
    if (( REPLY > wizard_columns )); then
      [[ -z $line ]] || lines+=$line
      line=
    fi
    if [[ -n $line ]]; then
      line+=' '
    elif (( $#lines )); then
      line=${(pl:$indentation:: :)}
    fi
    line+=$word
  done
  [[ -z $line ]] || lines+=$line
  for line in $lines; do
    prompt_length ${(g::)line}
    (( centered && REPLY < wizard_columns )) && print -n -- ${(pl:$(((wizard_columns - REPLY) / 2)):: :)}
    print -P -- $line
  done
}

function clear() {
  if (( $+commands[clear] )) && command clear 2>/dev/null; then
    return
  fi
  echoti clear 2>/dev/null
  print -n -- "\e[H\e[2J\e[3J"
}

function hide_cursor() {
  (( $+terminfo[cnorm] )) || return
  echoti civis 2>/dev/null
}

function show_cursor() {
  local cnorm=${terminfo[cnorm]-}
  if [[ $cnorm == *$'\e[?25h'(|'\e'*) ]]; then
    print -n '\e[?25h'
  else
    print -n $cnorm
  fi
}

function consume_input() {
  local key
  while true; do
    [[ -t 2 ]]
    read -t0 -k key || break
  done 2>/dev/null
}

function quit() {
  consume_input
  if [[ $1 == '-c' ]]; then
    print -Pr -- ''
    print -Pr -- '%b%k%f%u%s'
    print -Pr -- '%F{3}--- stack trace (most recent call first) ---%f'
    print -lr -- $funcfiletrace
    print -Pr -- '%F{3}--- end of stack trace ---%f'
    print -Pr -- ''
    print -Pr -- 'Press %BENTER%b to continue.'
    hide_cursor
    read -s
  fi
  restore_screen
  print
  if (( force )); then
    flowing Powerlevel10k configuration wizard has been aborted. To run it again, type:
    print -P ""
    print -P "  %2Fp10k%f %Bconfigure%b"
    print -P ""
  else
    flowing                                                                        \
      Powerlevel10k configuration wizard has been aborted. It will run again       \
      next time unless you define at least one Powerlevel10k configuration option. \
      To define an option that does nothing except for disabling Powerlevel10k     \
      configuration wizard, type the following command:
    print -P ""
    print -P "  %2Fecho%f %3F'POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true'%f >>! $__p9k_zshrc_u"
    print -P ""
    flowing To run Powerlevel10k configuration wizard right now, type:
    print -P ""
    print -P "  %2Fp10k%f %Bconfigure%b"
    print -P ""
  fi
  function quit() {}
  stty echo 2>/dev/null
  show_cursor
  exit 1
}

local screen_widgets=()
local -i max_priority
local -i prompt_idx
local choice

function add_widget() {
  local priority=$1
  shift
  local render="${(j: :)${(@q)*}}"
  screen_widgets+=("$priority" "$render")
  (( priority <= max_priority )) || max_priority=priority
}

function render_screen_pass() {
  local -i pass=$1
  local -i prev_pass cur_pass
  local prev_render cur_render
  for cur_pass cur_render in "${(@)screen_widgets}" 0 ''; do
    if (( prev_pass <= pass && (cur_pass == 0 || cur_pass > pass) )); then
      eval $prev_render
    fi
    prev_pass=cur_pass
    prev_render=$cur_render
  done
}

function get_columns() { return 'COLUMNS > 88 ? 88 : COLUMNS' }
functions -M get_columns 0 0

function render_screen() {
  {
    hide_cursor
    while true; do
      while true; do
        typeset -gi wizard_columns='get_columns()'
        typeset -gi wizard_lines=LINES
        if (( wizard_columns < __p9k_wizard_columns )); then
          clear
          flowing -c %1FNot enough horizontal space.%f
          print
          flowing Make terminal window %Bwider%b or press %BCtrl-C%b to abort Powerlevel10k configuration wizard.
        elif (( wizard_lines < __p9k_wizard_lines )); then
          clear
          flowing -c %1FNot enough vertical space.%f
          print
          flowing Make terminal window %Btaller%b or press %BCtrl-C%b to abort Powerlevel10k configuration wizard.
        else
          break
        fi
        while (( get_columns() == wizard_columns && LINES == wizard_lines )); do
          sleep 1
        done
      done

      local -a passes
      () {
        local -i pass
        local render
        for pass render in "${(@)screen_widgets}"; do
          passes+=$pass
        done
        passes=(${(onu)passes})
      }

      local -i pass
      for pass in $passes; do
        local content="$(render_screen_pass $pass)"
        local lines=("${(@f)content}")
        (( $#lines > wizard_lines )) && continue
        clear
        print -rn -- $content
        return 0
      done

      clear
      flowing -c %1FNot enough vertical space.%f
      print
      flowing Make terminal window %Btaller%b or press %BCtrl-C%b to abort Powerlevel10k configuration wizard.
      while (( get_columns() == wizard_columns && LINES == wizard_lines )); do
        sleep 1
      done
    done
  } always {
    show_cursor
  }
}

function add_prompt_n() {
  add_widget 0 "$@" print_prompt
  local var
  for var; do
    eval "local ${(q)var}"
  done
  if (( num_lines == 2 )); then
    add_widget $(( 100 - ++prompt_idx )) print -P '  [%3Fnot enough vertical space to display this%f]'
  fi
}

function add_prompt() {
  add_widget 0 print
  add_widget 1
  add_prompt_n "$@"
  add_widget 0 print
  add_widget 2
}

function ask() {
  local choices=$1
  local -i lines columns wizard_lines wizard_columns
  add_widget 0 print -P "(q)  Quit and do nothing."
  add_widget 0 print
  add_widget $((max_priority + 1))
  add_widget 0 print -P "%BChoice [${choices}q]: %b"
  while true; do
    =true
    if (( LINES != lines || get_columns() != columns )); then
      render_screen
      lines=wizard_lines
      columns=wizard_columns
    fi
    typeset -g choice=
    if read -t1 -k choice; then
      choice=${(L)choice}
      if [[ $choice == q ]]; then
        quit
      fi
      if [[ $choices == *$choice* ]]; then
        screen_widgets=()
        max_priority=0
        prompt_idx=0
        return
      fi
    fi
  done
}

local -i greeting_printed=0

function print_greeting() {
  (( greeting_printed )) && return
  if (( in_z4h_wizard )); then
    flowing -c %3FZsh for Humans%f uses %4FPowerlevel10k%f to print command        \
               line prompt. This wizard will ask you a few questions and configure \
               prompt for you.
  elif (( force )); then
    flowing -c This is %4FPowerlevel10k configuration wizard%f. \
               It will ask you a few questions and configure your prompt.
  else
    flowing -c This is %4FPowerlevel10k configuration wizard%f.   \
               You are seeing it because you haven\'t defined any \
               Powerlevel10k configuration options. It will ask   \
               you a few questions and configure your prompt.
  fi
  print -P ""
}

function iterm_get() {
  /usr/libexec/PlistBuddy -c "Print :$1" ~/Library/Preferences/com.googlecode.iterm2.plist
}

local terminal iterm2_font_size iterm2_old_font=0 can_install_font=0

() {
  [[ $P9K_SSH == 0 ]] || return
  if [[ "$(uname)" == Linux && "$(uname -o)" == Android ]]; then
    (( $+commands[termux-reload-settings] )) || return
    (( $+commands[curl] )) || return
    if [[ -f ~/.termux/font.ttf ]]; then
      [[ -r ~/.termux/font.ttf ]] || return
      [[ -w ~/.termux/font.ttf ]] || return
      ! grep -q 'MesloLGS NF' ~/.termux/font.ttf 2>/dev/null || return
    fi
    if [[ -f ~/.termux ]]; then
      [[ -d ~/.termux && -w ~/.termux ]] || return
    else
      [[ -w ~ ]] || return
    fi
    terminal=Termux
    return 0
  fi
  if [[ "$(uname)" == Darwin && $TERM_PROGRAM == iTerm.app ]]; then
    (( $+commands[curl] )) || return
    [[ $TERM_PROGRAM_VERSION == [2-9]* ]] || return
    if [[ -f ~/Library/Fonts ]]; then
      [[ -d ~/Library/Fonts && -w ~/Library/Fonts ]] || return
    else
      [[ -d ~/Library && -w ~/Library ]] || return
    fi
    [[ -x /usr/libexec/PlistBuddy ]] || return
    [[ -x /usr/bin/plutil ]] || return
    [[ -x /usr/bin/defaults ]] || return
    [[ -f ~/Library/Preferences/com.googlecode.iterm2.plist ]] || return
    [[ -r ~/Library/Preferences/com.googlecode.iterm2.plist ]] || return
    [[ -w ~/Library/Preferences/com.googlecode.iterm2.plist ]] || return
    local guid1 && guid1="$(iterm_get '"Default Bookmark Guid"' 2>/dev/null)" || return
    local guid2 && guid2="$(iterm_get '"New Bookmarks":0:"Guid"' 2>/dev/null)" || return
    local font && font="$(iterm_get '"New Bookmarks":0:"Normal Font"' 2>/dev/null)" || return
    [[ $guid1 == $guid2 ]] || return
    [[ $font != 'MesloLGS-NF-Regular '<-> ]] || return
    [[ $font == (#b)*' '(<->) ]] || return
    [[ $font == 'MesloLGSNer-Regular '<-> ]] && iterm2_old_font=1
    iterm2_font_size=$match[1]
    terminal=iTerm2
    return 0
  fi
  return 1
} && can_install_font=1

function run_command() {
  local msg=$1
  shift
  [[ -n $msg ]] && print -nP -- "$msg ..."
  local err && err="$("$@" 2>&1)" || {
    print -P " %1FERROR%f"
    print -P ""
    print -nP "%BCommand:%b "
    print -r -- "${(@q)*}"
    if [[ -n $err ]]; then
      print -P ""
      print -r -- $err
    fi
    quit -c
  }
  [[ -n $msg ]] && print -P " %2FOK%f"
}

function install_font() {
  clear
  case $terminal in
    Termux)
      command mkdir -p -- ~/.termux || quit -c
      run_command "Downloading %BMesloLGS NF Regular.ttf%b" \
        curl -fsSL -o ~/.termux/font.ttf "$font_base_url/MesloLGS%20NF%20Regular.ttf"
      run_command "Reloading %BTermux%b settings" termux-reload-settings
    ;;
    iTerm2)
      command mkdir -p -- ~/Library/Fonts || quit -c
      local style
      for style in Regular Bold Italic 'Bold Italic'; do
        local file="MesloLGS NF ${style}.ttf"
        run_command "Downloading %B$file%b" \
          curl -fsSL -o ~/Library/Fonts/$file.tmp "$font_base_url/${file// /%20}"
        command mv -f -- ~/Library/Fonts/$file{.tmp,} || quit -c
      done
      print -nP -- "Changing %BiTerm2%b settings ..."
      local size=$iterm2_font_size
      [[ $size == 12 ]] && size=13
      local k t v settings=(
        '"Normal Font"'                                 string '"MesloLGS-NF-Regular '$size'"'
        '"Terminal Type"'                               string '"xterm-256color"'
        '"Horizontal Spacing"'                          real   1
        '"Vertical Spacing"'                            real   1
        '"Minimum Contrast"'                            real   0
        '"Use Bold Font"'                               bool   1
        '"Use Bright Bold"'                             bool   1
        '"Use Italic Font"'                             bool   1
        '"ASCII Anti Aliased"'                          bool   1
        '"Non-ASCII Anti Aliased"'                      bool   1
        '"Use Non-ASCII Font"'                          bool   0
        '"Ambiguous Double Width"'                      bool   0
        '"Draw Powerline Glyphs"'                       bool   1
        '"Only The Default BG Color Uses Transparency"' bool   1
      )
      for k t v in $settings; do
        /usr/libexec/PlistBuddy -c "Set :\"New Bookmarks\":0:$k $v" \
          ~/Library/Preferences/com.googlecode.iterm2.plist 2>/dev/null && continue
        run_command "" /usr/libexec/PlistBuddy -c \
          "Add :\"New Bookmarks\":0:$k $t $v" ~/Library/Preferences/com.googlecode.iterm2.plist
      done
      print -P " %2FOK%f"
      print -nP "Updating %BiTerm2%b settings cache ..."
      run_command "" /usr/bin/defaults read com.googlecode.iterm2
      sleep 3
      print -P " %2FOK%f"
      sleep 1
      clear
      hide_cursor
      print
      flowing +c "%2FMeslo Nerd Font%f" successfully installed.
      print -P ""
      () {
        local out
        out=$(/usr/bin/defaults read 'Apple Global Domain' NSQuitAlwaysKeepsWindows 2>/dev/null) || return
        [[ $out == 1 ]] || return
        out="$(iterm_get OpenNoWindowsAtStartup 2>/dev/null)" || return
        [[ $out == false ]]
      }
      if (( $? )); then
        flowing +c Please "%Brestart iTerm2%b" for the changes to take effect.
        print -P ""
        flowing +c -i 5 "  1. Click" "%BiTerm2 → Quit iTerm2%b" or press "%B⌘ Q%b."
        flowing +c -i 5 "  2. Open %BiTerm2%b."
        print -P ""
        flowing +c "It's" important to "%Brestart iTerm2%b" by following the instructions above.   \
                   "It's" "%Bnot enough%b" to close iTerm2 by clicking on the red circle. You must \
                   click "%BiTerm2 → Quit iTerm2%b" or press "%B⌘ Q%b."
      else
        flowing +c Please "%Brestart your computer%b" for the changes to take effect.
      fi
      while true; do sleep 60 2>/dev/null; done
    ;;
  esac

  return 0
}

function ask_font() {
  (( can_install_font )) || return 0
  add_widget 0 print_greeting
  if (( iterm2_old_font )); then
    add_widget 0 flowing -c A new version of '%2FMeslo Nerd Font%f' is available. '%BInstall?%b'
  else
    add_widget 0 flowing -c %BInstall '%b%2FMeslo Nerd Font%f%B?%b'
  fi
  add_widget 0 print
  add_widget 0 print -P "%B(y)  Yes (recommended).%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(n)  No. Use the current font.%b"
  add_widget 0 print
  add_widget 1
  ask yn
  greeting_printed=1
  case $choice in
    y)
      ask_remove_font || return
      install_font
    ;;
    n) ;;
  esac
  return 0
}

function print_file_path() {
  local file=$1
  if (( ${(m)#file} > wizard_columns - 2 )); then
    file[wizard_columns-4,-1]='...'
  fi
  add_widget 0 print -P "  %B${file//\%/%%}%b"
}

function ask_remove_font() {
  local font
  local -a fonts
  local -i protected
  for font in {,/System,~}/Library/Fonts/**/*[Mm]eslo*.(ttf|otf)(N:A); do
    [[ -f $font && -r $font ]] || continue
    [[ $font == ~/Library/Fonts/'MesloLGS NF '(Regular|Bold|Italic|Bold\ Italic).ttf ]] && continue
    [[ "$(<$font)" == *"MesloLGS NF"$'\0'* ]] || continue
    fonts+=$font
    [[ -w ${font:h} ]] || protected=1
  done
  (( $#fonts )) || return 0
  add_widget 0 flowing -c A variant of "%2FMeslo Nerd Font%f" is already installed.
  add_widget 0 print -P ""
  for font in $fonts; do
    add_widget 0 print_file_path $font
  done
  add_widget 0 print -P ""
  if (( protected )); then
    if (( $#fonts == 1 )); then
      add_widget 0 flowing Please %Bdelete%b this file and run '%2Fp10k%f %Bconfigure%b.'
    else
      add_widget 0 flowing Please %Bdelete%b these files and run '%2Fp10k%f %Bconfigure%b.'
    fi
    add_widget 0 print
    restore_screen
    local pass render
    for pass render in "${(@)screen_widgets}"; do
      (( pass == 0 )) && eval $render
    done
    exit 1
  fi
  if (( $#fonts == 1 )); then
    add_widget 0 flowing -c "%BDelete this file?%b"
  else
    add_widget 0 flowing -c "%BDelete these files?%b"
  fi
  add_widget 0 print -P ""
  add_widget 0 print -P "%B(y)  Yes (recommended).%b"
  add_widget 0 print -P ""
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask yr
  case $choice in
    r) return 1;;
    y) zf_rm -f -- $fonts || quit -c;;
  esac
  return 0
}

function ask_diamond() {
  local extra
  add_widget 0 print_greeting
  add_widget 0 flowing -c %BDoes this look like a%b %2Fdiamond%f '%B(rotated square)?%b'
  add_widget 0 flowing -c reference: "$(href https://graphemica.com/%E2%97%86)"
  add_widget 0 print
  add_widget 0 flowing -c -- "--->  \uE0B2\uE0B0  <---"
  add_widget 0 print
  add_widget 3
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print
  add_widget 2
  if (( can_install_font )); then
    extra+=r
    add_widget 0 print -P "(r)  Restart from the beginning."
  fi
  ask yn$extra
  greeting_printed=1
  case $choice in
    r) return 1;;
    y) cap_diamond=1;;
    n) cap_diamond=0;;
  esac
  return 0
}

function ask_lock() {
  [[ -n $2 ]] && add_widget 0 flowing -c "$2"
  add_widget 0 flowing -c "%BDoes this look like a %b%2Flock%f%B?%b"
  add_widget 0 flowing -c "reference: $(href https://fontawesome.com/icons/lock)"
  add_widget 0 print
  add_widget 0 flowing -c -- "--->  $1  <---"
  add_widget 0 print
  add_widget 3
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y) cap_lock=1;;
    n) cap_lock=0;;
  esac
  return 0
}

function ask_python() {
  add_widget 0 flowing -c %BDoes this look like a "%b%2FPython logo%f%B?%b"
  add_widget 0 flowing -c reference: "$(href https://fontawesome.com/icons/python)"
  add_widget 0 print -P ""
  add_widget 0 flowing -c -- "--->  \uE63C  <---"
  add_widget 0 print -P ""
  add_widget 3
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print -P ""
  add_widget 1
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print -P ""
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y) cap_python=1;;
    n) cap_python=0;;
  esac
  return 0
}

function ask_arrow() {
  add_widget 0 flowing -c %BDoes this look like%b "%2F><%f" %Bbut taller and "fatter?%b"
  add_widget 0 print -P ""
  add_widget 0 flowing -c -- "--->  \u276F\u276E  <---"
  add_widget 0 print -P ""
  add_widget 3
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print -P ""
  add_widget 1
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print -P ""
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y) cap_arrow=1;;
    n) cap_arrow=0;;
  esac
  return 0
}

function ask_debian() {
  add_widget 0 flowing -c %BDoes this look like a%b "%2FDebian logo%f" "%B(swirl/spiral)?%b"
  add_widget 0 flowing -c reference: "$(href https://debian.org/logos/openlogo-nd.svg)"
  add_widget 0 print -P ""
  add_widget 0 flowing -c -- "--->  \uF306  <---"
  add_widget 0 print -P ""
  add_widget 3
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print -P ""
  add_widget 1
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print -P ""
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y) cap_debian=1;;
    n) cap_debian=0;;
  esac
  return 0
}

function ask_icon_padding() {
  if [[ $POWERLEVEL9K_MODE == (powerline|compatible|ascii) ]]; then
    POWERLEVEL9K_ICON_PADDING=none
    return 0
  fi

  local text="X"
  text+="%1F${icons[VCS_GIT_ICON]// }%fX"
  text+="%2F${icons[VCS_GIT_GITHUB_ICON]// }%fX"
  text+="%3F${icons[TIME_ICON]// }%fX"
  text+="%4F${icons[RUBY_ICON]// }%fX"
  text+="%5F${icons[HOME_ICON]// }%fX"
  text+="%6F${icons[HOME_SUB_ICON]// }%fX"
  text+="%1F${icons[FOLDER_ICON]// }%fX"
  text+="%2F${icons[RAM_ICON]// }%fX"

  add_widget 0 flowing -c %BDo all these icons "%b%2Ffit between the crosses%f%B?%b"
  add_widget 0 print -P ""
  add_widget 0 flowing -c -- "--->  $text  <---"
  add_widget 0 print -P ""
  add_widget 3
  add_widget 0 flowing +c -i 5 "%B(y)  Yes." Icons are very close to the crosses but there is "%b%2Fno overlap%f%B.%b"
  add_widget 0 print -P ""
  add_widget 1
  add_widget 0 flowing +c -i 5 "%B(n)  No." Some icons "%b%2Foverlap%f%B" neighbouring crosses.%b
  add_widget 0 print -P ""
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y)
      POWERLEVEL9K_ICON_PADDING=none
      options+='small icons'
    ;;
    n)
      POWERLEVEL9K_ICON_PADDING=moderate
      options+='large icons'
      up_triangle+=' '
      down_triangle+=' '
      slanted_bar='\uE0BD '
    ;;
  esac
  return 0
}

function ask_style() {
  if (( terminfo[colors] < 256 )); then
    style=lean_8colors
    left_frame=0
    right_frame=0
    frame_color=(0 7 2 4)
    color_name=(Black White Green Blue)
    options+=lean_8colors
    return 0
  fi
  local extra
  add_widget 0 flowing -c "%BPrompt Style%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Lean.%b"
  add_prompt style=lean left_frame=0 right_frame=0
  add_widget 0 print -P "%B(2)  Classic.%b"
  add_prompt style=classic
  add_widget 0 print -P "%B(3)  Rainbow.%b"
  add_prompt style=rainbow
  if [[ $POWERLEVEL9K_MODE != ascii ]]; then
    extra+=4
    add_widget 0 print -P "%B(4)  Pure.%b"
    add_prompt style=pure
  fi
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 123${extra}r
  case $choice in
    r) return 1;;
    1) style=lean; left_frame=0; right_frame=0; options+=lean;;
    2) style=classic; options+=classic;;
    3) style=rainbow; options+=rainbow;;
    4) style=pure; empty_line=1; options+=pure;;
  esac
  return 0
}

function ask_charset() {
  [[ $style == (lean*|classic|rainbow) && $POWERLEVEL9K_MODE != ascii ]] || return 0
  add_widget 0 flowing -c "%BCharacter Set%b"
  add_widget 0 print -P ""
  add_widget 1
  add_widget 0 print -P "%B(1)  Unicode.%b"
  add_prompt
  add_widget 0 print -P "%B(2)  ASCII.%b"
  add_prompt         \
    left_sep=        \
    right_sep=       \
    left_subsep='|'  \
    right_subsep='|' \
    left_head=       \
    right_head=      \
    prompt_char='>'  \
    left_frame=0     \
    right_frame=0
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) options+=unicode;;
    2)
      options+=ascii
      left_sep=
      right_sep=
      left_subsep='|'
      right_subsep='|'
      left_head=
      right_head=
      prompt_char='>'
      left_frame=0
      right_frame=0
      POWERLEVEL9K_MODE=ascii
      POWERLEVEL9K_ICON_PADDING=none
      cap_diamond=0
      cap_python=0
      cap_debian=0
      cap_lock=0
      cap_arrow=0
    ;;
  esac
  return 0
}

function ask_color_scheme() {
  (( terminfo[colors] < 256 )) && return
  if [[ $style == lean ]]; then
    add_widget 0 flowing -c "%BPrompt Colors%b"
    add_widget 0 print -P ""
    add_widget 1
    add_widget 0 print -P "%B(1)  256 colors.%b"
    add_prompt style=lean
    add_widget 0 print -P "%B(2)  8 colors.%b"
    add_prompt style=lean_8colors
    add_widget 0 print -P "(r)  Restart from the beginning."
    ask 12r
    case $choice in
      r) return 1;;
      1) style=lean;;
      2)
        style=lean_8colors
        frame_color=(0 7 2 4)
        color_name=(Black White Green Blue)
      ;;
    esac
    options=(${options:#lean} $style)
  elif [[ $style == pure && $has_truecolor == 1 ]]; then
    add_widget 0 flowing -c "%BPrompt Colors%b"
    add_widget 0 print -P ""
    add_widget 1
    add_widget 0 print -P "%B(1)  Original.%b"
    add_prompt "pure_color=(${(j: :)${(@q)${(@kv)pure_original}}})"
    add_widget 0 print -P "%B(2)  Snazzy.%b"
    add_prompt "pure_color=(${(j: :)${(@q)${(@kv)pure_snazzy}}})"
    add_widget 0 print -P "(r)  Restart from the beginning."
    ask 12r
    case $choice in
      r) return 1;;
      1)
        pure_color=(${(kv)pure_original})
        options+=original
      ;;
      2)
        pure_color=(${(kv)pure_snazzy})
        options+=snazzy
      ;;
    esac
  fi
  return 0
}

function ask_color() {
  [[ $style != classic ]] && return
  add_widget 0 flowing -c "%BPrompt Color%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  $color_name[1].%b"
  add_prompt color=1
  add_widget 0 print -P "%B(2)  $color_name[2].%b"
  add_prompt color=2
  add_widget 0 print -P "%B(3)  $color_name[3].%b"
  add_prompt color=3
  add_widget 0 print -P "%B(4)  $color_name[4].%b"
  add_prompt color=4
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 1234r
  case $choice in
    r) return 1;;
    [1-4]) color=$choice;;
  esac
  options+=${${(L)color_name[color]}//ı/i}
  return 0
}

function ask_ornaments_color() {
  [[ $style != (rainbow|lean*) || $num_lines == 1 ]] && return
  [[ $gap_char == ' ' && $left_frame == 0 && $right_frame == 0 ]] && return
  local ornaments=()
  [[ $gap_char != ' ' ]]          && ornaments+=Connection
  (( left_frame || right_frame )) && ornaments+=Frame
  add_widget 0 flowing -c "%B${(j: & :)ornaments} Color%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  $color_name[1].%b"
  add_prompt color=1
  add_widget 0 print -P "%B(2)  $color_name[2].%b"
  add_prompt color=2
  add_widget 0 print -P "%B(3)  $color_name[3].%b"
  add_prompt color=3
  add_widget 0 print -P "%B(4)  $color_name[4].%b"
  add_prompt color=4
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 1234r
  case $choice in
    r) return 1;;
    [1-4]) color=$choice;;
  esac
  options+=${${(L)color_name[color]}//ı/i}-ornaments
  return 0
}

function ask_time() {
  local extra
  add_widget 0 flowing -c "%BShow current time?%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  No.%b"
  add_prompt time=
  add_widget 0 print -P "%B(2)  24-hour format.%b"
  add_prompt time=$time_24h
  add_widget 0 print -P "%B(3)  12-hour format.%b"
  add_prompt time=$time_12h
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 123r
  case $choice in
    r) return 1;;
    1) time=;;
    2) time=$time_24h; options+='24h time';;
    3) time=$time_12h; options+='12h time';;
  esac
  return 0
}

function ask_use_rprompt() {
  [[ $style != pure ]] && return
  add_widget 0 flowing -c "%BNon-permanent content location%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Left.%b"
  add_prompt
  add_widget 0 print -P "%B(2)  Right.%b"
  add_prompt pure_use_rprompt=
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) ;;
    2) pure_use_rprompt=; options+=rprompt;;
  esac
  return 0
}

function os_icon_name() {
  local uname="$(uname)"
  if [[ $uname == Linux && "$(uname -o 2>/dev/null)" == Android ]]; then
    echo ANDROID_ICON
  else
    case $uname in
      SunOS)                     echo SUNOS_ICON;;
      Darwin)                    echo APPLE_ICON;;
      CYGWIN_NT-*|MSYS_NT-*|MINGW64_NT-*|MINGW32_NT-*)   echo WINDOWS_ICON;;
      FreeBSD|OpenBSD|DragonFly) echo FREEBSD_ICON;;
      Linux)
        local os_release_id
        if [[ -r /etc/os-release ]]; then
          local lines=(${(f)"$(</etc/os-release)"})
          lines=(${(@M)lines:#ID=*})
          (( $#lines == 1 )) && os_release_id=${lines[1]#ID=}
        elif [[ -e /etc/artix-release ]]; then
          os_release_id=artix
        fi
        case $os_release_id in
          *arch*)                  echo LINUX_ARCH_ICON;;
          *debian*)                echo LINUX_DEBIAN_ICON;;
          *raspbian*)              echo LINUX_RASPBIAN_ICON;;
          *ubuntu*)                echo LINUX_UBUNTU_ICON;;
          *elementary*)            echo LINUX_ELEMENTARY_ICON;;
          *fedora*)                echo LINUX_FEDORA_ICON;;
          *coreos*)                echo LINUX_COREOS_ICON;;
          *gentoo*)                echo LINUX_GENTOO_ICON;;
          *mageia*)                echo LINUX_MAGEIA_ICON;;
          *centos*)                echo LINUX_CENTOS_ICON;;
          *opensuse*|*tumbleweed*) echo LINUX_OPENSUSE_ICON;;
          *sabayon*)               echo LINUX_SABAYON_ICON;;
          *slackware*)             echo LINUX_SLACKWARE_ICON;;
          *linuxmint*)             echo LINUX_MINT_ICON;;
          *alpine*)                echo LINUX_ALPINE_ICON;;
          *aosc*)                  echo LINUX_AOSC_ICON;;
          *nixos*)                 echo LINUX_NIXOS_ICON;;
          *devuan*)                echo LINUX_DEVUAN_ICON;;
          *manjaro*)               echo LINUX_MANJARO_ICON;;
          *void*)                  echo LINUX_VOID_ICON;;
          *artix*)                 echo LINUX_ARTIX_ICON;;
          *rhel*)                  echo LINUX_RHEL_ICON;;
          amzn)                    echo LINUX_AMZN_ICON;;
          *)                       echo LINUX_ICON;;
        esac
        ;;
    esac
  fi
}

function ask_extra_icons() {
  if [[ $style == pure || $POWERLEVEL9K_MODE == (powerline|compatible|ascii) ]]; then
    return 0
  fi
  local os_icon=${(g::)icons[$(os_icon_name)]}
  local dir_icon=${(g::)icons[HOME_SUB_ICON]}
  local vcs_icon=${(g::)icons[VCS_GIT_GITHUB_ICON]}
  local branch_icon=${(g::)icons[VCS_BRANCH_ICON]}
  local duration_icon=${(g::)icons[EXECUTION_TIME_ICON]}
  local time_icon=${(g::)icons[TIME_ICON]}
  branch_icon=${branch_icon// }
  local few=('' '' '' '' '')
  local many=("$os_icon" "$dir_icon " "$vcs_icon $branch_icon " "$duration_icon " "$time_icon ")
  add_widget 0 flowing -c "%BIcons%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Few icons.%b"
  add_prompt "extra_icons=(${(j: :)${(@q)few}})"
  add_widget 0 print -P "%B(2)  Many icons.%b"
  add_prompt "extra_icons=(${(j: :)${(@q)many}})"
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) extra_icons=("$few[@]"); options+='few icons';;
    2) extra_icons=("$many[@]"); options+='many icons';;
  esac
  return 0
}

function ask_prefixes() {
  if [[ $style == pure ]]; then
    return 0
  fi
  local concise=('' '' '')
  local fluent=('on ' 'took ' 'at ')
  add_widget 0 flowing -c "%BPrompt Flow%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Concise.%b"
  add_prompt "prefixes=(${(j: :)${(@q)concise}})"
  add_widget 0 print -P "%B(2)  Fluent.%b"
  add_prompt "prefixes=(${(j: :)${(@q)fluent}})"
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) prefixes=("$concise[@]"); options+=concise;;
    2) prefixes=("$fluent[@]"); options+=fluent;;
  esac
  return 0
}

function ask_separators() {
  if [[ $style != (classic|rainbow) || $cap_diamond != 1 ]]; then
    return 0
  fi
  local extra
  add_widget 0 flowing -c "%BPrompt Separators%b"
  add_widget 0 print -Pl "              separator" "%B(1)  Angled.%b /" "            /"
  add_widget 3 print -P "%B(1)  Angled.%b"
  add_prompt_n left_sep=$right_triangle right_sep=$left_triangle left_subsep=$right_angle right_subsep=$left_angle
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "%B(2)  Vertical.%b"
  add_prompt left_sep='' right_sep='' left_subsep=$vertical_bar right_subsep=$vertical_bar
  if [[ $POWERLEVEL9K_MODE == nerdfont-complete ]]; then
    extra+=3
    add_widget 0 print -P "%B(3)  Slanted.%b"
    add_prompt left_sep=$down_triangle right_sep=$up_triangle left_subsep=$slanted_bar right_subsep=$slanted_bar
    extra+=4
    add_widget 0 print -P "%B(4)  Round.%b"
    add_prompt left_sep=$right_circle right_sep=$left_circle left_subsep=$right_arc right_subsep=$left_arc
  fi
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12${extra}r
  case $choice in
    r) return 1;;
    1)
      left_sep=$right_triangle
      right_sep=$left_triangle
      left_subsep=$right_angle
      right_subsep=$left_angle
      options+='angled separators'
    ;;
    2)
      left_sep=''
      right_sep=''
      left_subsep=$vertical_bar
      right_subsep=$vertical_bar
      options+='vertical separators'
    ;;
    3)
      left_sep=$down_triangle
      right_sep=$up_triangle
      left_subsep=$slanted_bar
      right_subsep=$slanted_bar
      options+='slanted separators'
    ;;
    4)
      left_sep=$right_circle
      right_sep=$left_circle
      left_subsep=$right_arc
      right_subsep=$left_arc
      options+='round separators'
    ;;
  esac
  return 0
}

function ask_heads() {
  if [[ $style != (classic|rainbow) || $POWERLEVEL9K_MODE == ascii ]]; then
    return 0
  fi
  local extra
  add_widget 0 flowing -c "%BPrompt Heads%b"
  if (( cap_diamond )); then
    add_widget 0 print -Pl "                   head" "%B(1)  Sharp.%b         |" "                    v"
    add_widget 3 print -P "%B(1)  Sharp.%b"
    add_prompt_n left_head=$right_triangle right_head=$left_triangle
    add_widget 0 print
    add_widget 2
  else
    add_widget 0 print
    add_widget 1
    add_widget 0 print -P "%B(1)  Flat.%b"
    add_prompt left_head= right_head=
  fi
  add_widget 0 print -P "%B(2)  Blurred.%b"
  add_prompt left_head=$fade_out right_head=$fade_in
  if [[ $POWERLEVEL9K_MODE == nerdfont-complete ]]; then
    extra+=3
    add_widget 0 print -P "%B(3)  Slanted.%b"
    add_prompt left_head=$down_triangle right_head=$up_triangle
    extra+=4
    add_widget 0 print -P "%B(4)  Round.%b"
    add_prompt left_head=$right_circle right_head=$left_circle
  fi
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12${extra}r
  case $choice in
    r) return 1;;
    1)
      if (( cap_diamond )); then
        left_head=$right_triangle
        right_head=$left_triangle
        options+='sharp heads'
      else
        left_head=
        right_head=
        options+='flat heads'
      fi
    ;;
    2)
      left_head=$fade_out
      right_head=$fade_in
      options+='blurred heads'
    ;;
    3)
      left_head=$down_triangle
      right_head=$up_triangle
      options+='slanted heads'
    ;;
    4)
      left_head=$right_circle
      right_head=$left_circle
      options+='round heads'
    ;;
  esac
  return 0
}

function print_tail_marker() {
  local label='(1)  Flat.'
  local -i n='wizard_columns - 7'
  local -i m=$((n - $#label))
  print -P "${(l:$n:: :)}tail"
  print -P "%B$label%b${(l:$m:: :)}  |"
  print -P "${(l:$n:: :)}  v"
}

function ask_tails() {
  if [[ $style != (classic|rainbow) || $POWERLEVEL9K_MODE == ascii ]]; then
    return 0
  fi
  local extra
  add_widget 0 flowing -c "%BPrompt Tails%b"
  add_widget 0 print_tail_marker
  add_widget 3 print -P "%B(1)  Flat.%b"
  add_prompt_n left_tail='' right_tail=''
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "%B(2)  Blurred.%b"
  add_prompt left_tail=$fade_in right_tail=$fade_out
  if (( cap_diamond )); then
    extra+=3
    add_widget 0 print -P "%B(3)  Sharp.%b"
    add_prompt left_tail=$left_triangle right_tail=$right_triangle
    if [[ $POWERLEVEL9K_MODE == nerdfont-complete ]]; then
      extra+=4
      add_widget 0 print -P "%B(4)  Slanted.%b"
      add_prompt left_tail=$up_triangle right_tail=$down_triangle
      extra+=5
      add_widget 0 print -P "%B(5)  Round.%b"
      add_prompt left_tail=$left_circle right_tail=$right_circle
    fi
  fi
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12${extra}r
  case $choice in
    r) return 1;;
    1) left_tail='';       right_tail='';        options+='flat tails';;
    2) left_tail=$fade_in; right_tail=$fade_out; options+='blurred tails';;
    3)
      left_tail=$left_triangle
      right_tail=$right_triangle
      options+='sharp tails'
    ;;
    4)
      left_tail=$up_triangle
      right_tail=$down_triangle
      options+='slanted tails'
    ;;
    5)
      left_tail=$left_circle
      right_tail=$right_circle
      options+='round tails'
    ;;
  esac
  return 0
}

function ask_num_lines() {
  add_widget 0 flowing -c "%BPrompt Height%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  One line.%b"
  add_prompt num_lines=1
  add_widget 0 print -P "%B(2)  Two lines.%b"
  add_prompt num_lines=2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) num_lines=1; options+='1 line';;
    2) num_lines=2; options+='2 lines';;
  esac
  return 0
}

function ask_gap_char() {
  [[ $num_lines != 2 || $style == pure ]] && return
  if [[ $POWERLEVEL9K_MODE == ascii ]]; then
    local dot='.'
    local dash='-'
  else
    local dot='·'
    local dash='─'
  fi
  add_widget 0 flowing -c "%BPrompt Connection%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Disconnected.%b"
  add_prompt gap_char=" "
  add_widget 0 print -P "%B(2)  Dotted.%b"
  add_prompt gap_char=$dot
  add_widget 0 print -P "%B(3)  Solid.%b"
  add_prompt gap_char=$dash
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 123r
  case $choice in
    r) return 1;;
    1) gap_char=" "; options+=disconnected;;
    2) gap_char=$dot; options+=dotted;;
    3) gap_char=$dash; options+=solid;;
  esac
  return 0
}

function ask_frame() {
  if [[ $style != (classic|rainbow|lean*) || $num_lines != 2 || $POWERLEVEL9K_MODE == ascii ]]; then
    return 0
  fi
  add_widget 0 flowing -c "%BPrompt Frame%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  No frame.%b"
  add_prompt left_frame=0 right_frame=0
  add_widget 0 print -P "%B(2)  Left.%b"
  add_prompt left_frame=1 right_frame=0
  add_widget 0 print -P "%B(3)  Right.%b"
  add_prompt left_frame=0 right_frame=1
  add_widget 0 print -P "%B(4)  Full.%b"
  add_prompt left_frame=1 right_frame=1
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 1234r
  case $choice in
    r) return 1;;
    1) left_frame=0; right_frame=0; options+='no frame';;
    2) left_frame=1; right_frame=0; options+='left frame';;
    3) left_frame=0; right_frame=1; options+='right frame';;
    4) left_frame=1; right_frame=1; options+='full frame';;
  esac
  return 0
}

function ask_empty_line() {
  add_widget 0 flowing -c "%BPrompt Spacing%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(1)  Compact.%b"
  add_widget 0 print
  add_widget 1
  add_prompt_n
  add_prompt_n
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "%B(2)  Sparse.%b"
  add_widget 0 print
  add_widget 1
  add_prompt_n
  add_widget 0 print
  add_prompt_n
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 12r
  case $choice in
    r) return 1;;
    1) empty_line=0; options+='compact';;
    2) empty_line=1; options+='sparse';;
  esac
  return 0
}

function print_instant_prompt_link() {
  local link='https://github.com/romkatv/powerlevel10k/blob/master/README.md#instant-prompt'
  (( wizard_columns < $#link )) && return
  print
  flowing -c "$(href $link)"
}

function ask_instant_prompt() {
  if ! is-at-least 5.4; then
    instant_prompt=off
    options+=instant_prompt=auto-off
    return 0
  fi
  if (( $+functions[z4h] )); then
    instant_prompt=quiet
    options+=instant_prompt=auto-quiet
    return
  fi
  add_widget 0 flowing -c "%BInstant Prompt Mode%b"
  add_widget 0 print_instant_prompt_link
  add_widget 1
  add_widget 0 print
  add_widget 2
  add_widget 0 flowing +c -i 5 "%B(1)  Verbose (recommended).%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 flowing +c -i 5 "%B(2)  Quiet.%b" Choose this if you\'ve read and understood \
    instant prompt documentation.
  add_widget 0 print
  add_widget 1
  add_widget 0 flowing +c -i 5 "%B(3)  Off.%b" Choose this if you\'ve tried instant prompt \
    and found it incompatible with your zsh configuration files.
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask 123r
  case $choice in
    r) return 1;;
    1) instant_prompt=verbose; options+=instant_prompt=verbose;;
    2) instant_prompt=quiet; options+=instant_prompt=quiet;;
    3) instant_prompt=off; options+=instant_prompt=off;;
  esac
  return 0
}

function ask_transient_prompt() {
  local disable_rprompt=$((num_lines == 1))
  local p=76
  [[ $style == pure ]] && p=$pure_color[magenta]
  [[ $style == lean_8colors ]] && p=2
  p="%F{$p}$prompt_char%f"
  add_widget 0 flowing -c "%BEnable Transient Prompt?%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 print -P "${(pl:$prompt_indent:: :)}$p %2Fgit%f pull"
  add_widget 3
  add_widget 0 print -P "${(pl:$prompt_indent:: :)}$p %2Fgit%f branch x"
  (( empty_line )) && add_widget 0 print
  add_prompt_n buffer="%2Fgit%f checkout x$cursor"
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "%B(n)  No.%b"
  add_widget 0 print
  add_widget 1
  add_widget 0 buffer="%2Fgit%f pull" print_prompt
  add_widget 3
  (( empty_line )) && { add_widget 0 print; add_widget 3 }
  add_prompt_n buffer="%2Fgit%f branch x"
  (( empty_line )) && add_widget 0 print
  add_prompt_n buffer="%2Fgit%f checkout x$cursor"
  add_widget 0 print
  add_widget 2
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ynr
  case $choice in
    r) return 1;;
    y) transient_prompt=1; options+=transient_prompt;;
    n) transient_prompt=0;;
  esac
  return 0
}

function ask_config_overwrite() {
  config_backup=
  config_backup_u=0
  if [[ ! -e $__p9k_cfg_path ]]; then
    return 0
  fi
  add_widget 0 flowing -c Powerlevel10k config file already exists.
  add_widget 0 flowing -c "%BOverwrite" "%b%2F${__p9k_cfg_path_u//\\/\\\\}%f%B?%b"
  add_widget 0 print -P ""
  add_widget 0 print -P "%B(y)  Yes.%b"
  add_widget 0 print -P ""
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask yr
  case $choice in
    r) return 1;;
    y)
      if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
        local tmpdir=$TMPDIR
        local tmpdir_u='$TMPDIR'
      else
        local tmpdir=/tmp
        local tmpdir_u=/tmp
      fi
      config_backup="$(mktemp $tmpdir/$__p9k_cfg_basename.XXXXXXXXXX)" || quit -c
      cp $__p9k_cfg_path $config_backup                                        || quit -c
      config_backup_u=$tmpdir_u/${(q-)config_backup:t}
    ;;
  esac
  return 0
}

function ask_zshrc_edit() {
  zshrc_content=
  zshrc_backup=
  zshrc_backup_u=
  zshrc_has_cfg=0
  zshrc_has_instant_prompt=0
  write_zshrc=0

  if (( $+functions[z4h] )); then
    zshrc_has_cfg=1
    zshrc_has_instant_prompt=1
    return
  fi

  check_zshrc_integration || quit -c
  [[ $instant_prompt == off ]] && zshrc_has_instant_prompt=1
  (( zshrc_has_cfg && zshrc_has_instant_prompt )) && return

  add_widget 0 flowing -c %BApply changes to "%b%2F${__p9k_zshrc_u//\\/\\\\}%f%B?%b"
  add_widget 0 print -P ""
  add_widget 1
  local modifiable=y
  if [[ ! -w $__p9k_zd ]]; then
    modifiable=
    add_widget 0 flowing -c %3FWARNING:%f %2F${__p9k_zd_u//\\/\\\\}%f %3Fis readonly.%f
    add_widget 0 print -P ""
  elif [[ -e $__p9k_zshrc && ! -w $__p9k_zshrc ]]; then
    local -a stat
    zstat -A stat +uid -- $__p9k_zshrc || quit -c
    if (( stat[1] == EUID )); then
      add_widget 0 flowing -c %3FNOTE:%f %2F${__p9k_zshrc_u//\\/\\\\}%f %3Fis readonly.%f
    else
      modifiable=
      add_widget 0 flowing -c                                           \
        %3FWARNING:%f %2F${__p9k_zshrc_u//\\/\\\\}%f %3Fis readonly and \
        not owned by the user. Cannot modify it.%f
    fi
    add_widget 0 print -P ""
  fi
  if [[ $modifiable == y ]]; then
    add_widget 0 print -P "%B(y)  Yes (recommended).%b"
  else
    add_widget 0 print -P "%1F(y)  Yes (disabled).%f"
  fi
  add_widget 0 print -P ""
  add_widget 0 flowing +c -i 5 "%B(n)  No." I know which changes to apply and will do it myself.%b
  add_widget 0 print -P ""
  add_widget 0 print -P "(r)  Restart from the beginning."
  ask ${modifiable}nr
  case $choice in
    r) return 1;;
    n) return 0;;
    y)
      write_zshrc=1
      if [[ -n $zshrc_content ]]; then
        if [[ -n "$TMPDIR" && ( ( -d "$TMPDIR" && -w "$TMPDIR" ) || ! ( -d /tmp && -w /tmp ) ) ]]; then
          local tmpdir=$TMPDIR
          local tmpdir_u='$TMPDIR'
        else
          local tmpdir=/tmp
          local tmpdir_u=/tmp
        fi
        zshrc_backup="$(mktemp $tmpdir/.zshrc.XXXXXXXXXX)" || quit -c
        cp -p $__p9k_zshrc $zshrc_backup                   || quit -c
        local -i writable=1
        if [[ ! -w $zshrc_backup ]]; then
          chmod u+w -- $zshrc_backup                       || quit -c
          writable=0
        fi
        print -r -- $zshrc_content >$zshrc_backup          || quit -c
        (( writable )) || chmod u-w -- $zshrc_backup       || quit -c
        zshrc_backup_u=$tmpdir_u/${(q-)zshrc_backup:t}
      fi
    ;;
  esac
  return 0
}

function generate_config() {
  local base && base="$(<$__p9k_root_dir/config/p10k-${style//_/-}.zsh)" || return
  local lines=("${(@f)base}")

  function sub() {
    lines=("${(@)lines/#(#b)([[:space:]]#)typeset -g POWERLEVEL9K_$1=*/$match[1]typeset -g POWERLEVEL9K_$1=$2}")
  }

  function uncomment() {
    lines=("${(@)lines/#(#b)([[:space:]]#)\# $1(  |)/$match[1]$1$match[2]$match[2]}")
  }

  function rep() {
    lines=("${(@)lines//$1/$2}")
  }

  if [[ $style == pure ]]; then
    rep "local grey=242" "local grey='$pure_color[grey]'"
    rep "local red=1" "local red='$pure_color[red]'"
    rep "local yellow=3" "local yellow='$pure_color[yellow]'"
    rep "local blue=4" "local blue='$pure_color[blue]'"
    rep "local magenta=5" "local magenta='$pure_color[magenta]'"
    rep "local cyan=6" "local cyan='$pure_color[cyan]'"
    rep "local white=7" "local white='$pure_color[white]'"
  else
    sub MODE $POWERLEVEL9K_MODE

    sub ICON_PADDING $POWERLEVEL9K_ICON_PADDING

    if [[ $POWERLEVEL9K_MODE == compatible ]]; then
      sub STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION "'х'"
      sub STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION "'х'"
      sub STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION "'х'"
    fi

    if [[ $POWERLEVEL9K_MODE == (compatible|powerline) ]]; then
      uncomment 'typeset -g POWERLEVEL9K_LOCK_ICON'
      sub LOCK_ICON "'∅'"
      uncomment 'typeset -g POWERLEVEL9K_NORDVPN_VISUAL_IDENTIFIER_EXPANSION'
      sub NORDVPN_VISUAL_IDENTIFIER_EXPANSION "'nord'"
      uncomment 'typeset -g POWERLEVEL9K_RANGER_VISUAL_IDENTIFIER_EXPANSION'
      sub RANGER_VISUAL_IDENTIFIER_EXPANSION "'▲'"
      uncomment 'typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_VISUAL_IDENTIFIER_EXPANSION'
      sub KUBECONTEXT_DEFAULT_VISUAL_IDENTIFIER_EXPANSION "'○'"
      uncomment 'typeset -g POWERLEVEL9K_AZURE_VISUAL_IDENTIFIER_EXPANSION'
      sub AZURE_VISUAL_IDENTIFIER_EXPANSION "'az'"
      uncomment 'typeset -g POWERLEVEL9K_AWS_EB_ENV_VISUAL_IDENTIFIER_EXPANSION'
      sub AWS_EB_ENV_VISUAL_IDENTIFIER_EXPANSION "'eb'"
      uncomment 'typeset -g POWERLEVEL9K_BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION'
      sub BACKGROUND_JOBS_VISUAL_IDENTIFIER_EXPANSION "'≡'"
    fi

    if [[ $POWERLEVEL9K_MODE == (awesome-patched|awesome-fontconfig) && $cap_python == 0 ]]; then
      uncomment 'typeset -g POWERLEVEL9K_VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION'
      uncomment 'typeset -g POWERLEVEL9K_ANACONDA_VISUAL_IDENTIFIER_EXPANSION'
      uncomment 'typeset -g POWERLEVEL9K_PYENV_VISUAL_IDENTIFIER_EXPANSION'
      uncomment 'typeset -g POWERLEVEL9K_PYTHON_ICON'
      sub VIRTUALENV_VISUAL_IDENTIFIER_EXPANSION "'🐍'"
      sub ANACONDA_VISUAL_IDENTIFIER_EXPANSION "'🐍'"
      sub PYENV_VISUAL_IDENTIFIER_EXPANSION "'🐍'"
      sub PYTHON_ICON "'🐍'"
    fi

    if [[ $POWERLEVEL9K_MODE == nerdfont-complete ]]; then
      sub BATTERY_STAGES "'\uf58d\uf579\uf57a\uf57b\uf57c\uf57d\uf57e\uf57f\uf580\uf581\uf578'"
    fi

    if [[ $style == (classic|rainbow) ]]; then
      if [[ $style == classic ]]; then
        sub BACKGROUND $bg_color[$color]
        sub LEFT_SUBSEGMENT_SEPARATOR "'%$sep_color[$color]F$left_subsep'"
        sub RIGHT_SUBSEGMENT_SEPARATOR "'%$sep_color[$color]F$right_subsep'"
        sub VCS_LOADING_FOREGROUND $sep_color[$color]
        rep '%248F' "%$prefix_color[$color]F"
      else
        sub LEFT_SUBSEGMENT_SEPARATOR "'$left_subsep'"
        sub RIGHT_SUBSEGMENT_SEPARATOR "'$right_subsep'"
      fi
      sub RULER_FOREGROUND $frame_color[$color]
      sub MULTILINE_FIRST_PROMPT_GAP_FOREGROUND $frame_color[$color]
      sub MULTILINE_FIRST_PROMPT_PREFIX "'%$frame_color[$color]F╭─'"
      sub MULTILINE_NEWLINE_PROMPT_PREFIX "'%$frame_color[$color]F├─'"
      sub MULTILINE_LAST_PROMPT_PREFIX "'%$frame_color[$color]F╰─'"
      sub MULTILINE_FIRST_PROMPT_SUFFIX "'%$frame_color[$color]F─╮'"
      sub MULTILINE_NEWLINE_PROMPT_SUFFIX "'%$frame_color[$color]F─┤'"
      sub MULTILINE_LAST_PROMPT_SUFFIX "'%$frame_color[$color]F─╯'"
      sub LEFT_SEGMENT_SEPARATOR "'$left_sep'"
      sub RIGHT_SEGMENT_SEPARATOR "'$right_sep'"
      sub LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL "'$left_tail'"
      sub LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL "'$left_head'"
      sub RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL "'$right_head'"
      sub RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL "'$right_tail'"
    fi

    if [[ -n ${(j::)extra_icons} ]]; then
      local branch_icon=${icons[VCS_BRANCH_ICON]// }
      sub VCS_BRANCH_ICON "'$branch_icon '"
      uncomment os_icon
    else
      uncomment 'typeset -g POWERLEVEL9K_DIR_CLASSES'
      uncomment 'typeset -g POWERLEVEL9K_VCS_VISUAL_IDENTIFIER_EXPANSION'
      uncomment 'typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION'
      uncomment 'typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION'
      sub VCS_VISUAL_IDENTIFIER_EXPANSION ''
      sub COMMAND_EXECUTION_TIME_VISUAL_IDENTIFIER_EXPANSION ''
      sub TIME_VISUAL_IDENTIFIER_EXPANSION ''
    fi

    if [[ -n ${(j::)prefixes} ]]; then
      uncomment 'typeset -g POWERLEVEL9K_VCS_PREFIX'
      uncomment 'typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PREFIX'
      uncomment 'typeset -g POWERLEVEL9K_CONTEXT_PREFIX'
      uncomment 'typeset -g POWERLEVEL9K_KUBECONTEXT_PREFIX'
      uncomment 'typeset -g POWERLEVEL9K_TIME_PREFIX'
      uncomment 'typeset -g POWERLEVEL9K_TOOLBOX_PREFIX'
      if [[ $style == (lean|classic) ]]; then
        [[ $style == classic ]] && local fg="%$prefix_color[$color]F" || local fg="%f"
        sub VCS_PREFIX "'${fg}on '"
        sub COMMAND_EXECUTION_TIME_PREFIX "'${fg}took '"
        sub CONTEXT_PREFIX "'${fg}with '"
        sub KUBECONTEXT_PREFIX "'${fg}at '"
        sub TIME_PREFIX "'${fg}at '"
        sub TOOLBOX_PREFIX "'${fg}in '"
      fi
    fi

    sub MULTILINE_FIRST_PROMPT_GAP_CHAR "'$gap_char'"

    if [[ $style == (classic|rainbow) && $num_lines == 2 ]]; then
      if (( ! right_frame )); then
        sub MULTILINE_FIRST_PROMPT_SUFFIX ''
        sub MULTILINE_NEWLINE_PROMPT_SUFFIX ''
        sub MULTILINE_LAST_PROMPT_SUFFIX ''
      fi
      if (( ! left_frame )); then
        sub MULTILINE_FIRST_PROMPT_PREFIX ''
        sub MULTILINE_NEWLINE_PROMPT_PREFIX ''
        sub MULTILINE_LAST_PROMPT_PREFIX ''
        sub STATUS_OK false
        sub STATUS_ERROR false
      fi
    fi

    if [[ $style == lean* ]]; then
      sub RULER_FOREGROUND $frame_color[$color]
      sub MULTILINE_FIRST_PROMPT_GAP_FOREGROUND $frame_color[$color]
      if (( right_frame )); then
        sub MULTILINE_FIRST_PROMPT_SUFFIX "'%$frame_color[$color]F─╮'"
        sub MULTILINE_NEWLINE_PROMPT_SUFFIX "'%$frame_color[$color]F─┤'"
        sub MULTILINE_LAST_PROMPT_SUFFIX "'%$frame_color[$color]F─╯'"
        sub RIGHT_PROMPT_LAST_SEGMENT_END_SYMBOL "' '"
      fi
      if (( left_frame )); then
        sub MULTILINE_FIRST_PROMPT_PREFIX "'%$frame_color[$color]F╭─'"
        sub MULTILINE_NEWLINE_PROMPT_PREFIX "'%$frame_color[$color]F├─'"
        sub MULTILINE_LAST_PROMPT_PREFIX "'%$frame_color[$color]F╰─'"
        sub LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL "' '"
      fi
    fi

    if [[ $style == (classic|rainbow) ]]; then
      if (( num_lines == 2 && ! left_frame )); then
        uncomment prompt_char
      else
        uncomment vi_mode
      fi
    fi

    if [[ $POWERLEVEL9K_MODE == ascii ]]; then
      sub 'STATUS_OK_VISUAL_IDENTIFIER_EXPANSION' "'ok'"
      sub 'STATUS_OK_PIPE_VISUAL_IDENTIFIER_EXPANSION' "'ok'"
      sub 'STATUS_ERROR_VISUAL_IDENTIFIER_EXPANSION' "'err'"
      sub 'STATUS_ERROR_SIGNAL_VISUAL_IDENTIFIER_EXPANSION' ""
      sub 'STATUS_ERROR_PIPE_VISUAL_IDENTIFIER_EXPANSION' "'err'"
      sub 'BATTERY_STAGES' "('battery')"
      sub 'PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION' "'>'"
      sub 'PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION' "'<'"
      sub 'PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION' "'V'"
      sub 'PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION' "'^'"
      rep "-i '⭐'" "-i '*'"
      rep '…' '..'
      rep '⇣' '<'
      rep '⇡' '>'
      rep '⇠' '<-'
      rep '⇢' '->'
      rep '─' '-'
    fi
  fi

  if (( $+pure_use_rprompt )); then
    local segment
    for segment in command_execution_time virtualenv context; do
      rep "    $segment" "    tmp_$segment"
      uncomment $segment
      rep "    tmp_$segment  " "    # $segment"
    done
  fi

  if [[ -n $time ]]; then
    uncomment time
    if [[ $time == $time_12h ]]; then
      sub TIME_FORMAT "'%D{%I:%M:%S %p}'"
    fi
  fi

  if (( num_lines == 1 )); then
    local -a tmp
    local line
    for line in "$lines[@]"; do
      [[ $line == ('    newline'*|*'===[ Line #'*) ]] || tmp+=$line
    done
    lines=("$tmp[@]")
  fi

  (( empty_line )) && sub PROMPT_ADD_NEWLINE true || sub PROMPT_ADD_NEWLINE false

  sub INSTANT_PROMPT $instant_prompt
  (( transient_prompt )) && sub TRANSIENT_PROMPT always

  local header=${(%):-"# Generated by Powerlevel10k configuration wizard on %D{%Y-%m-%d at %H:%M %Z}."}$'\n'
  header+="# Based on romkatv/powerlevel10k/config/p10k-${style//_/-}.zsh"
  if [[ $commands[sum] == ('/bin'|'/usr/bin'|'/usr/local/bin')'/sum' ]]; then
    local -a sum
    if sum=($(sum <<<${base//$'\r\n'/$'\n'} 2>/dev/null)) && (( $#sum == 2 )); then
      header+=", checksum $sum[1]"
    fi
  fi
  header+=$'.\n'
  local line="# Wizard options: $options[1]"
  local opt
  for opt in $options[2,-1]; do
    if (( $#line + $#opt > 85 )); then
      header+=$line
      header+=$',\n'
      line="# $opt"
    else
      line+=", $opt"
    fi
  done
  header+=$line
  header+=$'.\n# Type `p10k configure` to generate another config.\n#'

  command mkdir -p -- ${__p9k_cfg_path:h} || return

  if [[ -e $__p9k_cfg_path ]]; then
    unlink $__p9k_cfg_path || return
  fi
  print -lr -- "$header" "$lines[@]" >$__p9k_cfg_path
}

function change_zshrc() {
  (( write_zshrc )) || return 0

  local tmp=$__p9k_zshrc.${(%):-%n}.tmp.$$
  [[ ! -e $__p9k_zshrc ]] || cp -p $__p9k_zshrc $tmp || return

  {
    local -i writable=1
    if [[ -e $tmp && ! -w $tmp ]]; then
      chmod u+w -- $tmp || return
      writable=0
    fi

    print -n >$tmp || return

    if (( !zshrc_has_instant_prompt )); then
      >>$tmp print -r -- "# Enable Powerlevel10k instant prompt. Should stay close to the top of ${(%)__p9k_zshrc_u}.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r \"\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\" ]]; then
  source \"\${XDG_CACHE_HOME:-\$HOME/.cache}/p10k-instant-prompt-\${(%):-%n}.zsh\"
fi" || return
    fi
    if [[ -n $zshrc_content ]]; then
      (( zshrc_has_instant_prompt )) || print >>$tmp || return
      >>$tmp print -r -- $zshrc_content || return
    fi
    if (( !zshrc_has_cfg )); then
      >>$tmp print -r -- "
# To customize prompt, run \`p10k configure\` or edit ${(%)__p9k_cfg_path_u}.
[[ ! -f ${(%)__p9k_cfg_path_u} ]] || source ${(%)__p9k_cfg_path_u}" || return
    fi
    (( writable )) || chmod u-w -- $tmp || return
    command mv -f -- $tmp $__p9k_zshrc || return
  } always {
    zf_rm -f -- $tmp
  }

  if [[ -n $zshrc_backup_u ]]; then
    print -rP ""
    flowing +c See "%B${__p9k_zshrc_u//\\/\\\\}%b" changes:
    print -rP  "
  %2Fdiff%f %B$zshrc_backup_u%b %B$__p9k_zshrc_u%b"
  fi
  return 0
}

function check_zshrc_integration() {
  typeset -g zshrc_content=
  typeset -gi zshrc_has_cfg=0 zshrc_has_instant_prompt=0
  [[ -e $__p9k_zshrc ]] || return 0
  zshrc_content="$(<$__p9k_zshrc)" || return
  local lines=(${(f)zshrc_content})
  local f0=$__p9k_cfg_path_o
  local f1=${(q)f0}
  local f2=${(q-)f0}
  local f3=${(qq)f0}
  local f4=${(qqq)f0}
  local g1=${${(q)__p9k_cfg_path_o}/#(#b)${(q)HOME}\//'~/'}
  local h0='${ZDOTDIR:-~}/.p10k.zsh'
  local h1='${ZDOTDIR:-$HOME}/.p10k.zsh'
  local h2='"${ZDOTDIR:-$HOME}/.p10k.zsh"'
  local h3='"${ZDOTDIR:-$HOME}"/.p10k.zsh'
  local h4='${ZDOTDIR}/.p10k.zsh'
  local h5='"${ZDOTDIR}/.p10k.zsh"'
  local h6='"${ZDOTDIR}"/.p10k.zsh'
  local h7='$ZDOTDIR/.p10k.zsh'
  local h8='"$ZDOTDIR/.p10k.zsh"'
  local h9='"$ZDOTDIR"/.p10k.zsh'
  local h10='$POWERLEVEL9K_CONFIG_FILE'
  local h11='"$POWERLEVEL9K_CONFIG_FILE"'
  if [[ -n ${(@M)lines:#(#b)[^#]#([^[:IDENT:]]|)source[[:space:]]##($f1|$f2|$f3|$f4|$g1|$h0|$h1|$h2|$h3|$h4|$h5|$h6|$h7|$h8|$h9|$h10|$h11)(|[[:space:]]*|'#'*)} ]]; then
    zshrc_has_cfg=1
  fi
  local pre='${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh'
  if [[ -n ${(@M)lines:#(#b)[^#]#([^[:IDENT:]]|)source[[:space:]]##($pre|\"$pre\")(|[[:space:]]*|'#'*)} ]]; then
    zshrc_has_instant_prompt=1
  fi
  return 0
}

() {
  (( force )) && return
  _p9k_can_configure -q || return 0
  local zshrc_content zshrc_has_cfg zshrc_has_instant_prompt
  check_zshrc_integration 2>/dev/null || return 0
  (( zshrc_has_cfg )) || return 0
  [[ -s $__p9k_cfg_path ]] || return 0
  print -P ""
  flowing                                                                          \
      Powerlevel10k configuration file "($__p9k_cfg_path_u)" was not sourced. This \
      might have been caused by errors in zsh startup files, most likely in        \
      $__p9k_zshrc_u. See above for any indication of such errors and fix them. If \
      there are no errors, try running Powerlevel10k configuration wizard:
  print -P ''
  print -P '  %2Fp10k%f %Bconfigure%b'
  print -P ''
  flowing                                                                              \
      If you do nothing, you will see this message again when you start zsh. You can   \
      suppress it by defining %BPOWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true%b in    \
      $__p9k_zshrc_u.
  print -P ''
  return 1
} || return

if (( $+terminfo[smcup] && $+terminfo[rmcup] )) && echoti smcup 2>/dev/null; then
  function restore_screen() {
    echoti rmcup 2>/dev/null
    function restore_screen() {}
  }
else
  function restore_screen() {}
fi

{  # always

if (( force )); then
  _p9k_can_configure || return
else
  _p9k_can_configure -q || return
fi

zmodload zsh/terminfo                     || return
autoload -Uz is-at-least                  || return

if is-at-least 5.7.1 && [[ $COLORTERM == (24bit|truecolor) ]]; then
  local -ir has_truecolor=1
else
  local -ir has_truecolor=0
fi

stty -echo 2>/dev/null

while true; do
  local instant_prompt=verbose zshrc_content= zshrc_backup= zshrc_backup_u=
  local -i zshrc_has_cfg=0 zshrc_has_instant_prompt=0 write_zshrc=0
  local POWERLEVEL9K_MODE= POWERLEVEL9K_ICON_PADDING=moderate style= config_backup= config_backup_u=
  local gap_char=' ' prompt_char='❯' down_triangle='\uE0BC' up_triangle='\uE0BA' slanted_bar='\u2571'
  local left_subsep= right_subsep= left_tail= right_tail= left_head= right_head= time=
  local -i num_lines=2 empty_line=0 color=2 left_frame=1 right_frame=1 transient_prompt=0
  local -i cap_diamond=0 cap_python=0 cap_debian=0 cap_lock=0 cap_arrow=0
  local -a extra_icons=('' '' '')
  local -a frame_color=(244 242 240 238)
  local -a color_name=(Lightest Light Dark Darkest)
  local -a prefixes=('' '')
  local -a options=()
  if (( has_truecolor )); then
    local -A pure_color=(${(kv)pure_snazzy})
  else
    local -A pure_color=(${(kv)pure_original})
  fi

  unset pure_use_rprompt

  if [[ $TERM != (dumb|linux) && $langinfo[CODESET] == (utf|UTF)(-|)8 ]]; then
    ask_font || continue
    ask_diamond || continue
    if [[ $AWESOME_GLYPHS_LOADED == 1 ]]; then
      POWERLEVEL9K_MODE=awesome-mapped-fontconfig
    else
      ask_lock '\uF023' || continue
      if (( ! cap_lock )); then
        ask_lock '\uE138' "Let's try another one." || continue
        if (( cap_lock )); then
          if (( cap_diamond )); then
            POWERLEVEL9K_MODE=awesome-patched
            ask_python || continue
          else
            POWERLEVEL9K_MODE=flat
          fi
        else
          if (( cap_diamond )); then
            POWERLEVEL9K_MODE=powerline
          else
            ask_arrow || continue
            (( cap_arrow )) && POWERLEVEL9K_MODE=compatible || POWERLEVEL9K_MODE=ascii
          fi
        fi
      elif (( ! cap_diamond )); then
        POWERLEVEL9K_MODE=awesome-fontconfig
      else
        ask_debian || continue
        if (( cap_debian )); then
          POWERLEVEL9K_MODE=nerdfont-complete
        else
          POWERLEVEL9K_MODE=awesome-fontconfig
          ask_python || continue
        fi
      fi
    fi
  else
    POWERLEVEL9K_MODE=ascii
  fi

  if [[ $POWERLEVEL9K_MODE == powerline ]]; then
    options+=powerline
  elif (( cap_diamond )); then
    options+="$POWERLEVEL9K_MODE + powerline"
  else
    options+="$POWERLEVEL9K_MODE"
  fi
  (( cap_python )) && options[-1]+=' + python'
  if (( cap_diamond )); then
    left_sep=$right_triangle
    right_sep=$left_triangle
    left_subsep=$right_angle
    right_subsep=$left_angle
    left_head=$right_triangle
    right_head=$left_triangle
  else
    left_sep=
    right_sep=
    left_head=
    right_head=
    if [[ $POWERLEVEL9K_MODE == ascii ]]; then
      left_subsep='|'
      right_subsep='|'
      prompt_char='>'
      left_frame=0
      right_frame=0
    else
      left_subsep=$vertical_bar
      right_subsep=$vertical_bar
    fi
  fi

  _p9k_init_icons
  ask_icon_padding     || continue
  _p9k_init_icons

  ask_style            || continue
  ask_charset          || continue
  ask_color_scheme     || continue
  ask_color            || continue
  ask_use_rprompt      || continue
  ask_time             || continue
  ask_separators       || continue
  ask_heads            || continue
  ask_tails            || continue
  ask_num_lines        || continue
  ask_gap_char         || continue
  ask_frame            || continue
  ask_ornaments_color  || continue
  ask_empty_line       || continue
  ask_extra_icons      || continue
  ask_prefixes         || continue
  ask_transient_prompt || continue
  ask_instant_prompt   || continue
  ask_config_overwrite || continue
  ask_zshrc_edit       || continue
  break
done

restore_screen

if (( !in_z4h_wizard )); then
  print

  flowing +c New config: "%U${__p9k_cfg_path_u//\\/\\\\}%u."
  if [[ -n $config_backup ]]; then
    flowing +c Backup of the old config: "%U${config_backup_u//\\/\\\\}%u."
  fi
  if [[ -n $zshrc_backup ]]; then
    flowing +c Backup of "%U${__p9k_zshrc_u//\\/\\\\}%u:" "%U${zshrc_backup_u//\\/\\\\}%u."
  fi
fi

generate_config || return
change_zshrc    || return

if (( !in_z4h_wizard )); then
  print -rP ""
  flowing +c File feature requests and bug reports at "$(href https://github.com/romkatv/powerlevel10k/issues)"
  print -rP ""
fi

success=1

} always {
  (( success )) || quit
  consume_input
  stty echo 2>/dev/null
  show_cursor
  restore_screen
}
