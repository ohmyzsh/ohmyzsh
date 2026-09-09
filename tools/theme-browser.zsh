# Loaded only by `omz theme browse`. The UI runs in a subshell; stdout is a
# two-line data handoff, while all terminal I/O goes through a private tty fd.
function _omz_theme_browser() (
  emulate -L zsh
  setopt extendedglob
  # Displayed names, filter text, and worker output are data, not prompt code.
  unsetopt promptsubst
  zmodload zsh/terminfo && zmodload zsh/zpty && zmodload zsh/system && zmodload zsh/datetime || return 1
  local tty saved filter=$1 key suffix name previous='' preview='' chunk
  local mode=browse action='' pty=omz-browser-$sysparams[pid] record pgid
  local -a names matches lines size
  local -i selected=1 page=1 height=0 width=0 rows=0 cols=0 active=0 dirty=1 i row cancelled=0
  local -F render_after=0
  [[ -n $terminfo[smcup] && -n $terminfo[rmcup] && -n $terminfo[cup] ]] || {
    print -u2 -r -- 'Theme browser requires a terminal with alternate-screen support.'
    return 1
  }
  exec {tty}<>/dev/tty || return 1
  saved=$(command stty -g <&$tty) || return 1
  names=("${(@f)$(_omz_theme_names)}")
  names=("${(@)names:#}")
  trap 'cancelled=1' INT TERM HUP
  trap 'dirty=1' WINCH

  function _omz_browser_stop {
    if (( active )); then
      [[ $pgid == <2-> ]] && kill -HUP -- -$pgid 2>/dev/null
      # Let the preview supervisor clean up its nested worker group first.
      local -i wait_count=0
      while zpty -t "$pty" && (( wait_count++ < 100 )); do
        zselect -t 1
      done
      zpty -d "$pty" 2>/dev/null
      active=0
    fi
  }

  function _omz_browser_line {
    local text=${1//$'\t'/    } formatted='' MATCH MBEGIN MEND
    text=${text//\%/%%}
    # Tell prompt truncation that SGR has zero display width. All other terminal
    # controls have already been removed by the preview backend.
    while [[ $text =~ $'\e\\[[0-9;:]*m' ]]; do
      formatted+=${text[1,$(( MBEGIN - 1 ))]}"%{"$MATCH"%}"
      text=${text[$(( MEND + 1 )),-1]}
    done
    formatted+=$text
    echoti cup $row 0 >&$tty
    print -Pn -u $tty -- "%${width}<..<${formatted}%<<%f%k%b"
    (( row++ ))
  }

  {
    zmodload zsh/zselect || return 1
    command stty -echo -icanon min 0 time 0 <&$tty || return 1
    print -rn -u $tty -- "$terminfo[smcup]$terminfo[civis]"
    while (( ! cancelled )); do
      size=(${=$(command stty size <&$tty)})
      rows=${size[1]:-24} cols=${size[2]:-80}
      if (( height != rows || width != cols - 1 )); then
        height=$rows width=$(( cols - 1 )) dirty=1
      fi
      matches=()
      for name in "${names[@]}"; do
        [[ ${(L)name} == *${(L)filter}* ]] && matches+=("$name")
      done
      (( selected > $#matches )) && selected=$#matches
      (( selected < 1 )) && selected=1
      name=${matches[$selected]}
      if [[ $name != "$previous" ]]; then
        _omz_browser_stop
        previous=$name preview='' dirty=1
        render_after=$(( EPOCHREALTIME + 0.12 ))
      fi
      # Coalesce typing and key repeats rather than starting a worker per key.
      if (( ! active && EPOCHREALTIME >= render_after )); then
        if [[ -n $name ]]; then
          # zpty joins arguments as shell text; quote the literal theme name.
          zpty -b "$pty" _omz_theme_preview "${(q)name}" || return 1
          active=1
          pgid=''
          for record in "${(@f)$(zpty)}"; do
            [[ $record == \(<->\)\ "$pty":* ]] && pgid=${${record#\(}%%\)*}
          done
        fi
      fi
      if (( active )); then
        while zpty -r -t "$pty" chunk; do
          preview+=${chunk//$'\r'/}
          dirty=1
        done
      fi
      page=$(( height > 24 ? 8 : 4 ))
      if (( dirty )); then
        print -rn -u $tty -- "$terminfo[clear]"
        row=0
        if (( width < 39 || height < 16 )); then
          _omz_browser_line 'Resize to at least 40 columns x 16 rows.'
          _omz_browser_line 'Esc / Ctrl-C: cancel'
        else
          _omz_browser_line 'Oh My Zsh theme browser | Esc / Ctrl-C: cancel'
          _omz_browser_line "Filter: ${(V)filter}  ($#matches themes)"
          if [[ $mode == actions ]]; then
            _omz_browser_line '[u] Use in session  [s] Save + reload  [b] Back'
            _omz_browser_line 'Use keeps old theme hooks. Save edits .zshrc + reloads.'
          else
            _omz_browser_line 'Arrows / Ctrl-P,N: move | PgUp,Dn | Enter: actions'
            _omz_browser_line 'Type to filter | Backspace: delete | Ctrl-U: clear'
          fi
          for (( i = ((selected - 1) / page) * page + 1; i <= $#matches && row < page + 4; i++ )); do
            if (( i == selected )); then
              _omz_browser_line "> ${(V)matches[$i]}"
            else
              _omz_browser_line "  ${(V)matches[$i]}"
            fi
          done
          _omz_browser_line '--- Static preview (right prompt shown separately) ---'
          lines=("${(@f)preview}")
          if [[ -z $preview ]]; then
            [[ -n $name ]] && lines=('Rendering...') || lines=('No matching themes.')
          fi
          for chunk in "${lines[@]}"; do
            (( row < height - 1 )) || break
            _omz_browser_line "$chunk"
          done
        fi
        dirty=0
      fi
      key=''
      read -r -k 1 -t 0.1 -u $tty key || continue
      if [[ $key == $'\e' ]]; then
        suffix=''
        while read -r -k 1 -t 0.03 -u $tty chunk; do
          suffix+=$chunk
          [[ $chunk == [A-Za-z~] || ${#suffix} -ge 8 ]] && break
        done
        [[ -n $suffix ]] || break
        key=$'\e'$suffix
      fi
      [[ $key == $'\x03' ]] && break
      if [[ $mode == actions ]]; then
        case $key in
          u) action=use; break ;;
          s) action=set; break ;;
          b|$'\r'|$'\n') mode=browse ;;
        esac
      else
        case $key in
          $'\e[A'|$'\eOA'|$'\x10') (( selected-- )) ;;
          $'\e[B'|$'\eOB'|$'\x0e') (( selected++ )) ;;
          $'\e[5~') (( selected -= page )) ;;
          $'\e[6~') (( selected += page )) ;;
          $'\x7f'|$'\b') filter=${filter[1,-2]}; selected=1 ;;
          $'\x15') filter=''; selected=1 ;;
          $'\r'|$'\n') [[ -n $name ]] && mode=actions ;;
          [[:print:]]) filter+=$key; selected=1 ;;
        esac
      fi
      dirty=1
    done
  } always {
    _omz_browser_stop
    print -rn -u $tty -- $'\e[0m'"$terminfo[cnorm]$terminfo[rmcup]"
    command stty "$saved" <&$tty
    exec {tty}>&-
  }
  (( cancelled )) && return 130
  [[ -n $action ]] && print -rl -- "$action" "$name"
  return 0
)
