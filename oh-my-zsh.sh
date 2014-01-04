# Check for updates on initial load...
if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
  /usr/bin/env ZSH=$ZSH DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT zsh $ZSH/tools/check_for_upgrade.sh
fi

# Initializes Oh My Zsh

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for config_file ($ZSH/lib/*.zsh); do
  source $config_file
done

# Set ZSH_CUSTOM to the path where your custom config files
# and plugins exists, or else we will use the default custom/
if [[ -z "$ZSH_CUSTOM" ]]; then
    ZSH_CUSTOM="$ZSH/custom"
fi


is_plugin() {
  local base_dir=$1
  local name=$2
  test -f $base_dir/plugins/$name/$name.plugin.zsh \
    || test -f $base_dir/plugins/$name/_$name
}
# Add all defined plugins to fpath. This must be done
# before running compinit.
for plugin ($plugins); do
  if is_plugin $ZSH_CUSTOM $plugin; then
    fpath=($ZSH_CUSTOM/plugins/$plugin $fpath)
  elif is_plugin $ZSH $plugin; then
    fpath=($ZSH/plugins/$plugin $fpath)
  fi
done

# Figure out the SHORT hostname
if [ -n "$commands[scutil]" ]; then
  # OS X
  SHORT_HOST=$(scutil --get ComputerName)
else
  SHORT_HOST=${HOST/.*/}
fi

# Save the location of the current completion dump file.
ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

# Load and run compinit
autoload -U compinit
compinit -i -d "${ZSH_COMPDUMP}"

# Load all of the plugins that were defined in ~/.zshrc
for plugin ($plugins); do
  if [ -f $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH_CUSTOM/plugins/$plugin/$plugin.plugin.zsh
  elif [ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load all of your custom configurations from custom/
for config_file ($ZSH_CUSTOM/*.zsh(N)); do
  source $config_file
done
unset config_file

# Sources ZSH_THEME
# Does nothing if ZSH_THEME is an empty string or unset
_source_zsh_theme() {
  if [ "$ZSH_THEME" = "random" ]; then
    themes=($ZSH/themes/*zsh-theme)
    N=${#themes[@]}
    ((N=(RANDOM%N)+1))
    RANDOM_THEME=${themes[$N]}
    source "$RANDOM_THEME"
    echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
  elif; then
    if [ ! "$ZSH_THEME" = ""  ]; then
      if [ -f "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme" ]; then
        source "$ZSH_CUSTOM/$ZSH_THEME.zsh-theme"
      elif [ -f "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme" ]; then
        source "$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"
      else
        source "$ZSH/themes/$ZSH_THEME.zsh-theme"
      fi
    fi
  fi
}

_default_theming() {
  echo "Falling back to default theming"
  # default prompt
  PS1="%n@%m:%~%# "

  # default variables for theming the git info prompt
  ZSH_THEME_GIT_PROMPT_PREFIX="git:("         # Prefix at the very beginning of the prompt, before the branch name
  ZSH_THEME_GIT_PROMPT_SUFFIX=")"             # At the very end of the prompt
  ZSH_THEME_GIT_PROMPT_DIRTY="*"              # Text to display if the branch is dirty
  ZSH_THEME_GIT_PROMPT_CLEAN=""               # Text to display if the branch is clean
}

# Tries to source a theme given as ZSH_THEME.
# If ZSH_THEME is not set, nothing is done at all. This is
# to enable users do circumvent the theming of oh-my-zsh
# on purpose.
# If ZSH_THEME contains an invalid theme string, a fallback
# is provided.
# Takes an argument to provide a new value fo ZSH_THEME
# before loading it.
# Example to load a random theme::
#   load_zsh_theme random
# Example to load whatever ZSH_THEME currently is:
#   load_zsh_theme
load_zsh_theme() {
  if [ ! "$1" = '' ]; then; ZSH_THEME="$1"; fi
  _source_zsh_theme || _default_theming
}

load_zsh_theme
