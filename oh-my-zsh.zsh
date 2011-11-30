# Initializes Oh My Zsh
ZSH=${ZSH:-/usr/share/oh-my-zsh}
OMZ=$HOME/.zsh

local config_file plugin
plugin=${plugin:=()}

# add a function path
fpath=($ZSH/functions $ZSH/completions $fpath)

if [[ -d $OMZ ]]; then
  [[ -d $OMZ/functions ]] && fpath=($OMZ/functions $fpath)
  [[ -d $OMZ/completion ]] && fpath=($OMZ/completions $fpath)
fi

for config_file ($ZSH/lib/*.zsh(N))
  source $config_file

if [[ -d ~/.omz ]]; then
  for config_file ($OMG/*.zsh(N))
    source $config_file
fi

for plugin ($plugins)
  fpath=($ZSH/plugins/$plugin $fpath)

if [[ -d ~/.omz ]]; then
  if [[ -d $OMZ/plugins ]]; then
    for plugin ($plugins)
      fpath=($OMZ/plugins/$plugin $fpath)
  fi
fi

# Load and run compinit
autoload -U compinit
compinit -i

# load plugins
for plugin ($plugins); do
  if [[ -f $OMZ/plugins/$plugin/$plugin.plugin.zsh ]]; then
    source $OMZ/plugins/$plugin/$plugin.plugin.zsh
  elif [[ -f $ZSH/plugins/$plugin/$plugin.plugin.zsh ]]; then
    source $ZSH/plugins/$plugin/$plugin.plugin.zsh
  fi
done

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
