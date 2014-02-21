_load_z() {
  source $1/z.sh
}

[[ -f $ZSH_CUSTOM/plugins/z/z.plugin.zsh ]] && _load_z $ZSH_CUSTOM/plugins/z
[[ -f $ZSH/plugins/z/z.plugin.zsh ]] && _load_z $ZSH/plugins/z
