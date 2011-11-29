# Initializes Oh My Zsh
ZSH=${ZSH:-/usr/share/oh-my-zsh/}

local config_file plugin

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)
for config_file ($ZSH/lib/*.zsh) source $config_file
plugin=${plugin:=()}
for plugin ($plugins) fpath=($ZSH/plugins/$plugin $fpath)

if [[ -d ~/.omz ]]; then
  [[ -d ~/.omz/functions ]] && fpath=(~/.omz/functions $fpath)
  [[ -d ~/.omz/completion ]] && fpath=(~/.omz/completions $fpath)

  if [[ -d ~/.omz/lib ]]; then
    for config_file (~/.omz/lib/*.zsh) source $config_file
  fi

  if [[ -d ~/.omz/plugins ]]; then
    for plugin ($plugins) fpath=(~/.omz/plugins/$plugin $fpath)
  fi
fi

# load plugins
for plugin ($plugins); do
  if [[ -f ~/.omz/plugins/$plugin/$plugin.plugin.zsh ]]; then
    source ~/.omz/plugins/$plugin/$plugin.plugin.zsh
  elif [[ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

# Load and run compinit
autoload -U compinit
compinit -i

# Load the theme
if [ "$ZSH_THEME" = "random" ]
then
  themes=($ZSH/themes/*zsh-theme)
  N=${#themes[@]}
  ((N=(RANDOM%N)+1))
  RANDOM_THEME=${themes[$N]}
  source "$RANDOM_THEME"
  echo "[oh-my-zsh] Random theme '$RANDOM_THEME' loaded..."
else
  if [ ! "$ZSH_THEME" = ""  ]
  then
    source "$ZSH/themes/$ZSH_THEME.zsh-theme"
  fi
fi
