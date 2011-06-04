# Initializes Oh My Zsh

# Create another directory under $ZSH called favorite_themes
# Every time a user 'likes' a theme:
#   Create symlink to it in favorite_themes (if it doesn't already exist)
# If user is using 'random' theme AND there are contents in the favorite_themes
# directory, use that as the 'themes' variable, otherwise use all

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

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH/custom/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/custom/plugins/$plugin/$plugin.plugin.zsh
  elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($ZSH/custom/*.zsh) source $config_file

export FAVORITE_THEMES_DIR="$ZSH/themes/favorites/"
  # Allow users to randomize themes with only their favorites
  if [ ! -d $FAVORITE_THEMES_DIR ]; then
      mkdir $FAVORITE_THEMES_DIR
  fi

# Load the theme
# Check for updates on initial load...
if [ "$ZSH_THEME" = "random" ]; then
  load_random_theme $ZSH/themes/*zsh-theme
elif [ "$ZSH_THEME" = "favorites" ]; then
  # Only randomize with liked themes if there are any
  if [ `ls $FAVORITE_THEMES_DIR | wc -w` -gt 0 ]; then
    load_random_theme $FAVORITE_THEMES_DIR/*zsh-theme
  else
    load_random_theme $ZSH/themes/*zsh-theme
  fi
else
  source "$ZSH/themes/$ZSH_THEME.zsh-theme"
fi


# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" = "true" ]
then
  return
else
  /usr/bin/env zsh $ZSH/tools/check_for_upgrade.sh
fi
