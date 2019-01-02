#########PLUGINS##########
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)
####PLUGINS CONFIGS#######
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=243'
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'
#####CONFIGURATIONS#######
DEFAULT_USER="raven"
eval `dircolors ~/.dircolors`
ZSH_DISABLE_COMPFIX=true
#####EXPORTS#######
export PATH=$HOME/bin:/usr/local/bin:$PATH
export TMPDIR='/mnt/c/Users/Nino/AppData/Local/Temp'
export EDITOR='nano'
#####OPTIONS#######
unsetopt BG_NICE
unsetopt BEEP
