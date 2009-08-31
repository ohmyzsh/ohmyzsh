# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="robbyrussell"
export ZSH_THEME="geoffgarside"

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for i in $ZSH/*zsh; do source $i; done;

# Customize to your needs...
#export PATH=~/bin:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/sbin:/opt/local/lib/postgresql83/bin
export PATH=$PATH:$HOME/bin

