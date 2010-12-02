#aliases
alias paci='sudo pacman -Syu' #works for both update and install
alias pacr='sudo pacman -R'   #delete packages
alias pacs='sudo pacman -Ss'  #search packages

#pacman completion
zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select
