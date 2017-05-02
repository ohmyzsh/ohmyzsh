## Aliases

alias rs="dnf search"                       # search package
alias rp="dnf info"                         # show package info
alias rl="dnf list"                         # list packages
alias rgl="dnf grouplist"                   # list package groups
alias rli="dnf list installed"              # print all installed packages
alias rmc="dnf makecache"                   # rebuilds the yum package list

alias ru="sudo dnf update"                  # upgrate packages
alias ri="sudo dnf install"                 # install package
alias rgi="sudo dnf groupinstall"           # install package group
alias rr="sudo dnf remove"                  # remove package
alias rgr="sudo dnf groupremove"            # remove pagage group
alias rrl="sudo dnf remove --remove-leaves" # remove package and leaves
alias rc="sudo dnf clean all"               # clean cache
