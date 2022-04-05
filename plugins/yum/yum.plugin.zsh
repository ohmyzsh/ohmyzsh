## Aliases

alias ys="yum search"                       # search package
alias yp="yum info"                         # show package info
alias yl="yum list"                         # list packages
alias ygl="yum grouplist"                   # list package groups
alias yli="yum list installed"              # print all installed packages
alias ymc="yum makecache"                   # rebuilds the yum package list

<<<<<<< HEAD
alias yu="sudo yum update"                  # upgrate packages
=======
alias yu="sudo yum update"                  # upgrade packages
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
alias yi="sudo yum install"                 # install package
alias ygi="sudo yum groupinstall"           # install package group
alias yr="sudo yum remove"                  # remove package
alias ygr="sudo yum groupremove"            # remove pagage group
alias yrl="sudo yum remove --remove-leaves" # remove package and leaves
alias yc="sudo yum clean all"               # clean cache