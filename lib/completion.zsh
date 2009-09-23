## fixme - the load process here seems a bit bizarre

setopt noautomenu
setopt complete_in_word
setopt always_to_end

unsetopt flowcontrol

WORDCHARS=''

autoload -U compinit
compinit

zmodload -i zsh/complist

## case-insensitive (all),partial-word and then substring completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' hosts $( sed 's/[, ].*$//' $HOME/.ssh/known_hosts )

unsetopt MENU_COMPLETE
#setopt AUTO_MENU

# should this be in keybindings?
bindkey -M menuselect '^o' accept-and-infer-next-history

zstyle ':completion:*:*:*:*:*' menu yes select
# zstyle ':completion:*:*:*:*:processes' force-list always

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:*:(ssh|scp):*:*' hosts `sed 's/^\([^ ,]*\).*$/\1/' ~/.ssh/known_hosts`


#complete on history
# zstyle ':completion:*:history-words' stop yes
# zstyle ':completion:*:history-words' remove-all-dups yes
# zstyle ':completion:*:history-words' list false
# zstyle ':completion:*:history-words' menu yes