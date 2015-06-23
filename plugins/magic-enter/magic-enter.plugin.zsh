# Bind quick stuff to enter!
#
# Pressing enter in a git directory runs `git status`
# in other directories `ls`
magic-enter () {
  if [[ -z $BUFFER ]]; then
    echo ""
    if git rev-parse --is-inside-work-tree &>/dev/null; then
      git status -u .
    else
      ls -lh
    fi
    zle redisplay
  else
    zle accept-line
  fi
}
zle -N magic-enter
bindkey "^M" magic-enter
