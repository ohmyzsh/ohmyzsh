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
alias pacupd='sudo pacman -Sy'

function paclist() {
  emulate -L zsh -o extendedglob

  local line
  local -A info
  while IFS= read -r line; do
    [[ $line == (#b)(Name|Version|Description)[[:space:]]#:[[:space:]]#(*) ]] || continue
    info[$match[1]]=$match[2]

    [[ $match[1] == Description ]] || continue
    print -r -- "local/${info[Name]} ${info[Version]}"
    print -r -- "    ${info[Description]}"
  done < <(LANG=C pacman -Qei)
}

function pacdisowned() {
  emulate -L zsh

  LC_ALL=C comm -23 \
    <(find /etc /usr ! -name lost+found \
      \( -type d -printf '%p/\n' -o -print \) | LC_ALL=C sort) \
    <(pacman -Qlq | LC_ALL=C sort -u)
}

alias pacmanallkeys='sudo pacman-key --refresh-keys'

function pacmansignkeys() {
  local key
  for key in "$@"; do
    sudo pacman-key --recv-keys "$key"
    sudo pacman-key --lsign-key "$key"
    printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
      --no-permission-warning --command-fd 0 --edit-key "$key"
  done
}

if (( $+commands[xdg-open] )); then
  function pacweb() {
    emulate -L zsh -o extendedglob

    if (( $# == 0 )) || [[ $1 == --help || $1 == -h ]]; then
      local underline_color="\e[${color[underline]}m"
      echo "$0 - open the website of an ArchLinux package"
      echo
      echo "Usage:"
      echo "    $bold_color$0$reset_color ${underline_color}target${reset_color}"
      return 1
    fi

    local pkg info_output line repo arch
    local -A info

    pkg=$1
    info_output=$(LANG=C pacman -Si "$pkg") || return

    while IFS= read -r line; do
      [[ $line == (#b)([^:]##[^[:space:]])[[:space:]]#:[[:space:]]#(*) ]] || continue
      info[$match[1]]=$match[2]
    done <<< "$info_output"

    repo=${info[Repository]:-${info[Repo]}}
    arch=${info[Architecture]:-${info[Arch]}}
    [[ -n $repo && -n $arch ]] || return 1
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
  alias auupd='sudo aura -Sy'
  alias auupg='sudo sh -c "aura -Syu && aura -Au"'
  alias ausu='sudo sh -c "aura -Syu --no-confirm && aura -Au --no-confirm"'

  # extra bonus specially for aura
  alias auown='aura -Qqo'
  alias auls='aura -Qql'
  function auownloc() {
    local -a pkgs
    pkgs=("${(@f)$(aura -Qqo "$@")}") || return
    aura -Qi "${pkgs[@]}"
  }
  function auownls() {
    local -a pkgs
    pkgs=("${(@f)$(aura -Qqo "$@")}") || return
    aura -Qql "${pkgs[@]}"
  }
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
  alias paupd='pacaur -Sy'
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
  alias trupd='trizen -Sy'
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
  alias yaupd='yay -Sy'
fi

# Check Arch Linux PGP Keyring before System Upgrade to prevent failure.
function upgrade() {
  emulate -L zsh -o extendedglob

  local installedver line
  local -A info
  local -a upgrade_cmd=(sudo pacman -Su)

  sudo pacman -Sy
  echo ":: Checking Arch Linux PGP Keyring..."

  installedver=$(pacman -Q archlinux-keyring 2>/dev/null)
  installedver=${installedver#archlinux-keyring }

  while IFS= read -r line; do
    [[ $line == (#b)([^:]##[^[:space:]])[[:space:]]#:[[:space:]]#(*) ]] || continue
    info[$match[1]]=$match[2]
  done < <(LANG=C pacman -Si archlinux-keyring)

  if [[ $installedver != "${info[Version]}" ]]; then
    echo " Arch Linux PGP Keyring is out of date."
    echo " Updating before full system upgrade."
    sudo pacman -S --needed --noconfirm archlinux-keyring
  else
    echo " Arch Linux PGP Keyring is up to date."
    echo " Proceeding with full system upgrade."
  fi

  if (( $+commands[yay] )); then
    upgrade_cmd=(yay -Su)
  elif (( $+commands[trizen] )); then
    upgrade_cmd=(trizen -Su)
  elif (( $+commands[pacaur] )); then
    upgrade_cmd=(pacaur -Su)
  elif (( $+commands[aura] )); then
    upgrade_cmd=(sudo aura -Su)
  fi

  "${upgrade_cmd[@]}"
}
