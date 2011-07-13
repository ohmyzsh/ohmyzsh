# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  DISABLE_COLOR='true'
fi

# Load all files in $ZSH/oh-my-zsh/lib/ that end in .zsh.
for config_file in $ZSH/lib/*.zsh; do
  source "$config_file"
done

# Add all defined plugins to fpath.
plugin=${plugin:=()}
for plugin in $plugins; do
  fpath=($ZSH/plugins/$plugin $fpath)
done

# Load and run compinit.
autoload -U compinit
compinit -i

# Load all plugins defined in ~/.zshrc.
for plugin in $plugins; do
  if [[ -f "$ZSH/plugins/$plugin/$plugin.plugin.zsh" ]]; then
    source "$ZSH/plugins/$plugin/$plugin.plugin.zsh"
  fi
done

# Load the theme.
if [[ "$ZSH_THEME" == "random" ]]; then
  themes=($ZSH/themes/**/*.theme.zsh)
  theme_index=${#themes[@]}
  (( theme_index=((RANDOM % theme_index) + 1) ))
  random_theme="${themes[$theme_index]}"
  source "$random_theme"
else
  if [[ -f "$ZSH/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh" ]]; then
    source "$ZSH/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh"
  fi
fi

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -e "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

