<<<<<<< HEAD
# Archlinux zsh aliases and functions
# Usage is also described at https://github.com/robbyrussell/oh-my-zsh/wiki/Plugins

# Look for yaourt, and add some useful functions if we have it.
if [[ -x `command -v yaourt` ]]; then
  upgrade () {
    yaourt -Syu
  }
  alias yaconf='yaourt -C'        # Fix all configuration files with vimdiff
  # Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
  alias yaupg='yaourt -Syua'        # Synchronize with repositories before upgrading packages (AUR packages too) that are out of date on the local system.
  alias yasu='yaourt --sucre'      # Same as yaupg, but without confirmation
  alias yain='yaourt -S'           # Install specific package(s) from the repositories
  alias yains='yaourt -U'          # Install specific package not from the repositories but from a file
  alias yare='yaourt -R'           # Remove the specified package(s), retaining its configuration(s) and required dependencies
  alias yarem='yaourt -Rns'        # Remove the specified package(s), its configuration(s) and unneeded dependencies
  alias yarep='yaourt -Si'         # Display information about a given package in the repositories
  alias yareps='yaourt -Ss'        # Search for package(s) in the repositories
  alias yaloc='yaourt -Qi'         # Display information about a given package in the local database
  alias yalocs='yaourt -Qs'        # Search for package(s) in the local database
  alias yalst='yaourt -Qe'         # List installed packages, even those installed from AUR (they're tagged as "local")
  alias yaorph='yaourt -Qtd'       # Remove orphans using yaourt
  # Additional yaourt alias examples
  if [[ -x `command -v abs` && -x `command -v aur` ]]; then
    alias yaupd='yaourt -Sy && sudo abs && sudo aur'  # Update and refresh the local package, ABS and AUR databases against repositories
  elif [[ -x `command -v abs` ]]; then
    alias yaupd='yaourt -Sy && sudo abs'   # Update and refresh the local package and ABS databases against repositories
  elif [[ -x `command -v aur` ]]; then
    alias yaupd='yaourt -Sy && sudo aur'   # Update and refresh the local package and AUR databases against repositories
  else
    alias yaupd='yaourt -Sy'               # Update and refresh the local package database against repositories
  fi
  alias yainsd='yaourt -S --asdeps'        # Install given package(s) as dependencies of another package
  alias yamir='yaourt -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist
else
 upgrade() {
   sudo pacman -Syu
 }
fi

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
if [[ -x `command -v abs` && -x `command -v aur` ]]; then
  alias pacupd='sudo pacman -Sy && sudo abs && sudo aur'  # Update and refresh the local package, ABS and AUR databases against repositories
elif [[ -x `command -v abs` ]]; then
  alias pacupd='sudo pacman -Sy && sudo abs'              # Update and refresh the local package and ABS databases against repositories
elif [[ -x `command -v aur` ]]; then
  alias pacupd='sudo pacman -Sy && sudo aur'              # Update and refresh the local package and AUR databases against repositories
else
  alias pacupd='sudo pacman -Sy'     # Update and refresh the local package database against repositories
fi
alias pacinsd='sudo pacman -S --asdeps'        # Install given package(s) as dependencies of another package
alias pacmir='sudo pacman -Syy'                # Force refresh of all package lists after updating /etc/pacman.d/mirrorlist

# https://bbs.archlinux.org/viewtopic.php?id=93683
paclist() {
  LC_ALL=C pacman -Qei $(pacman -Qu|cut -d" " -f 1)|awk ' BEGIN {FS=":"}/^Name/{printf("\033[1;36m%s\033[1;37m", $2)}/^Description/{print $2}'
}

alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'

pacdisowned() {
=======
#######################################
#               Pacman                #
#######################################

# Pacman - https://wiki.archlinux.org/index.php/Pacman_Tips
alias pacupg='sudo pacman -Syu'
alias pacin='sudo pacman -S'
alias paclean='sudo pacman -Sc'
alias pacins='sudo pacman -U'
alias paclr='sudo pacman -Scc'
alias pacre='sudo pacman -R'
alias pacrem='sudo pacman -Rns'
alias pacrep='pacman -Si'
alias pacreps='pacman -Ss'
alias pacloc='pacman -Qi'
alias paclocs='pacman -Qs'
alias pacinsd='sudo pacman -S --asdeps'
alias pacmir='sudo pacman -Syy'
alias paclsorphans='sudo pacman -Qdt'
alias pacrmorphans='sudo pacman -Rs $(pacman -Qtdq)'
alias pacfileupg='sudo pacman -Fy'
alias pacfiles='pacman -F'
alias pacls='pacman -Ql'
alias pacown='pacman -Qo'
alias pacupd="sudo pacman -Sy"
alias upgrade='sudo pacman -Syu'

function paclist() {
  # Based on https://bbs.archlinux.org/viewtopic.php?id=93683
  pacman -Qqe | \
    xargs -I '{}' \
      expac "${bold_color}% 20n ${fg_no_bold[white]}%d${reset_color}" '{}'
}

function pacdisowned() {
  local tmp db fs
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
  db=$tmp/db
  fs=$tmp/fs

  mkdir "$tmp"
<<<<<<< HEAD
  trap  'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr \
      ! -name lost+found \
        \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"
=======
  trap 'rm -rf "$tmp"' EXIT

  pacman -Qlq | sort -u > "$db"

  find /bin /etc /lib /sbin /usr ! -name lost+found \
    \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

  comm -23 "$fs" "$db"
}

<<<<<<< HEAD
pacmanallkeys() {
  # Get all keys for developers and trusted users
  curl https://www.archlinux.org/{developers,trustedusers}/ |
  awk -F\" '(/pgp.mit.edu/) {sub(/.*search=0x/,"");print $1}' |
  xargs sudo pacman-key --recv-keys
}

pacmansignkeys() {
  for key in $*; do
=======
alias pacmanallkeys='sudo pacman-key --refresh-keys'

function pacmansignkeys() {
  local key
  for key in $@; do
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
    sudo pacman-key --recv-keys $key
    sudo pacman-key --lsign-key $key
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key $key
  done
}
<<<<<<< HEAD
=======

if (( $+commands[xdg-open] )); then
  function pacweb() {
    if [[ $# = 0 || "$1" =~ '--help|-h' ]]; then
      local underline_color="\e[${color[underline]}m"
      echo "$0 - open the website of an ArchLinux package"
      echo
      echo "Usage:"
      echo "    $bold_color$0$reset_color ${underline_color}target${reset_color}"
      return 1
    fi

    local pkg="$1"
    local infos="$(LANG=C pacman -Si "$pkg")"
    if [[ -z "$infos" ]]; then
      return
    fi
    local repo="$(grep -m 1 '^Repo' <<< "$infos" | grep -oP '[^ ]+$')"
    local arch="$(grep -m 1 '^Arch' <<< "$infos" | grep -oP '[^ ]+$')"
    xdg-open "https://www.archlinux.org/packages/$repo/$arch/$pkg/" &>/dev/null
  }
fi

#######################################
#             AUR helpers             #
#######################################

if (( $+commands[aura] )); then
  alias auin='sudo aura -S'
  alias aurin='sudo aura -A'
  alias auclean='sudo aura -Sc'
  alias auclr='sudo aura -Scc'
  alias auins='sudo aura -U'
  alias auinsd='sudo aura -S --asdeps'
  alias aurinsd='sudo aura -A --asdeps'
  alias auloc='aura -Qi'
  alias aulocs='aura -Qs'
  alias aulst='aura -Qe'
  alias aumir='sudo aura -Syy'
  alias aurph='sudo aura -Oj'
  alias aure='sudo aura -R'
  alias aurem='sudo aura -Rns'
  alias aurep='aura -Si'
  alias aurrep='aura -Ai'
  alias aureps='aura -As --both'
  alias auras='aura -As --both'
  alias auupd="sudo aura -Sy"
  alias auupg='sudo sh -c "aura -Syu              && aura -Au"'
  alias ausu='sudo sh -c "aura -Syu --no-confirm && aura -Au --no-confirm"'
  alias upgrade='sudo aura -Syu'

  # extra bonus specially for aura
  alias auown="aura -Qqo"
  alias auls="aura -Qql"
  function auownloc() { aura -Qi  $(aura -Qqo $@); }
  function auownls () { aura -Qql $(aura -Qqo $@); }
fi

if (( $+commands[pacaur] )); then
  alias pacclean='pacaur -Sc'
  alias pacclr='pacaur -Scc'
  alias paupg='pacaur -Syu'
  alias pasu='pacaur -Syu --noconfirm'
  alias pain='pacaur -S'
  alias pains='pacaur -U'
  alias pare='pacaur -R'
  alias parem='pacaur -Rns'
  alias parep='pacaur -Si'
  alias pareps='pacaur -Ss'
  alias paloc='pacaur -Qi'
  alias palocs='pacaur -Qs'
  alias palst='pacaur -Qe'
  alias paorph='pacaur -Qtd'
  alias painsd='pacaur -S --asdeps'
  alias pamir='pacaur -Syy'
  alias paupd="pacaur -Sy"
  alias upgrade='pacaur -Syu'
fi

if (( $+commands[trizen] )); then
  alias trconf='trizen -C'
  alias trupg='trizen -Syua'
  alias trsu='trizen -Syua --noconfirm'
  alias trin='trizen -S'
  alias trclean='trizen -Sc'
  alias trclr='trizen -Scc'
  alias trins='trizen -U'
  alias trre='trizen -R'
  alias trrem='trizen -Rns'
  alias trrep='trizen -Si'
  alias trreps='trizen -Ss'
  alias trloc='trizen -Qi'
  alias trlocs='trizen -Qs'
  alias trlst='trizen -Qe'
  alias trorph='trizen -Qtd'
  alias trinsd='trizen -S --asdeps'
  alias trmir='trizen -Syy'
  alias trupd="trizen -Sy"
  alias upgrade='trizen -Syu'
fi

if (( $+commands[yay] )); then
  alias yaconf='yay -Pg'
  alias yaclean='yay -Sc'
  alias yaclr='yay -Scc'
  alias yaupg='yay -Syu'
  alias yasu='yay -Syu --noconfirm'
  alias yain='yay -S'
  alias yains='yay -U'
  alias yare='yay -R'
  alias yarem='yay -Rns'
  alias yarep='yay -Si'
  alias yareps='yay -Ss'
  alias yaloc='yay -Qi'
  alias yalocs='yay -Qs'
  alias yalst='yay -Qe'
  alias yaorph='yay -Qtd'
  alias yainsd='yay -S --asdeps'
  alias yamir='yay -Syy'
  alias yaupd="yay -Sy"
  alias upgrade='yay -Syu'
fi
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
