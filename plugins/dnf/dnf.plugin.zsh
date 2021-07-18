## Aliases

alias dnfl="dnf list"                       # List packages
alias dnfli="dnf list installed"            # List installed packages
alias dnfgl="dnf grouplist"                 # List package groups
alias dnfmc="dnf makecache"                 # Generate metadata cache
alias dnfp="dnf info"                       # Show package information
alias dnfs="dnf search"                     # Search package

alias dnfu="sudo dnf upgrade"               # Upgrade package
alias dnfi="sudo dnf install"               # Install package
alias dnfgi="sudo dnf groupinstall"         # Install package group
alias dnfr="sudo dnf remove"                # Remove package
alias dnfgr="sudo dnf groupremove"          # Remove package group
alias dnfuy="sudo dnf -y upgrade"           # Upgrade package answering "yes" automatically
alias dnfiy="sudo dnf -y install"           # Install package answering "yes" automatically
alias dnfgiy="sudo dnf -y groupinstall"     # Install package group answering "yes" automatically
alias dnfry="sudo dnf -y remove"            # Remove package answering "yes" automatically
alias dnfgry="sudo dnf -y groupremove"      # Remove package group answering "yes" automatically

alias dnfc="sudo dnf clean all"             # Clean cache
