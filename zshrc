# Path to your oh-my-zsh installation.
export ZSH=/Users/dony/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"
#ZSH_THEME="norm"
#ZSH_THEME='wedisagree'
#ZSH_THEME='lambda'

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

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git git-flow-completion docker)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#source ~/.git-flow-completion.zsh

fpath=(~/.zsh/go-completions $fpath)

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export WORKON_HOME=$HOME/.virtualenvs
source /usr/local/bin/virtualenvwrapper.sh


alias vim='mvim -v'
alias vi='mvim -v'

alias git="/usr/local/git/bin/git"
alias ga="/usr/local/git/bin/git add"
alias gc="/usr/local/git/bin/git commit"
alias gd="/usr/local/git/bin/git diff --word-diff --color "
# alias gd="/usr/local/git/bin/git diff --color"
alias ggd="/usr/local/git/bin/git difftool -y"
alias glog="/usr/local/git/bin/git log --graph --pretty=format:'%Cred%h%Creset - [%cN] %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gl="/usr/local/git/bin/git log --graph --pretty=format:'%Cred%h%Creset - [%cN] %C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gs="/usr/local/git/bin/git status"
alias gpl="/usr/local/git/bin/git pull"
alias gps="/usr/local/git/bin/git push"

# git flow alias
alias gfs="git flow feature start"
alias gff="git flow feature finish"

alias grs="git flow release start"
alias grf="git flow release finish"

alias ghs="git flow hotfix start"
alias ghf="git flow hotfix finish"

alias sshu="ssh ubuntu@10.8.8.7"
alias vidiff='mvimdiff -v'
alias vimdiff='mvimdiff -v'
alias gvim='mvim'
alias gvi='mvim'
alias gvidiff='mvimdiff'
alias gvimdiff='mvimdiff'


export VIM=""
export GOPATH=/Users/dony/project/go
