#compdef wd

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion::complete:wd:*:commands' group-name commands
zstyle ':completion::complete:wd:*:warp_points' group-name warp_points
zstyle ':completion::complete:wd::' list-grouped

# Call `_wd()` when when trying to complete the command `wd`

zmodload zsh/mapfile
function _wd() {
  local ret=1
  local CONFIG=$HOME/.warprc

  # Stolen from
  # http://stackoverflow.com/questions/9000698/completion-when-program-has-sub-commands

  # local curcontext="$curcontext" state line
  # typeset -A opt_args

  local -a commands
  local -a warp_points
  warp_points=( "${(f)mapfile[$CONFIG]}" )
  # LIST="${mapfile[$FNAME]}" # Not required unless stuff uses it

  commands=(
    'add:Adds the current working directory to your warp points'
    'add!:Overwrites existing warp point'
    'rm:Removes the given warp point'
    'ls:Outputs all stored warp points'
    'show:Outputs all warp points that point to the current directory'
    'help:Show this extremely helpful text'
    '..:Go back to last directory'
  )

  _arguments -C \
    '1: :->first_arg' \
    '2: :->second_arg' && ret=0

  case $state in
    first_arg)
      _describe -t warp_points "Warp points" warp_points && ret=0
      _describe -t commands "Commands" commands && ret=0
      ;;
    second_arg)
      case $words[2] in
        add\!|rm)
          _describe -t points "Warp points" warp_points && ret=0
          ;;
        add)
          _message 'Write the name of your warp point' && ret=0
          ;;
      esac
      ;;
  esac

  return $ret
}

_wd "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
