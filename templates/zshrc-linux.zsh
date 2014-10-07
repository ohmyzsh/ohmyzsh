# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="stibbons"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Virtualenvwrapper plugin - Disable directory name discovery
DISABLE_VENV_CD="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git2 python repo intel-repo cp buildbot rsync git-extras git-remote-branch\
         command-not-found debian dircycle encode64 lol extract launch_trial \
         vim-scp ufw sublime pylint pep8 autopep8 \
         common-aliases buildbot_dev zsh-syntax-highlighting \
         txw jump grin pip)

source $ZSH/oh-my-zsh.sh


ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

# To differentiate aliases from other command types
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'

# To have paths colored instead of underline
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan'

# To disable highlighting of globbing expressions
ZSH_HIGHLIGHT_STYLES[globbing]='none'

zstyle ':completion:*:descriptions' format '%B%d%b'

if [ -e $HOME/bin ]; then export PATH="$HOME/bin:$PATH"; fi
if [ -e $HOME/.local/bin ]; then export PATH="$HOME/.local/bin:$PATH"; fi
if [ -e $HOME/appengine ]; then export PATH="$HOME/appengine:$PATH"; fi
if [ -e $HOME/.cabal/bin ]; then export PATH="$HOME/.cabal/bin:$PATH"; fi
#
if [ -z "$LC_ALL" ]; then export LC_ALL=en_US.UTF-8; fi
if [ -z "$LANG" ]; then export LANG=en_US.UTF-8; fi

# source .profile is any (proxy settings,...)
[ -f $HOME/.profile ] && source $HOME/.profile

[ "$TERM" = "xterm" ] && TERM="xterm-256color"

source $ZSH/oh-my-zsh.sh

# Enviroment variables overwrite
export EDITOR='vim'
export LESS='-RX'

unsetopt correctall
