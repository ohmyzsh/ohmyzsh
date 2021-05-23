## Aliases

if [[ -n "$OLD_DNF" ]]; then
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
  alias dnfc="sudo dnf clean all"             # Clean cache
else
  alias d="dnf"
  alias dh="dnf -h"
  alias dl="dnf list"            # List packages
  alias dli="dnf list installed" # List installed packages
  alias dgl="dnf grouplist"      # List package groups
  alias dref="dnf makecache"     # Generate metadata cache
  alias dif="dnf info"           # Show package information
  alias dse="dnf search"         # Search package

  alias din="sudo dnf install" # Install package
  alias dgin="sudo dnf groupinstall" # Install package group
  alias drein="sudo dnf reinstall"
  alias ddl="sudo dnf download"

  alias dup="sudo dnf upgrade" # Upgrade package
  alias ddup="sudo dnf distro-sync"
  alias dcup="sudo dnf check-update"

  alias drm="sudo dnf remove"        # Remove package
  alias dgrm="sudo dnf groupremove"  # Remove package group
  alias dar="sudo dnf autoremove"

  alias dcall="sudo dnf clean all"   # Clean cache
  alias dshell="sudo dnf shell"
  alias dsdl="sudo dnf download --source"
fi
