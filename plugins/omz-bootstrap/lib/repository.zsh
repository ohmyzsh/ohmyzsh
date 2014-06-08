_init_theme() {
  _map_exists themes theme
  [[ $? -ne 0 ]] && _map_put themes theme $ZSH_THEME
}

_pre_enable_plugins() {
  for plugin ($plugins); do
    _map_put plugins $plugin pre_enabled
  done
}

_list_plugins() {
  for plugin ($ZSH/plugins/* $ZSH_CUSTOM/plugins/*(N)); do
    local plugin_name=$(basename $plugin)
    local enabled=disabled
    _map_exists plugins $plugin_name
    if [[ $? -eq 0 ]]; then
      enabled=$(_map_get plugins $plugin_name)
    fi
    if [[ $enabled = "pre_enabled" || $enabled = "enabled" ]]; then
      printf "%-30s \033[0;32m%-10s\033[0m\n" $plugin_name $enabled
    else
      printf "%-30s \033[0;30m%-10s\033[0m\n" $plugin_name $enabled
    fi
  done
}

_list_themes() {
  for theme ($ZSH/themes/*zsh-theme $ZSH_CUSTOM/*zsh-theme(N)); do
    local theme_name=$(basename $theme | awk -F '.' '{print $1}')
    local selected_theme=$(_map_get themes theme)
    if [[ $selected_theme = $theme_name ]]; then
      printf "%-30s \033[0;32m%-10s\033[0m\n" $theme_name enabled
    else
      printf "%-30s \033[0;30m%-10s\033[0m\n" $theme_name disabled
    fi
  done
}

_list_pre_enabled_enabled_plugins() {
  for plugin ($(_map_keys plugins)); do
    local enabled=$(_map_get plugins $plugin)
    if [[ $enabled = "enabled" ]]; then
      printf "%s " $plugin
    fi
  done
}

_list_enabled_plugins() {
  for plugin ($(_map_keys plugins)); do
    local enabled=$(_map_get plugins $plugin)
    if [[ $enabled = "pre_enabled" || $enabled = "enabled" ]]; then
      printf "%-30s \033[0;32m%-10s\033[0m\n" $plugin $enabled
    fi
  done
}

_enable_plugin() {
  [[ -z "$1" ]] && return 1
  local plugin=$1
  _map_exists plugins $plugin
  if [[ $? -ne 0 ]]; then
    _map_put plugins $plugin enabled
  fi
}

_enable_theme() {
  [[ -z "$1" ]] && return 1
  local theme=$1
  _map_put themes theme $theme
}

_disable_plugin() {
  [[ -z "$1" ]] && return 1
  local plugin=$1
  local enabled=$(_map_get plugins $plugin)
  [[ $enabled = "enabled" ]] && _map_remove plugins $plugin
}

_populate_enabled_plugins() {
  for plugin ($@); do
    if [[ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]]; then
      fpath=($ZSH/plugins/$plugin $fpath)
      source $ZSH/plugins/$plugin/$plugin.plugin.zsh
    elif [[ -f $ZSH/plugins/$plugin/_$plugin ]]; then
      fpath=($ZSH/plugins/$plugin $fpath)
    elif [[ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]]; then
      fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
      source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
    elif [[ -f $ZSH_CUSTOM/plugins/$plugin/_$plugin ]]; then
      fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
    fi
  done
}

_populate_enabled_theme() {
  ZSH_THEME=$(_map_get themes theme)
  # Reload theme (copied from oh-my-zsh.sh)
  if [ -f "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme" ]; then
    source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
  elif [ -f "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme" ]; then
    source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
  else
    source "$ZSH/themes/$ZSH_THEME.zsh-theme"
  fi
}

_update_plugin() {
  [[ -z "$1" ]] && return 1
  local plugin=$1
  if [[ -d $ZSH_CUSTOM/plugins/$plugin ]]; then
    command pushd $ZSH_CUSTOM/plugins/$plugin > /dev/null
    command git pull
    command popd > /dev/null
  fi
}

_update_theme() {
  [[ -z "$1" ]] && return 1
  local theme=$1
  if [[ -d $ZSH_CUSTOM/themes/$theme ]]; then
    command pushd $ZSH_CUSTOM/themes/$theme > /dev/null
    command git pull
    command popd > /dev/null
  fi
}

# initialize repository
_pre_enable_plugins
_populate_enabled_plugins
_init_theme
_populate_enabled_theme $(_list_pre_enabled_enabled_plugins)
