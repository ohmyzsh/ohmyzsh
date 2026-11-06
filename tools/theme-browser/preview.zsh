# Static previews execute theme code as the current user, not in a sandbox.
# A private PTY supplies a process group without requiring shell job control.
typeset -g _OMZ_THEME_PREVIEW_DIR=${${(%):-%x}:A:h}

function _omz_theme_names() (
  emulate -L zsh
  setopt extendedglob
  local root=${ZSH:-${_OMZ_THEME_PREVIEW_DIR:h:h}}
  local custom=${ZSH_CUSTOM:-$root/custom} dir file name
  local -a names files
  for dir in "$custom" "$root/themes"; do
    if [[ $dir == "$custom" ]]; then
      files=("$dir"/**/*.zsh-theme(N-.))
    else
      files=("$dir"/*.zsh-theme(N-.))
    fi
    for file in "${files[@]}"; do
      name=${${file#"$dir/"}%.zsh-theme}
      [[ $dir == "$custom" ]] && name=${name#themes/}
      [[ -n $name && $name != random && /$name/ != */(.|..)/* && $name != /* && $name != *[[:cntrl:]\\]* ]] || continue
      names+=("$name")
    done
  done
  (( $#names )) && print -rl -- ${(ou)names}
  return 0
)

function _omz_theme_resolve() (
  emulate -L zsh
  setopt extendedglob
  local name=$1 root=${ZSH:-${_OMZ_THEME_PREVIEW_DIR:h:h}}
  local custom=${ZSH_CUSTOM:-$root/custom} dir
  if (( $# != 1 )) || [[ -z $name || $name == random || /$name/ == */(.|..)/* || $name == /* || $name == *//* || $name == *[[:cntrl:]\\]* ]]; then
    print -u2 -r -- 'theme preview: invalid or non-selectable theme name'
    return 2
  fi
  for dir in "$custom" "$custom/themes" "$root/themes"; do
    if [[ -f "$dir/$name.zsh-theme" ]]; then
      print -r -- "${dir:A}/$name.zsh-theme"
      return 0
    fi
  done
  print -u2 -r -- 'theme preview: theme not found'
  return 1
)

# One sample, with the requested exit status (0 by default). All execution and
# state changes are confined to this subshell and the fresh -df worker.
# For asynchronous callers, cancel the job group, not just zsh's waiting wrapper.
function _omz_theme_preview() (
  emulate -L zsh
  local theme sample=${2:-0} backend=$_OMZ_THEME_PREVIEW_DIR
  if (( $# < 1 || $# > 2 )) || [[ $sample != <0-255> ]]; then
    print -u2 -r -- 'theme preview: usage: _omz_theme_preview name [status 0..255]'
    return 2
  fi
  theme=$(_omz_theme_resolve "$1") || return $?
  if ! zmodload zsh/zpty || ! zmodload zsh/system || ! zmodload zsh/datetime || ! zmodload zsh/zselect; then
    print -u2 -r -- 'theme preview: required zsh modules unavailable (zpty, system, datetime, zselect)'
    return 1
  fi
  local tmp fifo_fd pty=omz-preview-$sysparams[pid] record pgid raw='' chunk error=''
  local selected=$1 custom=${ZSH_CUSTOM:-${ZSH:-${backend:h:h}}/custom}
  local -i active=0 cancelled=0 bytes=0 count remaining result=1
  local -F deadline
  trap 'cancelled=130' INT
  trap 'cancelled=143' TERM
  trap 'cancelled=129' HUP
  {
    tmp=$(command mktemp -d "${TMPDIR:-/tmp}/omz-preview.XXXXXXXX") || return 1
    command mkfifo "$tmp/output" || return 1
    sysopen -r -o nonblock,cloexec -u fifo_fd "$tmp/output" || return 1

    # Exec immediately: a forked shell function could run inherited EXIT traps
    # after returning. Both the launcher and theme worker must start fresh.
    local -a launch=("$commands[zsh]" -df "$backend/preview-worker.zsh" --supervise
      "$tmp" "${backend:h:h}" "$theme" "$sample" "$selected" "$custom")
    deadline=$(( EPOCHREALTIME + 3 ))
    if ! zpty -b "$pty" exec "${(@q)launch}"; then
      print -u2 -r -- 'theme preview: could not allocate a private PTY'
      return 1
    fi
    active=1
    # The builtin listing supplies the session leader even before the child
    # starts; this avoids a PID-handshake race during immediate cancellation.
    for record in "${(@f)$(zpty)}"; do
      if [[ $record == \(<->\)\ "$pty":* ]]; then
        pgid=${${record#\(}%%\)*}
        break
      fi
    done
    if [[ $pgid != <2-> ]]; then
      print -u2 -r -- 'theme preview: could not identify worker process group'
      return 1
    fi
    while true; do
      if (( cancelled )); then
        error='cancelled'
        break
      fi
      if (( EPOCHREALTIME >= deadline )); then
        error='timed out after 3 seconds'
        break
      fi
      remaining=$(( 32001 - bytes ))
      if sysread -i "$fifo_fd" -s $(( remaining < 4096 ? remaining : 4096 )) -t 0.02 -c count chunk; then
        raw+=$chunk
        (( bytes += count ))
        if (( bytes > 32000 )); then
          error='output exceeded 32 KiB'
          break
        fi
      elif [[ -s "$tmp/result" ]]; then
        result=$(<"$tmp/result")
        # The worker's dedicated completion status distinguishes a theme's
        # early exit (including exit 0) from rendering both prompts.
        [[ $result == 42 ]] || error="worker did not complete preview (exit $result)"
        break
      elif ! zpty -t "$pty"; then
        error='worker supervisor exited before completing preview'
        break
      else
        zselect -t 1
      fi
    done
  } always {
    # Clean up the whole group even on success. Deliberately detached processes
    # are outside this boundary. Delete only our PTY, not any inherited ones.
    if [[ $pgid == <2-> ]]; then
      kill -TERM -- -$pgid 2>/dev/null
      zselect -t 5
      kill -KILL -- -$pgid 2>/dev/null
    fi
    (( active )) && zpty -d "$pty" 2>/dev/null
    [[ -n $fifo_fd ]] && exec {fifo_fd}<&-
    [[ -n $tmp ]] && command rm -rf -- "$tmp"
  }

  # Bound by bytes before splitting into locale-aware characters. No escape is
  # emitted until it is a complete numeric SGR; all string controls are dropped,
  # including their payloads and incomplete sequences at the output boundary.
  unsetopt multibyte
  raw=${raw[1,32000]}
  setopt multibyte
  local char safe='' state=text sgr=''
  local -i code valid=1
  for char in "${(@s::)raw}"; do
    if (( cancelled )); then
      error='cancelled'
      break
    fi
    printf -v code '%d' "'$char" 2>/dev/null
    case $state in
      string|string-escape)
        if [[ $char == $'\a' || $char == $'\xc2\x9c' || $char == $'\x9c' || ( $state == string-escape && $char == \\ ) ]]; then
          state=text
        elif [[ $char == $'\e' ]]; then
          state=string-escape
        else
          state=string
        fi
        ;;
      escape)
        case $char in
          '[') state=csi; sgr=''; valid=1 ;;
          ']'|P|X|'^'|_) state=string ;;
          $'\e') ;;
          *)
            if (( code >= 32 && code <= 47 )); then
              state=intermediate
            else
              state=text
            fi
            ;;
        esac
        ;;
      intermediate)
        (( code >= 32 && code <= 47 )) || state=text
        ;;
      csi)
        if [[ $char == [0-9\;:] ]]; then
          sgr+=$char
        elif (( code >= 64 && code <= 126 )); then
          [[ $char == m && $valid == 1 ]] && safe+=$'\e['${sgr}m
          state=text
        elif [[ $char == $'\e' ]]; then
          state=escape
        else
          valid=0
        fi
        ;;
      text)
        case $char in
          $'\e') state=escape ;;
          $'\xc2\x9b') state=csi; sgr=''; valid=1 ;;
          # Drop raw 8-bit CSI instead of expanding it to two bytes. Filtering
          # can then never enlarge the byte-bounded input buffer.
          $'\x9b') state=csi; sgr=''; valid=0 ;;
          $'\xc2\x90'|$'\xc2\x98'|$'\xc2\x9d'|$'\xc2\x9e'|$'\xc2\x9f'|$'\x90'|$'\x98'|$'\x9d'|$'\x9e'|$'\x9f') state=string ;;
          $'\n'|$'\t') safe+=$char ;;
          *)
            # Reject format/directional controls even on libc implementations
            # that classify them as printable. Keep private-use font glyphs.
            if [[ $char == [[:print:]] ]] && ! (( code >= 0x200b && code <= 0x200f || code >= 0x2028 && code <= 0x202e || code >= 0x2060 && code <= 0x206f || code == 0xfeff )); then
              safe+=$char
            fi
            ;;
        esac
        ;;
    esac
  done
  (( cancelled )) && error='cancelled'
  print -rn -- "$safe"$'\e[0m\n'
  [[ -n $error ]] && print -u2 -r -- "theme preview: $error"
  (( cancelled )) && return $cancelled
  [[ -z $error ]]
)
