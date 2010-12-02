#aliases
alias paci='pacman -Syu' #works for both update and install
alias pacr='pacman -R'   #delete packages
alias pacs='pacman -Ss'  #search packages

#pacman completion
zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select
