#!/usr/bin/env zsh
# Copyleft 2010 zsh-syntax-highlighting contributors
# http://github.com/nicoulaj/zsh-syntax-highlighting
# All wrongs reserved.
# vim: ft=zsh sw=2 ts=2 et

# Token types styles.
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES=(
  default                       'none'
  isearch                       'fg=magenta,standout'
  special                       'fg=magenta,standout'
  unknown-token                 'fg=red,bold'
  reserved-word                 'fg=yellow'
  alias                         'fg=green'
  builtin                       'fg=green'
  function                      'fg=green'
  command                       'fg=green'
  path                          'underline'
  globbing                      'fg=blue'
  history-expansion             'fg=blue'
  single-hyphen-option          'none'
  double-hyphen-option          'none'
  back-quoted-argument          'none'
  single-quoted-argument        'fg=yellow'
  double-quoted-argument        'fg=yellow'
  dollar-double-quoted-argument 'fg=cyan'
  back-double-quoted-argument   'fg=cyan'
)

# Tokens that are always followed by a command.
ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=(
  '|'
  '||'
  ';'
  '&'
  '&&'
  'sudo'
  'start'
  'time'
  'strace'
  'noglob'
  'command'
  'builtin'
)

# ZLE events that trigger an update of the highlighting.
ZSH_HIGHLIGHT_ZLE_UPDATE_EVENTS=(
  accept-and-hold
  accept-and-infer-next-history
  accept-line
  accept-line-and-down-history
  backward-delete-char
  backward-delete-word
  backward-kill-word
  beginning-of-buffer-or-history
  beginning-of-history
  beginning-of-history
  beginning-of-line-hist
  complete-word
  delete-char
  delete-char-or-list
  down-history
  down-line-or-history
  down-line-or-history
  down-line-or-search
  end-of-buffer-or-history
  end-of-history
  end-of-line-hist
  expand-or-complete
  expand-or-complete-prefix
  history-beginning-search-backward
  history-beginning-search-forward
  history-incremental-search-backward
  history-incremental-search-forward
  history-search-backward
  history-search-forward
  infer-next-history
  insert-last-word
  kill-word
  magic-space
  quoted-insert
  redo
  self-insert
  undo
  up-history
  up-line-or-history
  up-line-or-history
  up-line-or-search
  up-line-or-search
  vi-backward-kill-word
  vi-down-line-or-history
  vi-fetch-history
  vi-history-search-backward
  vi-history-search-forward
  vi-quoted-insert
  vi-repeat-search
  vi-rev-repeat-search
  vi-up-line-or-history
  yank
)

# ZLE highlight types.
zle_highlight=(
  special:$ZSH_HIGHLIGHT_STYLES[special]
  isearch:$ZSH_HIGHLIGHT_STYLES[isearch]
)

# Check if the argument is a path.
_zsh_check-path() {
  [[ -z $arg ]] && return 1
  [[ -e $arg ]] && return 0
  [[ ! -e ${arg:h} ]] && return 1
  [[ ${#BUFFER} == $end_pos && -n $(print $arg*(N)) ]] && return 0
  return 1
}

# Highlight special chars inside double-quoted strings
_zsh_highlight-string() {
  setopt localoptions noksharrays
  local i j k style
  # Starting quote is at 1, so start parsing at offset 2 in the string.
  for (( i = 2 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    case "$arg[$i]" in
      '$')  style=$ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument];;
      "\\") style=$ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]
            (( k += 1 )) # Color following char too.
            (( i += 1 )) # Skip parsing the escaped char.
            ;;
      *)    continue;;
    esac
    region_highlight+=("$j $k $style")
  done
}

# Recolorize the current ZLE buffer.
_zsh_highlight-zle-buffer() {
  # Avoid doing the same work over and over
  [[ ${ZSH_PRIOR_HIGHLIGHTED_BUFFER:-} == $BUFFER ]] && return
  ZSH_PRIOR_HIGHLIGHTED_BUFFER=$BUFFER

  setopt localoptions extendedglob bareglobqual
  local new_expression=true
  local start_pos=0
  local highlight_glob=true
  local end_pos arg style
  region_highlight=()
  for arg in ${(z)BUFFER}; do
    local substr_color=0
    [[ $start_pos -eq 0 && $arg = 'noglob' ]] && highlight_glob=false
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $new_expression; then
      new_expression=false
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_HIGHLIGHT_STYLES[reserved-word];;
        *': alias')     style=$ZSH_HIGHLIGHT_STYLES[alias]
                        local aliased_command=${"$(alias $arg)"#*=}
                        if [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$aliased_command]:-}:+yes} = 'yes' && ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$arg]:-}:+yes} != 'yes' ]]; then
                          ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        fi
                        ;;
        *': builtin')   style=$ZSH_HIGHLIGHT_STYLES[builtin];;
        *': function')  style=$ZSH_HIGHLIGHT_STYLES[function];;
        *': command')   style=$ZSH_HIGHLIGHT_STYLES[command];;
        *)              if _zsh_check-path; then
                          style=$ZSH_HIGHLIGHT_STYLES[path]
                        elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                          style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                        else
                          style=$ZSH_HIGHLIGHT_STYLES[unknown-token]
                        fi;;
      esac
    else
      case $arg in
        '--'*)   style=$ZSH_HIGHLIGHT_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_HIGHLIGHT_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_HIGHLIGHT_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_HIGHLIGHT_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight-string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_HIGHLIGHT_STYLES[back-quoted-argument];;
        *"*"*)   $highlight_glob && style=$ZSH_HIGHLIGHT_STYLES[globbing] || style=$ZSH_HIGHLIGHT_STYLES[default];;
        *)       if _zsh_check-path; then
                   style=$ZSH_HIGHLIGHT_STYLES[path]
                 elif [[ $arg[0,1] = $histchars[0,1] ]]; then
                   style=$ZSH_HIGHLIGHT_STYLES[history-expansion]
                 else
                   style=$ZSH_HIGHLIGHT_STYLES[default]
                 fi;;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]:-}:+yes} = 'yes' ]] && new_expression=true
    start_pos=$end_pos
  done
}

# Special treatment for completion/expansion events:
# For each *complete* function, we create a widget which mimics the original
# and use this orig-* version inside the new colorized zle function (the dot
# idiom used for all others doesn't work right for these functions for some
# reason).  You can see the default setup using "zle -l -L".

# Bind ZLE events to highlighting function.
for f in $ZSH_HIGHLIGHT_ZLE_UPDATE_EVENTS; do
  case $f in
    *complete*)
      eval "zle -C orig-$f .$f _main_complete ; $f() { builtin zle orig-$f && _zsh_highlight-zle-buffer } ; zle -N $f"
      ;;
    *)
      eval "$f() { builtin zle .$f && _zsh_highlight-zle-buffer } ; zle -N $f"
      ;;
  esac
done
