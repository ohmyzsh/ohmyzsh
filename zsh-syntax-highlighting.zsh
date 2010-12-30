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

ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'start' 'time' 'strace' 'noglob' 'command' 'builtin')

_check_path() {
  [[ -z $arg ]] && return 1
  [[ -e $arg ]] && return 0
  [[ ! -e ${arg:h} ]] && return 1
  [[ ${#BUFFER} == $end_pos && -n $(print $arg*(N)) ]] && return 0
  return 1
}

# hightlight special chars inside double-quoted strings
_hl_string() {
  local i
  local j
  local k
  local c
  for (( i = 0 ; i < end_pos - start_pos ; i += 1 )) ; do
    (( j = i + start_pos - 1 ))
    (( k = j + 1 ))
    c="$arg[$i]"
    [[ "$c" = '$' ]] && region_highlight+=("$j $k $ZSH_SYNTAX_HIGHLIGHTING_STYLES[dollar-double-quoted-argument]")
    if [[ "$c" = "\\" ]] ; then
      (( k = k + 1 ))
      region_highlight+=("$j $k $ZSH_SYNTAX_HIGHLIGHTING_STYLES[back-double-quoted-argument]")
    fi
  done
}

# Recolorize the current ZLE buffer.
colorize-zle-buffer() {
  setopt localoptions extendedglob bareglobqual
  region_highlight=()
  colorize=true
  start_pos=0
  for arg in ${(z)BUFFER}; do
    local substr_color=0
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]##[[:space:]]#}}))
    ((end_pos=$start_pos+${#arg}))
    if $colorize; then
      colorize=false
      res=$(LC_ALL=C builtin type -w $arg 2>/dev/null)
      case $res in
        *': reserved')  style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[reserved-word];;
        *': alias')     style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[alias];;
        *': builtin')   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[builtin];;
        *': function')  style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[function];;
        *': command')   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[command];;
        *)
          if _check_path; then
            style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[path]
          else
            style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[unknown-token]
          fi
          ;;
      esac
    else
      case $arg in
          '--'*)   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[double-hyphen-option];;
          '-'*)    style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[single-hyphen-option];;
          "'"*"'") style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[single-quoted-argument];;
          '"'*'"') style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[double-quoted-argument]
                   region_highlight+=("$start_pos $end_pos $style")
                   _hl_string
                   substr_color=1
                   ;;
          '`'*'`') style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[back-quoted-argument];;
          *"*"*)   style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[globbing];;
          *)       style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[default]
                   _check_path && style=$ZSH_SYNTAX_HIGHLIGHTING_STYLES[path]
                   ;;
      esac
    fi
    [[ $substr_color = 0 ]] && region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZSH_HIGHLIGHT_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]:-}:+yes} = 'yes' ]] && colorize=true
    start_pos=$end_pos
  done
}

# Bind the function to ZLE events.
ZSH_HIGHLIGHT_COLORED_FUNCTIONS=(
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
  undo
  redo
  yank
)

for f in $ZSH_HIGHLIGHT_COLORED_FUNCTIONS; do
  eval "$f() { zle .$f && colorize-zle-buffer } ; zle -N $f"
done

# Expand or complete hack

# create an expansion widget which mimics the original "expand-or-complete" (you can see the default setup using "zle -l -L")
zle -C orig-expand-or-complete .expand-or-complete _main_complete

# use the orig-expand-or-complete inside the colorize function (for some reason, using the ".expand-or-complete" widget doesn't work the same)
expand-or-complete() { builtin zle orig-expand-or-complete && colorize-zle-buffer }
zle -N expand-or-complete
