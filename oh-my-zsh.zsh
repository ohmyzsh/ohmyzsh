# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  DISABLE_COLOR='true'
fi

# Add functions to fpath.
fpath=($OMZ/themes/*(/) $OMZ/plugins/${^plugins} $OMZ/functions $fpath)

# Load and initialize the completion system.
autoload -Uz compinit && compinit -i

# Source function files.
source "$OMZ/functions/init.zsh"

# Load all plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "$OMZ/plugins/$plugin/$plugin.plugin.zsh" ]]; then
    source "$OMZ/plugins/$plugin/$plugin.plugin.zsh"
  fi
done

# Set PATH for Mac OS X GUI applications (requires re-login).
if [[ "$OSTYPE" == darwin* ]]; then
  launchctl setenv PATH "$PATH" &!
fi

# Load and run the prompt theming system.
autoload -Uz promptinit && promptinit -i

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -f "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

