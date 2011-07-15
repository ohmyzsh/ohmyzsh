# Initializes OH MY ZSH.

# Disable color in dumb terminals.
if [[ "$TERM" == 'dumb' ]]; then
  DISABLE_COLOR='true'
fi

# Add all defined plugins to fpath.
plugin=${plugin:=()}
for plugin in $plugins; do
  fpath=("$OMZ/plugins/$plugin" $fpath)
done

# Load and run compinit.
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

# Load the theme.
if [[ "$ZSH_THEME" == "random" ]]; then
  themes=($OMZ/themes/**/*.theme.zsh)
  theme_index=${#themes[@]}
  (( theme_index=((RANDOM % theme_index) + 1) ))
  random_theme="${themes[$theme_index]}"
  source "$random_theme"
else
  if [[ -f "$OMZ/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh" ]]; then
    source "$OMZ/themes/$ZSH_THEME/$ZSH_THEME.theme.zsh"
  fi
fi

# Compile zcompdump, if modified, to increase startup speed.
if [[ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" ]] || [[ ! -e "$HOME/.zcompdump.zwc" ]]; then
  zcompile "$HOME/.zcompdump"
fi

