export DOTFILES=$HOME/.dotfiles
#:/usr/local/src:/go
# echo WELCOME!
# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH
export PATH=/usr/local/opt/gettext/bin:$PATH
export PATH=/usr/local/opt/bison/bin:$PATH
export PATH=$PATH:$DOTFILES/bin
export PATH=$PATH:$HOME/.iterm2

export GIT_SRCDIR=$GOPATH/src/github.com
mkdir -p ${GIT_SRCDIR}

export LDFLAGS="-L/usr/local/opt/bison/lib"
export CC=clang

if test "$(uname)" = "Darwin"; then
    /bin/launchctl setenv LIBRARY_PATH /usr/local/lib
    /bin/launchctl setenv CPATH /usr/local/include
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="agnoster"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="false"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# iterm2 for Mac OS
#source $DOTFILES/zsh/.iterm2_shell_integration.zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to $ZSH/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#plugins=(git zsh-git-prompt zsh-completions fasd systemd zsh-syntax-highlighting)
plugins=(git git-extras docker docker-compose docker-machine helm fast-syntax-highlighting zsh-git-prompt zsh-kubectl-prompt)

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' max-errors 3
zstyle ':completion:*' prompt 'e%e'
zstyle ':completion:*' squeeze-slashes true
zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
zmodload -i zsh/complist
rm -f ~/.zcompdump
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory autocd notify
bindkey -e
# End of lines configured by zsh-newuser-install

source $ZSH/oh-my-zsh.sh

# User configuration
for file in $DOTFILES/zsh/zsh_helpers/*.sh; do
    source $file
done

# bindkey
bindkey "kD" delete-char
bindkey "^?" backward-delete-char
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line

# export MANPATH="/usr/local/man:$MANPATH"

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

#lesspipe
export LESSOPEN="|/usr/local/bin/lesspipe.sh %s" LESS_ADVANCED_PREPROCESSOR=1

# ssh
export SSH_KEY_PATH="~/.ssh/id_rsa"

# github pat
export GITHUB_PAT=$(cat $HOME/.git/.pat)

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias f='find / 2>/dev/null'
alias t='top'
alias vb='virtualbox'
alias vm='VBoxManage'
alias vmls='VBoxManage list vms'
alias vmclo='VBoxManage clonevm'     ## <UUID> --name "Ubuntu 18.04 C"
alias vmreg='VBoxManage registervm'  ## ~/VirtualBox\ VMs/Ubuntu\ 18.04\ C/Ubuntu\ 18.04\ C.vbox
alias grep='grep --color=auto'
alias gck='git checkout'
alias sublime='/Applications/Sublime.app/Contents/MacOS/Sublime'
alias sl='sublime 2>/dev/null'
alias eclipse='~/eclipse/cpp-2018-09/eclipse/eclipse'
alias ec='eclipse  2>/dev/null'
alias ff='firefox 2>/dev/null'
alias ge='gedit 2>/dev/null'
# alias edit='atom'
alias ez="edit ~/.zshrc"
alias ezo="edit ~/.oh-my-zsh"
# alias ifconfig='/sbin/ifconfig'
source $DOTFILES/k8s/kubectl_helpers.sh
