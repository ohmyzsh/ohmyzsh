_load_highlight_command() {
  source $1/highlight-command.sh
}

[[ -f $ZSH_CUSTOM/plugins/highlight-command/highlight-command.plugin.zsh ]] && _load_highlight_command $ZSH_CUSTOM/plugins/highlight-command
[[ -f $ZSH/plugins/highlight-command/highlight-command.plugin.zsh ]] && _load_highlight_command $ZSH/plugins/highlight-command
