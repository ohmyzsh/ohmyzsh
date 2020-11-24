# Default commands
: ${MAGIC_ENTER_GIT_COMMAND:="git status -u ."} # run when in a git repository
: ${MAGIC_ENTER_OTHER_COMMAND:="ls -lh ."}      # run anywhere else

magic-enter() {
  # Only run MAGIC_ENTER commands when in PS1 and command prompt empty
  # http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
  if [[ -z "$BUFFER" && "$CONTEXT" = start ]]; then
    echo ""
    if command git rev-parse --is-inside-work-tree &>/dev/null; then
      eval "$MAGIC_ENTER_GIT_COMMAND"
    else
      eval "$MAGIC_ENTER_OTHER_COMMAND"
    fi
    zle redisplay
  else
    zle .accept-line
  fi
}

# Wrapper for the accept-line zle widget (run when pressing Enter)
zle -N accept-line magic-enter
