#compdef wd

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion::complete:wd:*:commands' group-name commands
zstyle ':completion::complete:wd:*:warp_points' group-name warp_points
zstyle ':completion::complete:wd::' list-grouped

zmodload zsh/mapfile

function _wd() {
  local CONFIG=$HOME/.warprc
  local ret=1

  local -a commands
  local -a warp_points

  warp_points=( "${(f)mapfile[$CONFIG]//$HOME/~}" )

  commands=(
    'add:Adds the current working directory to your warp points'
    'add!:Overwrites existing warp point'
    'rm:Removes the given warp point'
    'list:Outputs all stored warp points'
    'ls:Show files from given warp point'
    'path:Show path to given warp point'
    'show:Outputs all warp points that point to the current directory or shows a specific target directory for a point'
    'help:Show this extremely helpful text'
    'clean:Remove points warping to nonexistent directories'
    'clean!:Remove nonexistent directories without confirmation'
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
        show)
          _describe -t points "Warp points" warp_points && ret=0
          ;;
        ls)
          _describe -t points "Warp points" warp_points && ret=0
          ;;
        path)
          _describe -t points "Warp points" warp_points && ret=0
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
