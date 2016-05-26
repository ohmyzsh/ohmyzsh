## Aliases

alias dnfs="dnf search"                       # search package
alias dnfp="dnf info"                         # show package info
alias dnfl="dnf list"                         # list packages
alias dnfgl="dnf grouplist"                   # list package groups
alias dnfli="dnf list installed"              # print all installed packages
alias dnfmc="dnf makecache"                   # rebuilds the dnf package list

alias dnfu="sudo dnf upgrade"                 # upgrade packages
alias dnfi="sudo dnf install"                 # install package
alias dnfgi="sudo dnf groupinstall"           # install package group
alias dnfr="sudo dnf remove"                  # remove package
alias dnfgr="sudo dnf groupremove"            # remove pagage group
alias dnfrl="sudo dnf remove --remove-leaves" # remove package and leaves
alias dnfc="sudo dnf clean all"               # clean cache
