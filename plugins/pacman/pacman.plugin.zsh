# Archlinux ZSH Aliases and Functions
#
# Pacman Tips:
#   https://wiki.archlinux.org/index.php/Pacman_Tips

# Yaourt Aliases
if (( $+commands[yaourt] )); then
  function arch-upgrade() {
    yaourt -Syu
  }

  alias yaconf='yaourt -C'             # Fix all configuration files with vimdiff.
  alias yaupg='yaourt -Syu'            # Synchronize with repositories before upgrading packages that are out of date on the local system.
  alias yain='yaourt -S'               # Install specific package(s) from the repositories.
  alias yains='yaourt -U'              # Install specific package(s) not from the repositories but from a file .
  alias yare='yaourt -R'               # Remove the specified package(s), retaining its configuration(s) and required dependencies.
  alias yarem='yaourt -Rns'            # Remove the specified package(s), its configuration(s) and unneeded dependencies.
  alias yarep='yaourt -Si'             # Display information about a given package in the repositories.
  alias yareps='yaourt -Ss'            # Search for package(s) in the repositories.
  alias yaloc='yaourt -Qi'             # Display information about a given package in the local database.
  alias yalocs='yaourt -Qs'            # Search for package(s) in the local database.
  alias yamir='yaourt -Syy'            # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
  alias yainsd='yaourt -S --asdeps'    # Install given package(s) as dependencies of another package

  # Update and refresh the local package and ABS databases against repositories.
  if (( $+commands[abs] )); then
    alias yaupd='yaourt -Sy && sudo abs'
  else
    alias yaupd='yaourt -Sy'
  fi
else
  function arch-upgrade() {
    sudo pacman -Syu
  }
fi

# Pacman Aliaases
alias pacupg='sudo pacman -Syu'                         # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin='sudo pacman -S'                            # Install specific package(s) from the repositories.
alias pacins='sudo pacman -U'                           # Install specific package not from the repositories but from a file.
alias pacre='sudo pacman -R'                            # Remove the specified package(s), retaining its configuration(s) and required dependencies.
alias pacrem='sudo pacman -Rns'                         # Remove the specified package(s), its configuration(s) and unneeded dependencies.
alias pacrep='pacman -Si'                               # Display information about a given package in the repositories.
alias pacreps='pacman -Ss'                              # Search for package(s) in the repositories.
alias pacloc='pacman -Qi'                               # Display information about a given package in the local database.
alias paclocs='pacman -Qs'                              # Search for package(s) in the local database.
alias pacinsd='sudo pacman -S --asdeps'                 # Install given package(s) as dependencies of another package.
alias pacmir='sudo pacman -Syy'                         # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist.
alias paclsorphans='sudo pacman -Qdt'                   # List orphan packages(s).
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'    # Remove orphan package(s).

# Update and refresh the local package and ABS databases against repositories.
if (( $+commands[abs] )); then
  alias pacupd='sudo pacman -Sy && sudo abs'
else
  alias pacupd='sudo pacman -Sy'
fi

# List explicitly installed packages.
function paclist() {
  sudo pacman -Qei $(pacman -Qu|cut -d" " -f 1) \
    | awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

# List disowned files.
function pacdisowned() {
  tmp="${TMPDIR-/tmp}/pacman-disowned-$UID-$$"
  db="$tmp/db"
  fs="$tmp/fs"

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr \
    ! -name lost+found \
      \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

