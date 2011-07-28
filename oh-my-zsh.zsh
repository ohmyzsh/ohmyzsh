# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  DISABLE_COLOR='true'
fi

# Add functions to fpath.
fpath=($OMZ/themes/*(/) $OMZ/plugins/${^plugins} $OMZ/functions $fpath)

# Load and initialize the completion system.
autoload -Uz compinit && compinit -i

# Load all files in $OMZ/oh-my-zsh/lib/ that end in .zsh.
for function_file in $OMZ/functions/*.zsh; do
  source "$function_file"
done

# Load all plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "$OMZ/plugins/$plugin/$plugin.plugin.zsh" ]]; then
    source "$OMZ/plugins/$plugin/$plugin.plugin.zsh"
  fi
done

# Load and run the prompt theming system.
autoload -Uz promptinit && promptinit -i

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -e "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

