# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="lust"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true" # yes yes yes

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git cp osx history zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# Thankfully the path that is already present is the one that the system has set according to
# normal practices. This inserts a few more things that I use from the shell.
export PATH=~/bin:~/util:$PATH:/usr/local/share/npm/bin
# export PAGER=vimpager

# zmodload zsh/complist
# bindkey -M menuselect ' ' accept-and-infer-next-history
# bindkey -M menuselect '^?' undo

# vim mode. I'm ready for it.
bindkey -v
bindkey "^H" backward-kill-word
bindkey "^?" backward-delete-char
bindkey "^U" backward-kill-line
# must bind all kind of shit for gettind the damn control keys right now...
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;3D" vi-backward-word # alt
bindkey "^[[1;3C" vi-forward-word-end # alt
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
# bindkey "^[[2~" Thsi should run tmux ctrl a ] to paste copy buffer
bindkey "^[[3~" delete-char
bindkey "^[[5~" up-line-or-search
bindkey "^[[6~" down-line-or-search
bindkey -M vicmd "F10" vi-cmd-mode
# bindkey -m vicmd "F10"  this should run a widget that runs tmux to switch pane (Note the semantics are reversed; by default the shell should be in insert mode)
bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

stty -ixon
stty -ixoff
source $ZSH/plugins/history-substring-search/history-substring-search.plugin.zsh

export HISTSIZE=20000
export SAVEHIST=200000

function zshaddhistory() {
    COMMAND_STR=${1%%$'\n'}
    [[ ( -z $COMMAND_STR ) || ( $COMMAND_STR == history ) || \
        ( $COMMAND_STR =~ ^l(s\|l\|a)?$ ) || \
        ( $COMMAND_STR =~ ^(d\|gd\|git\ diff\|glp\|gg)$ ) \
    ]] && return 1
    print -sr "${PWD}///; ${COMMAND_STR}"
    fc -p
}

alias l="ls"
alias gs="git s" # short status 
alias glp="git log -p --no-ext-diff"
alias gdt="git difftool"
alias gd="git diff --no-ext-diff"
alias gdc="gd --cached"
alias gg="git lg"
alias gcm="git commit -am"
alias mk="make"

alias ds="dirs -v | head -10"
alias d="gd"

echo "Finished loading my .zshrc"
