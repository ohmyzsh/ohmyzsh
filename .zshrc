# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
#ZSH_THEME="random"
#ZSH_THEME="azure"
ZSH_THEME="re5et"
#ZSH_THEME="fox"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias astyle="astyle --style=kr --convert-tabs --indent=spaces=4 --add-brackets \
--pad-header --unpad-paren --pad-oper --max-code-length=100 --formatted --align-pointer=type \
--align-reference=type -Y"
#alias eagle.py="eagle.py -f"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
#DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git-prompt git svn vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

if [[ -z $JAVA_HOME ]]; then
    export JAVA_HOME=/home/users/shiludeng/.jumbo/opt/sun-java6
fi
export HADOOP_INSTALL=/home/users/shiludeng/data/dev/hadoop/hadoop
#/home/tools/tools/maven/apache-maven-2.2.1/bin
export PATH=$HOME/programs/ccover/bin:$HOME/programs/bin/:$HOME/bin:$HADOOP_INSTALL/bin:/usr/local/bin:$PATH
source ~/.bash_profile
source ~/.bashrc
export MAC=64

# export MANPATH="/usr/local/man:$MANPATH"

hash -d weigou="/home/users/shiludeng/data/dev/app/ecom/weigou"
hash -d moviese="/home/users/shiludeng/data/dev/app/search/movie/user/se"
export SVN_EDITOR=vim
# You may need to manually set your language environment
#export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
setopt no_nomatch
