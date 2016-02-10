## Aliases

alias ds="dns search"                       # search package
alias dp="dns info"                         # show package info
alias dl="dns list"                         # list packages
alias dgl="dns group list"                   # list package groups
alias dli="dns list installed"              # print all installed packages
alias dmc="dns makecache"                   # rebuilds the yum package list

alias sdu="sudo dnf upgrade"                  # upgrate packages
alias sdi="sudo dnf install"                 # install package
alias sdgi="sudo dnf group install"           # install package group
alias sdr="sudo dnf remove"                  # remove package
alias sdgr="sudo dnf group remove"            # remove pagage group
alias sdrl="sudo dnf autoremove" # remove package and leaves
alias sdc="sudo dnf clean all"               # clean cache
