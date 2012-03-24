#compdef omz.sh
#autoload

_omz_all_plugins() {
  plugins=(`ls $ZSH/plugins`)
}

local -a _1st_arguments
_1st_arguments=(
    'plugin:Enable plugin'
    'theme:Choose theme'
    'upgrade:Upgrade OH MY ZSH!'
    'uninstall:Remove OH MY ZSH! :('
)

local expl
local -a plugins all_plugins

_arguments \
  '*:: :->subcmds' && return 0

if (( CURRENT == 1 )); then
  _describe -t commands "omz.sh subcommand" _1st_arguments
  return
fi

case "$words[1]" in
  plugin )
    _arguments \
      '1: :->name' &&  return 0

    if [[ "$state" == name ]]; then
        _omz_all_plugins
        _wanted plugins expl 'all plugins' compadd -a plugins
    fi
    ;;

esac
