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
plugins=(git2 python vim-override common-aliases zsh-syntax-highlighting jump coffee cp
         rsync git-remote-branch command-not-found debian dircycle encode64 lol extract common-aliases
         pip brew sublime grin pip)

source $ZSH/oh-my-zsh.sh
# User configuration
if [ -e $HOME/bin ]; then export PATH="$HOME/bin:$PATH"; fi
if [ -e /usr/local/bin ]; then export PATH="/usr/local/bin:$PATH"; fi

zstyle ':completion:*:descriptions' format '%B%d%b'
# Language configuration
if [ -z "$LC_ALL" ]; then export LC_ALL=en_US.UTF-8; fi
if [ -z "$LANG" ]; then export LANG=en_US.UTF-8; fi

# MacOSX specific aliases
alias bu='brew update && brew upgrade'

source $ZSH/oh-my-zsh.sh

# Enviroment variables overwrite
export EDITOR='vim'
export LESS='-RX'

unsetopt correctall

if [ -e ~/.profile ]; then source ~/.profile; fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
