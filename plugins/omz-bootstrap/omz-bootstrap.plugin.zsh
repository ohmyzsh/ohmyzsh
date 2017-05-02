DIR="$(dirname "$0")"
source "$DIR/lib/map.zsh"
source "$DIR/lib/repository.zsh"
source "$DIR/lib/download.zsh"
unset DIR


usage='Usage: omz { plugin | theme } <cmd> [<options>]'
usage_p='Usage: omz plugin <cmd> [<options>]
Commands:
  ls                    list available plugins
  on  <name>            enable a plugin
  off <name>            disable a plugin
  up  <name>            update a plugin
  get <git-url> <name>  download and enable a plugin'
usage_t='Usage: omz theme <cmd> [<options>]
Commands:
  ls                    list available themes
  set <name>            set a theme
  up  <name>            update a theme
  get <git-url> <name>  download and enable a theme'

omz () {
  case "$1" in
    (plugin)
      case "$2" in
        (ls)
          _list_plugins | less
        ;;
        (on)
          _enable_plugin "$3" && _populate_enabled_plugins "$3"
        ;;
        (off)
          _disable_plugin "$3"
        ;;
        (up)
          _update_plugin "$3"
        ;;
        (get)
          _download_plugin "$3" "$4" && _populate_enabled_plugins "$4"
        ;;
        (-h|--help|help)
          echo $usage_p
        ;;
        (*)
          echo $usage_p
          return 10
        ;;
      esac
    ;;
    (theme)
      case "$2" in
        (ls)
          _list_themes | less
        ;;
        (set)
          _enable_theme "$3" && _populate_enabled_theme
        ;;
        (up)
          _update_theme "$3"
        ;;
        (get)
          _download_theme "$3" "$4" && _populate_enabled_theme
        ;;
        (-h|--help|help)
          echo $usage_t
        ;;
        (*)
          echo $usage_t
          return 20
        ;;
      esac
    ;;
    (-h|--help|help)
      echo $usage
    ;;
    (*)
      echo $usage
      return 1
    ;;
  esac
}

