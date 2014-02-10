# Path to your oh-my-zsh configuration.
ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="my-robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
case `uname` in
    Darwin)
    plugins=(brew autojump osx xcode sublime git git-extras go redis-cli custom-aliases encode64 gem mercurial web-search zsh-syntax-highlighting);;
    Linux)
    plugins=(command-not-found archlinux git git-extras go redis-cli custom-aliases encode64 gem mercurial web-search zsh-syntax-highlighting);;
    *)
    plugins=(git git-extras go redis-cli custom-aliases encode64 gem mercurial web-search zsh-syntax-highlighting)
esac

source $ZSH/oh-my-zsh.sh

# User configuration

export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

[[ -s ~/.shared_profile.sh ]] && . ~/.shared_profile.sh

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

export LC_ALL=en_US.UTF-8
export LANG_ALL=en_US.UTF-8

[[ -s /usr/local/etc/autojump.sh ]] && . /usr/local/etc/autojump.sh

if [[ -s ~/.zsh-autosuggestions/autosuggestions.zsh ]]; then
    source ~/.zsh-autosuggestions/autosuggestions.zsh

    zle-line-init() {
        zle autosuggest-start
    }

    zle -N zle-line-init
fi

[[ -s ~/.zsh-history-substring-search/zsh-history-substring-search.zsh ]] && source ~/.zsh-history-substring-search/zsh-history-substring-search.zsh 
