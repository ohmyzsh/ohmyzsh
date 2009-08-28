export PAGER=less
export ZSH=$HOME/oh-my-zsh
export LC_CTYPE=en_US.UTF-8

# Load all of the config files in ~/oh-my-zsh that end in .zsh
# TIP: Add files you don't want in git to .gitignore
for i in $ZSH/*zsh; do source $i; done;

# Directory stuff.

setopt AUTO_NAME_DIRS

# Speed stuff.

#setopt NO_BEEP
setopt AUTO_CD
setopt MULTIOS
setopt CDABLEVARS

# Customize to your needs...
export PATH=~/bin:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/sbin:/opt/local/lib/postgresql83/bin


