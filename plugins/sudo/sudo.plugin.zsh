# ------------------------------------------------------------------------------
# Description
# -----------
#
# sudo or sudoedit will be inserted before the command
#
# ------------------------------------------------------------------------------
# Authors
# -------
#
# * Dongweiming <ciici123@gmail.com>
# * Subhaditya Nath <github.com/subnut>
# * Marc Cornellà <github.com/mcornella>
#
# ------------------------------------------------------------------------------

__sudo-replace-buffer() {
  local old=$1 new=$2 space=${2:+ }
  if [[ ${#LBUFFER} -le ${#old} ]]; then
    RBUFFER="${space}${BUFFER#$old }"
    LBUFFER="${new}"
  else
    LBUFFER="${new}${space}${LBUFFER#$old }"
  fi
}

sudo-command-line() {
  # If line is empty, get the last run command from history
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

  # Save beginning space
  local WHITESPACE=""
  if [[ ${LBUFFER:0:1} = " " ]]; then
    WHITESPACE=" "
    LBUFFER="${LBUFFER:1}"
  fi

  () {
    # Get the first part of the typed command
    local cmd="${${(Az)BUFFER}[1]}"
    # Get the first part of the alias of the same name as $cmd, or $cmd if no alias matches
    local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
    # Get the first part of the $EDITOR command ($EDITOR may have arguments after it)
    local editorcmd="${${(Az)EDITOR}[1]}"

    # If the typed command is a function or an alias to a function, use sudofn
    if [[ "$cmd" != (sudo|sudoedit) ]] && (( ${+functions[$realcmd]} )); then
      LBUFFER="sudofn $LBUFFER"
      return
    fi

    # Check if the typed command is really an alias to $EDITOR
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
      __sudo-replace-buffer "$cmd" "sudoedit"
      return
    fi

    # Check for editor commands in the typed command and replace accordingly
    case "$BUFFER" in
      $editorcmd\ *) __sudo-replace-buffer "$editorcmd" "sudoedit" ;;
      \$EDITOR\ *) __sudo-replace-buffer '$EDITOR' "sudoedit" ;;
      sudoedit\ *) __sudo-replace-buffer "sudoedit" "$EDITOR" ;;
      sudo\ *) __sudo-replace-buffer "sudo" "" ;;
      *) LBUFFER="sudo $LBUFFER" ;;
    esac
  }

  # Preserve beginning space
  LBUFFER="${WHITESPACE}${LBUFFER}"

  # Redisplay edit buffer (compatibility with zsh-syntax-highlighting)
  zle redisplay
}

zle -N sudo-command-line

# Defined shortcut keys: [Esc] [Esc]
bindkey -M emacs '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line
bindkey -M viins '\e\e' sudo-command-line

# Add alias to allow calling aliases with sudo
alias sudo='sudo '

# Add function for calling zsh functions with sudo
sudofn() {
  # Optionally allow specifying zsh options when running it. The
  # zsh arguments need to be specified before the fn name, e.g.:
  # $ sudofn -f -x funcname arg1 arg2
  local -a opts
  while [[ "$1" = [-+]* ]]; do
    opts+=($1)
    shift
  done

  # Return error if function not provided or undefined
  if [[ -z "$1" ]]; then
    echo "$0: you need to specify a function" >&2
    return 1
  elif (( ! ${+functions[$1]} )); then
    echo "$0: function is not defined: $1" >&2
    return 1
  fi

  # Define the function and run it in a new shell
  local fn="$1"; shift
  # Force non-interactive session but load .zshrc
  command sudo -E -s -- zsh $opts +i -s <<EOF
source ${ZDOTDIR:-$HOME}/.zshrc
function $fn {
${functions[$fn]}
}
$fn ${(j: :)${(q)@}}
EOF
}

_sudofn() {
  local -a fns excl
  # Get functions that don't start with _
  fns=(${(ok)functions:#_*})
  # Ignore sudofn and functions that haven't been loaded
  excl=(sudofn ${${(k)functions[(R)builtin autoload *]}:#_*})
  fns=(${fns:|excl})
  _arguments "1:shell function:($fns)" "*:: :${_comps[${words[2]}]:-_files}"
}

compdef _sudofn sudofn
