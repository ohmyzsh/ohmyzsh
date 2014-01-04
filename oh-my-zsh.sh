# Initialization script of oh-my-zsh
#
# Skip to the bottom of the file to see how oh-my-zsh loads
# its awesomeness at a single glance.

check_for_updates() {
  if [ "$DISABLE_AUTO_UPDATE" != "true" ]; then
    /usr/bin/env ZSH=$ZSH DISABLE_UPDATE_PROMPT=$DISABLE_UPDATE_PROMPT \
      zsh -f $ZSH/tools/check_for_upgrade.sh
  fi
}

# Resolves plugin names to their respective paths.
# If a custom plugin is defined, the default plugin
# won't be added to the plugin_paths.
find_plugin_paths() {
  ZSH_PLUGIN_PATHS=()
  local plugin
  local plugin_path
  local zsh_path

  for plugin ($plugins); do
    plugin_path="plugins/$plugin/$plugin.plugin.zsh"
    for zsh_path in $ZSH_CUSTOM $ZSH; do
      if [ -f "$zsh_path/$plugin_path" ]; then
        ZSH_PLUGIN_PATHS+="$zsh_path/$plugin_path"
        break
      fi
    done
  done
}

initialize_completions() {
  # Figure out the SHORT hostname
  if [ -n "$commands[scutil]" ]; then
    # OS X
    SHORT_HOST=$(scutil --get ComputerName)
  else
    SHORT_HOST=${HOST/.*/}
  fi

  # Save the location of the current completion dump file.
  ZSH_COMPDUMP="${ZDOTDIR:-${HOME}}/.zcompdump-${SHORT_HOST}-${ZSH_VERSION}"

  # plugins need to be added to the functions path before compinit
  fpath=($ZSH_PLUGIN_PATHS $fpath)

  autoload -U compinit
  compinit -i -d "${ZSH_COMPDUMP}"
}

source_files() {
  local file
  for file in $@; do
    source $file
  done
}

load_lib_files() { source_files $ZSH/lib/*.zsh }
load_plugins() { source_files $ZSH_PLUGIN_PATHS }
load_customizations() { source_files $ZSH_CUSTOM/*.zsh }

# Sources ZSH_THEME
# Does nothing if ZSH_THEME is an empty string or unset
_source_zsh_theme() {
  if [ "$ZSH_THEME" = "random" ]; then
    local themes
    local theme_name
    themes=($ZSH/themes/*zsh-theme)
    RANDOM_THEME=${themes[$RANDOM % ${#themes[@]}]}
    theme_name=$(basename $RANDOM_THEME .zsh-theme)

    source "$RANDOM_THEME"
    echo "[oh-my-zsh] Random theme '$theme_name' loaded..."
  elif [ ! "$ZSH_THEME" = ""  ]; then
    # custom themes take precedence over built-in themes!
    for zsh_path in $ZSH_CUSTOM $ZSH; do
      local theme_path="themes/$ZSH_THEME.zsh-theme"
      if [ -f "$zsh_path/$theme_path" ]; then
        source "$zsh_path/$theme_path"
        break
      fi
    done
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
# If ZSH_THEME is not set, nothing  is done at all. This is to enable
# users do circumvent the theming of oh-my-zsh on purpose.
# If ZSH_THEME contains an invalid theme string, a fallback is provided.
# Takes an argument to provide a new value fo ZSH_THEME before loading it.
# Example to load a random theme:
#   load_zsh_theme random
# Example to load whatever ZSH_THEME currently is:
#   load_zsh_theme
#
# A word of warning: The function doesn't clean up after itself - that means
# that if you load a theme that define a precmd and or zsh hooks (examples
# are pygmalion or pure) you will see remnants of their prompts if you load
# another theme on the fly. Just open a new shell and you're good again.
load_zsh_theme() {
  if [ ! "$1" = '' ]; then; ZSH_THEME="$1"; fi
  _source_zsh_theme || _default_theming
}

check_for_updates
find_plugin_paths
initialize_completions
load_lib_files
load_plugins
load_customizations
load_zsh_theme
