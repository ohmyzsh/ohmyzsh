# ------------------------------------------------------------------------------
# Description
# -----------
#
# [prefix](by default: sudo) or [prefix](by default: sudo) -e (replacement for sudoedit) will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
# * Subhaditya Nath <github.com/subnut>
# * Marc Cornellà <github.com/mcornella>
# * Carlo Sala <carlosalag@protonmail.com>
# * Xlebp Rjanoi <github.com/xlebpushek>
#
# ------------------------------------------------------------------------------

__prefix-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }

  # if the cursor is positioned in the $old part of the text, make
  # the substitution and leave the cursor after the $new text
  if [[ $CURSOR -le ${#old} ]]; then
    BUFFER="${new}${space}${BUFFER#$old }"
    CURSOR=${#new}
  # otherwise just replace $old with $new in the text before the cursor
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

prefix-command-line() {
  # If buffer is empty, use last history entry
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  {
    # If $SUDO_EDITOR or $VISUAL are defined, then use that as $EDITOR
    # Else use the default $EDITOR
    local EDITOR=${SUDO_EDITOR:-${VISUAL:-$EDITOR}}
    local PREFIX=${ZSH_SUDO_PLUGIN_PREFIX:-sudo}

    if [[ -z "$EDITOR" ]]; then
      case "$BUFFER" in
        $PREFIX\ -e\ *) __prefix-replace-buffer "$PREFIX -e" "" ;;
        $PREFIX\ *) __prefix-replace-buffer "$PREFIX" "" ;;
        *) LBUFFER="$PREFIX $LBUFFER" ;;
      esac
      return
    fi

    # Check if the typed command is really an alias to $EDITOR

    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # Note: ${var:c} makes a $PATH search and expands $var to the full path
    # The if condition is met when:
    # - $realcmd is '$EDITOR'
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "cmd --with --arguments"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "cmd"
    # - $realcmd is "/path/to/cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is "cmd"
    # - $realcmd is "cmd" and $EDITOR is "/path/to/cmd"
    # or
    # - $realcmd is "cmd" and $EDITOR is /alternative/path/to/cmd that appears in $PATH
    if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
      || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
      || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
      __prefix-replace-buffer "$cmd" "$PREFIX -e"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __prefix-replace-buffer "$editorcmd" "$PREFIX -e" ;;
      \$EDITOR\ *) __prefix-replace-buffer '$EDITOR' "$PREFIX -e" ;;
      $PREFIX\ -e\ *) __prefix-replace-buffer "$PREFIX -e" "$EDITOR" ;;
      $PREFIX\ *) __prefix-replace-buffer "$PREFIX" "" ;;
      *) LBUFFER="$PREFIX $LBUFFER" ;;
    esac
  } always {
    # Preserve beginning space
    LBUFFER="${WHITESPACE}${LBUFFER}"

    # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
    zle && zle redisplay  # only run redisplay if zle is enabled
  }
}

zle -N prefix-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' prefix-command-line
bindkey -M vicmd '\e\e' prefix-command-line
bindkey -M viins '\e\e' prefix-command-line

