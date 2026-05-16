## Aliases
local dnfprog="dnf"

# Prefer dnf5 if installed
command -v dnf5 > /dev/null && dnfprog=dnf5

alias dnfl="${dnfprog} list"                       # List packages
alias dnfli="${dnfprog} list installed"            # List installed packages
alias dnfmc="${dnfprog} makecache"                 # Generate metadata cache
alias dnfp="${dnfprog} info"                       # Show package information
alias dnfs="${dnfprog} search"                     # Search package

alias dnfu="sudo ${dnfprog} upgrade"               # Upgrade package
alias dnfi="sudo ${dnfprog} install"               # Install package
alias dnfr="sudo ${dnfprog} remove"                # Remove package
alias dnfc="sudo ${dnfprog} clean all"             # Clean cache

# Conditional aliases based on dnfprog value
if [[ "${dnfprog}" == "dnf5" ]]; then
    alias dnfgl="${dnfprog} group list"            # List package groups (dnf5)
    alias dnfgi="sudo ${dnfprog} group install"    # Install package group (dnf5)
    alias dnfgr="sudo ${dnfprog} group remove"     # Remove package group (dnf5)
else
    alias dnfgl="${dnfprog} grouplist"             # List package groups (dnf)
    alias dnfgi="sudo ${dnfprog} groupinstall"     # Install package group (dnf)
    alias dnfgr="sudo ${dnfprog} groupremove"      # Remove package group (dnf)
fi
