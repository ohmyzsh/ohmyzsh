export PAGER=less
export ZSH=$HOME/oh-my-zsh
export LC_CTYPE=en_US.UTF-8

# TODO: Refactor this sometimes soon...
source $ZSH/colors.zsh
source $ZSH/aliases.zsh
source $ZSH/completion.zsh
source $ZSH/rake_completion.zsh
source $ZSH/functions.zsh
source $ZSH/git.zsh
source $ZSH/history.zsh
source $ZSH/grep.zsh
source $ZSH/prompt.zsh

# Uncomment if you have a projects.zsh file
# source $ZSH/projects.zsh

# Directory stuff.

setopt AUTO_NAME_DIRS

# Speed stuff.

#setopt NO_BEEP
setopt AUTO_CD
setopt MULTIOS
setopt CDABLEVARS

# Customize to your needs...
export PATH=~/bin:/opt/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/local/sbin:/opt/local/lib/postgresql83/bin


