# Initializes Oh My Zsh
ZSH=${ZSH:-/usr/share/oh-my-zsh}
OMZ=${OMZ:-$HOME/.omz}

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

if [[ -d $OMZ ]]; then
  for config_file ($OMZ/*.zsh(N))
    source $config_file
fi

for plugin ($plugins)
  fpath=($ZSH/plugins/$plugin $fpath)

if [[ -d $OMZ ]]; then
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

local theme
zstyle -a :omz:style theme theme
set_theme $theme
