if (( ! $+commands[brew] )); then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    BREW_LOCATION="/opt/homebrew/bin/brew"
  elif [[ -x /usr/local/bin/brew ]]; then
    BREW_LOCATION="/usr/local/bin/brew"
  elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
    BREW_LOCATION="/home/linuxbrew/.linuxbrew/bin/brew"
  elif [[ -x "$HOME/.linuxbrew/bin/brew" ]]; then
    BREW_LOCATION="$HOME/.linuxbrew/bin/brew"
  else
    return
  fi
fi

if [[ -z "$HOMEBREW_PREFIX" ]]; then
  if [[ -z $BREW_LOCATION ]]; then
    eval "$(brew shellenv)"
  else
    eval "$("$BREW_LOCATION" shellenv)"
  fi
fi

unset BREW_LOCATION

alias bcubc='brew upgrade --cask && brew cleanup'
alias bcubo='brew update && brew outdated --cask'
alias brewp='brew pin'
alias brewsp='brew list --pinned'
alias bubc='brew upgrade && brew cleanup'
alias bubo='brew update && brew outdated'
alias bubu='bubo && bubc'
alias buf='brew upgrade --formula'

function brews() {
  local formulae="$(brew leaves | xargs brew deps --installed --for-each)"
  local casks="$(brew list --cask)"

  local blue="$(tput setaf 4)"
  local bold="$(tput bold)"
  local off="$(tput sgr0)"

  echo "${blue}==>${off} ${bold}Formulae${off}"
  echo "${formulae}" | sed "s/^\(.*\):\(.*\)$/\1${blue}\2${off}/"
  echo "\n${blue}==>${off} ${bold}Casks${off}\n${casks}"
}
