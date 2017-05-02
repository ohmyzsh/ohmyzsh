#!/usr/bin/env zsh
# ------------------------------------------------------------------------------
# Fish style live command coloring.
# From: http://www.zsh.org/mla/users/2010/msg00692.html
# ------------------------------------------------------------------------------

# Required options.
setopt extendedglob

# Token types styles.
# See http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#SEC135
ZLE_RESERVED_WORD_STYLE='bold'
ZLE_ALIAS_STYLE='bold'
ZLE_BUILTIN_STYLE='bold'
ZLE_FUNCTION_STYLE='bold'
ZLE_COMMAND_STYLE='bold'
ZLE_COMMAND_UNKNOWN_TOKEN_STYLE='fg=red,bold'
ZLE_TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'start' 'time' 'strace')

# Recolorize the current ZLE buffer.
colorize-zle-buffer() {
  region_highlight=()
  colorize=true
  start_pos=0
  for arg in ${(z)BUFFER}; do
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
    ((end_pos=$start_pos+${#arg}))
    if $colorize; then
      colorize=false
      res=$(LC_ALL=C builtin type $arg 2>/dev/null)
      case $res in
        *'reserved word'*)  style=$ZLE_RESERVED_WORD_STYLE;;
        *'an alias'*)       style=$ZLE_ALIAS_STYLE;;
        *'shell builtin'*)  style=$ZLE_BUILTIN_STYLE;;
        *'shell function'*) style=$ZLE_FUNCTION_STYLE;;
        *"$cmd is"*)        style=$ZLE_COMMAND_STYLE;;
        *)                  style=$ZLE_COMMAND_UNKNOWN_TOKEN_STYLE;;
      esac
      region_highlight+=("$start_pos $end_pos $style")
    fi
    [[ ${${ZLE_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
    start_pos=$end_pos
  done
}

# Bind the function to ZLE events.
colorize-hook-self-insert() { builtin zle .self-insert && colorize-zle-buffer }
colorize-hook-backward-delete-char() { builtin zle .backward-delete-char && colorize-zle-buffer }
colorize-hook-vi-backward-delete-char() { builtin zle .vi-backward-delete-char && colorize-zle-buffer }

zle -N self-insert colorize-hook-self-insert
zle -N backward-delete-char colorize-hook-backward-delete-char
zle -N vi-backward-delete-char colorize-hook-vi-backward-delete-char
