# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  COLOR='false'
fi

# Add functions to fpath.
fpath=(
  ${0:h}/themes/*(/N)
  ${plugins:+${0:h}/plugins/${^plugins}}
  ${0:h}/functions
  ${0:h}/completions
  $fpath
)

# Load and initialize the completion system ignoring insecure directories.
autoload -Uz compinit && compinit -i

# Source files (the order matters).
source "${0:h}/helper.zsh"
source "${0:h}/environment.zsh"
source "${0:h}/terminal.zsh"
source "${0:h}/keyboard.zsh"
source "${0:h}/completion.zsh"
source "${0:h}/history.zsh"
source "${0:h}/directory.zsh"
source "${0:h}/alias.zsh"
source "${0:h}/spectrum.zsh"
source "${0:h}/utility.zsh"

# Source plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "${0:h}/plugins/$plugin/init.zsh" ]]; then
    source "${0:h}/plugins/$plugin/init.zsh"
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

