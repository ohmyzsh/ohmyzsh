## Aliases
local dnfprog="dnf"

# Prefer dnf5 if installed
command -v dnf5 > /dev/null && dnfprog=dnf5

alias dnfl="${dnfprog} list"                       # List packages
alias dnfli="${dnfprog} list installed"            # List installed packages
alias dnfgl="${dnfprog} grouplist"                 # List package groups
alias dnfmc="${dnfprog} makecache"                 # Generate metadata cache
alias dnfp="${dnfprog} info"                       # Show package information
alias dnfs="${dnfprog} search"                     # Search package

alias dnfu="sudo ${dnfprog} upgrade"               # Upgrade package
alias dnfi="sudo ${dnfprog} install"               # Install package
alias dnfgi="sudo ${dnfprog} groupinstall"         # Install package group
alias dnfr="sudo ${dnfprog} remove"                # Remove package
alias dnfgr="sudo ${dnfprog} groupremove"          # Remove package group
alias dnfc="sudo ${dnfprog} clean all"             # Clean cache
