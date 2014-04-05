_load_bootstrap() {
  export ZSH_BOOTSTRAP=$1
  source $ZSH_BOOTSTRAP/lib/map.zsh
  source $ZSH_BOOTSTRAP/lib/repository.zsh
  source $ZSH_BOOTSTRAP/lib/download.zsh
}

[[ -f $ZSH_CUSTOM/plugins/oh-my-zsh-bootstrap/oh-my-zsh-bootstrap.plugin.zsh ]] && _load_bootstrap $ZSH_CUSTOM/plugins/oh-my-zsh-bootstrap
[[ -f $ZSH/plugins/oh-my-zsh-bootstrap/oh-my-zsh-bootstrap.plugin.zsh ]] && _load_bootstrap $ZSH/plugins/oh-my-zsh-bootstrap

usage='Usage: omz { plugin | theme } <cmd> [<options>]'
usage_p='Usage: omz plugin <cmd> [<options>]
Commands:
  ls\tlist available plugins
  on <name>\tenable a plugin
  off <name>\tdisable a plugin
  up <name>\tupdate a plugin
  get <git-url> <name>\tdownload and enable a plugin'
usage_t='Usage: omz theme <cmd> [<options>]
Commands:
  ls\tlist available themes
  set <name>\tset a theme
  up <name>\tupdate a theme
  get <git-url> <name>\tdownload and enable a theme'

omz () {
  case "$1" in
    (plugin)
      case "$2" in
        (ls)
          _list_plugins|less
        ;;
        (on)
          _enable_plugin "$3"&&_populate_enabled_plugins "$3"
        ;;
        (off)
          _disable_plugin "$3"
        ;;
        (up)
          _update_plugin "$3"
        ;;
        (get)
          _download_plugin "$3" "$4"&&_populate_enabled_plugins "$4"
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
          _list_themes|less
        ;;
        (set)
          _enable_theme "$3"&&_populate_enabled_theme
        ;;
        (up)
          _update_theme "$3"
        ;;
        (get)
          _download_theme "$3" "$4"&&_populate_enabled_theme
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

compdef _omz omz
