if ! (( $+commands[modulecmd] )); then
  print "zsh modulecmd plugin: Environment Modules not found. Please install Environment Modules before using this plugin." >&2
  return 1
fi

#
# CONFIGURATION VARIABLES
# Automatically load privatemodules
: ${ZSH_Modules_LOAD_PRIVATEMODULES:=false}


function _zsh_modules_plugin_init() {
  if [[ -d "$MODULESHOME" ]]; then
    . "$MODULESHOME/init/zsh"
  fi
  if [[ "$ZSH_Modules_LOAD_PRIVATEMODULES" != "false" && -d "$HOME/privatemodules" ]];then
    local privatemodules="$HOME/privatemodules"
    MODULEPATH+=$privatemodules
  fi
}

_zsh_modules_plugin_init
