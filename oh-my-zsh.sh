# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]
then
  /usr/bin/env ZSH=$ZSH zsh $ZSH/tools/check_for_upgrade.sh
fi

# Initializes Oh My Zsh

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/lib/*.zsh) source $config_file

# Add all defined plugins to fpath
plugin=${plugin:=()}
for plugin ($plugins) fpath=($ZSH/plugins/$plugin $fpath)

# Load and run compinit
autoload -U compinit
compinit -i

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [ "$ZSH_CUSTOM" = ""  ]
then
    ZSH_CUSTOM="$ZSH/custom"
fi

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
  elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($ZSH_CUSTOM/*.zsh) source $config_file

set_theme() {
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
}

random_theme() {
  local themes
  themes=($ZSH/themes/*zsh-theme)
  source "$themes[$RANDOM%$#themes+1]"
}
