#!/usr/bin/env zsh
# Copyleft 2010 zsh-syntax-highlighting contributors
# http://github.com/nicoulaj/zsh-syntax-highlighting
# All wrongs reserved.

# Token types styles.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135
typeset -A ZSH_SYNTAX_HIGHLIGHTING_STYLES
ZSH_SYNTAX_HIGHLIGHTING_STYLES=(
  default                       'none'
  unknown-token                 'fg=red,bold'
  reserved-word                 'fg=yellow,bold'
  alias                         'fg=green,bold'
  builtin                       'fg=cyan,bold'
  function                      'fg=blue,bold'
  command                       'fg=green,bold'
  path                          'fg=white,underline'
  globbing                      'fg=blue,bold'
  single-hyphen-option          'fg=yellow'
  double-hyphen-option          'fg=yellow'
  single-quoted-argument        'fg=yellow'
  double-quoted-argument        'fg=yellow'
  dollar-double-quoted-argument 'fg=cyan'
  back-quoted-argument          'fg=cyan,bold'
  back-double-quoted-argument   'fg=magenta'
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
  self-insert
  magic-space
  delete-char
  backward-delete-char
  kill-word
  backward-kill-word
  up-line-or-history
  down-line-or-history
  beginning-of-history
  end-of-history
  accept-line
  accept-line-and-down-history
  undo
  redo
  yank
  complete-word
  expand-or-complete
  expand-or-complete-prefix
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
      '$')  style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[dollar-double-quoted-argument];;
      "\\") style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[back-double-quoted-argument]
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
  setopt localoptions extendedglob bareglobqual
  local colorize=true
  local start_pos=0
  local end_pos arg style
  region_highlight=()
  for arg in ${(z)BUFFER}; do
    local substr_color=0
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $colorize; then
      colorize=false
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[reserved-word];;
        *': alias')     style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[alias]
						local aliased_command=${$(alias $arg)#*=}
						[[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)$aliased_command]:-}:+yes} = 'yes' ]] && ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS+=($arg)
                        ;;
        *': builtin')   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[builtin];;
        *': function')  style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[function];;
        *': command')   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[command];;
        *)              _zsh_check-path && style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[path] || style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[unknown-token];;
      esac
    else
      case $arg in
        '--'*)   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[double-hyphen-option];;
        '-'*)    style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[single-hyphen-option];;
        "'"*"'") style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[single-quoted-argument];;
        '"'*'"') style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[double-quoted-argument]
                 region_highlight+=("$start_pos $end_pos $style")
                 _zsh_highlight-string
                 substr_color=1
                 ;;
        '`'*'`') style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[back-quoted-argument];;
        *"*"*)   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[globbing];;
        *)       _zsh_check-path && style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[path] || style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[default];;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]:-}:+yes} = 'yes' ]] && colorize=true
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

# vim: sw=2 ts=4 et
