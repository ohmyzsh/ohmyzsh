# Archlinux zsh aliases and functions
# Usage is also described at https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'        # Synchronize with repositories before upgrading packages that are out of date on the local system.
alias pacin='sudo pacman -S'           # Install specific package(s) from the repositories
alias pacins='sudo pacman -U'          # Install specific package not from the repositories but from a file
alias pacre='sudo pacman -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
alias pacrem='sudo pacman -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
alias pacrep='pacman -Si'              # Display information about a given package in the repositories
alias pacreps='pacman -Ss'             # Search for package(s) in the repositories
alias pacloc='pacman -Qi'              # Display information about a given package in the local database
alias paclocs='pacman -Qs'             # Search for package(s) in the local database
# Additional pacman alias examples
if [[ -x `which abs` ]]; then
  alias pacupd='sudo pacman -Sy && sudo abs'     # Update and refresh the local package and ABS databases against repositories
else
  alias pacupd='sudo pacman -Sy'     # Update and refresh the local package and ABS databases against repositories
fi
alias pacinsd='sudo pacman -S --asdeps'        # Install given package(s) as dependencies of another package
alias pacmir='sudo pacman -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

# https://bbs.archlinux.org/viewtopic.php?id=93683
paclist() {
  [[ -x $(which expac) ]] && expac "${fg[cyan]}%n${fg[green]}: ${reset_color}%d" || (
    pacman -Qqei|awk 'BEGIN {FS=": "}/^Name/{printf("\033[36m%s\033[32m:\033[37m ", $2)}/^Description/{print $2}' && \
    echo "Please install expac! Awk used with pacman -Qqei; expac is faster!" >&2
  )
}

pacdisowned() {
  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr \
      ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

  comm -23 "$fs" "$db"
}

asroot() {
  whence sudo &>/dev/null && sudo $@ || su -c "$@"
}

# pacman() {
  pacman_bin=${commands[pacman-color]:-/usr/bin/pacman}
#  case $1 in
#   -S | -S[^sihgl]* | -R* | -U*) asroot $pacman_bin $@ ;;
#   *) $pacman_bin "$@" ;;
#  esac
# }
