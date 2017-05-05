_load_bootstrap() {
  export ZSH_BOOTSTRAP=$1
  source $ZSH_BOOTSTRAP/lib/map.zsh
  source $ZSH_BOOTSTRAP/lib/repository.zsh
  source $ZSH_BOOTSTRAP/lib/download.zsh
}

[[ -f $ZSH_CUSTOM/plugins/oh-my-zsh-bootstrap/oh-my-zsh-bootstrap.plugin.zsh ]] && _load_bootstrap $ZSH_CUSTOM/plugins/oh-my-zsh-bootstrap
[[ -f $ZSH/plugins/oh-my-zsh-bootstrap/oh-my-zsh-bootstrap.plugin.zsh ]] && _load_bootstrap $ZSH/plugins/oh-my-zsh-bootstrap


alias list_plugins="_list_plugins|less"
alias list_themes="_list_themes|less"
alias download_and_enable_plugin="_download_plugin"
alias download_and_enable_theme="_download_theme"
alias list_enabled_plugins="_list_enabled_plugins"
alias enable_plugin="_enable_plugin"
alias enable_theme="_enable_theme"
alias disable_plugin="_disable_plugin"
alias update_plugin="_udpate_plugin"
alias update_theme="_update_theme"