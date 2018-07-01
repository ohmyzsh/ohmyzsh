#compdef vhost

zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion::complete:vhost:*:commands' group-name commands
zstyle ':completion::complete:vhost:*:vhost_points' group-name vhost_points
zstyle ':completion::complete:vhost::' list-grouped

zmodload zsh/mapfile

function _vhost() {
  local CONFIG=$HOME/.vhost
  local ret=1

  local -a commands
  local -a vhost_points

  vhost_points=( "${(f)mapfile[$CONFIG]//$HOME/~}" )

  commands=(
    'ls:List all virtual host of you OS'
    'add:Add new virtual host'
    'rm:Remove a specific virtual host'
  )

  _arguments -C \
    '1: :->first_arg' \
    '2: :->second_arg' && ret=0

  case $state in
    first_arg)
      _describe -t vhost_points "Warp points" vhost_points && ret=0
      _describe -t commands "Commands" commands && ret=0
      ;;
    second_arg)
      case $words[2] in
        add)
          _message 'Write the name of your warp point' && ret=0
          ;;
        rm)
          _describe -t points "Warp points" vhost_points && ret=0
          ;;
        ls)
          _describe -t points "Warp points" vhost_points && ret=0
          ;;
      esac
      ;;
  esac

  return $ret
}

_vhost "$@"

# Local Variables:
# mode: Shell-Script
# sh-indentation: 2
# indent-tabs-mode: nil
# sh-basic-offset: 2
# End:
# vim: ft=zsh sw=2 ts=2 et
