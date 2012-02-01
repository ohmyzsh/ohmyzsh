#
# Defines pacman aliases.
#
# Authors:
#   Benjamin Boudreau <dreurmail@gmail.com>
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Tips:
#   https://wiki.archlinux.org/index.php/Pacman_Tips
#

# Yaourt Aliases
if (( $+commands[yaourt] )); then
  # Upgrade Arch Linux.
  alias arch-upgrade='yaourt -Syu'

  # Fix all configuration files with vimdiff.
  alias yaconf='yaourt -C'

  # Synchronize with repositories before upgrading packages that are out of date on the local system.
  alias yaupg='yaourt -Syu'

  # Install specific package(s) from the repositories.
  alias yain='yaourt -S'

  # Install specific package(s) not from the repositories but from a file .
  alias yains='yaourt -U'

  # Remove the specified package(s), retaining its configuration(s) and required dependencies.
  alias yare='yaourt -R'

  # Remove the specified package(s), its configuration(s) and unneeded dependencies.
  alias yarem='yaourt -Rns'

  # Display information about a given package in the repositories.
  alias yarep='yaourt -Si'

  # Search for package(s) in the repositories.
  alias yareps='yaourt -Ss'

  # Display information about a given package in the local database.
  alias yaloc='yaourt -Qi'

  # Search for package(s) in the local database.
  alias yalocs='yaourt -Qs'

  # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
  alias yamir='yaourt -Syy'

  # Install given package(s) as dependencies of another package
  alias yainsd='yaourt -S --asdeps'

  # Update and refresh the local package and ABS databases against repositories.
  if (( $+commands[abs] )); then
    alias yaupd='yaourt -Sy && sudo abs'
  else
    alias yaupd='yaourt -Sy'
  fi
else
  # Upgrade Arch Linux.
  alias arch-upgrade='sudo pacman -Syu'
fi

# Pacman Aliases
# Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacupg='sudo pacman -Syu'

# Install specific package(s) from the repositories.
alias pacin='sudo pacman -S'

# Install specific package not from the repositories but from a file.
alias pacins='sudo pacman -U'

# Remove the specified package(s), retaining its configuration(s) and required dependencies.
alias pacre='sudo pacman -R'

# Remove the specified package(s), its configuration(s) and unneeded dependencies.
alias pacrem='sudo pacman -Rns'

# Display information about a given package in the repositories.
alias pacrep='pacman -Si'

# Search for package(s) in the repositories.
alias pacreps='pacman -Ss'

# Display information about a given package in the local database.
alias pacloc='pacman -Qi'

# Search for package(s) in the local database.
alias paclocs='pacman -Qs'

# Install given package(s) as dependencies of another package.
alias pacinsd='sudo pacman -S --asdeps'

# Force refresh of all package lists after updating /etc/pacman.d/mirrorlist.
alias pacmir='sudo pacman -Syy'

# List orphan packages(s).
alias paclsorphans='sudo pacman -Qdt'

# Remove orphan package(s).
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'

# Update and refresh the local package and ABS databases against repositories.
if (( $+commands[abs] )); then
  alias pacupd='sudo pacman -Sy && sudo abs'
else
  alias pacupd='sudo pacman -Sy'
fi

