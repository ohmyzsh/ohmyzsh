# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  COLOR='false'
fi

# Add functions to fpath.
fpath=(
  $OMZ/themes/*(/N)
  ${plugins:+$OMZ/plugins/${^plugins}}
  $OMZ/functions
  $fpath
)

# Load and initialize the completion system ignoring insecure directories.
autoload -Uz compinit && compinit -i

# Source files (the order matters).
source "$OMZ/helper.zsh"
source "$OMZ/environment.zsh"
source "$OMZ/terminal.zsh"
source "$OMZ/keyboard.zsh"
source "$OMZ/completion.zsh"
source "$OMZ/history.zsh"
source "$OMZ/directory.zsh"
source "$OMZ/alias.zsh"
source "$OMZ/spectrum.zsh"
source "$OMZ/utility.zsh"

# Source plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "$OMZ/plugins/$plugin/init.zsh" ]]; then
    source "$OMZ/plugins/$plugin/init.zsh"
  fi
done
unset plugin
unset plugins

# Set environment variables for launchd processes.
if [[ "$OSTYPE" == darwin* ]]; then
  launchctl setenv PATH "$PATH" &!
fi

# Load and run the prompt theming system.
autoload -Uz promptinit && promptinit

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -f "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

