if (( ! $+commands[brew] )); then
  if [[ -n "$BREW_LOCATION" ]]; then
    if [[ ! -x "$BREW_LOCATION" ]]; then
      echo "[oh-my-zsh] $BREW_LOCATION is not executable"
      return
    fi
  elif [[ -x /opt/homebrew/bin/brew ]]; then
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

  # Only add Homebrew installation to PATH, MANPATH, and INFOPATH if brew is
  # not already on the path, to prevent duplicate entries. This aligns with
  # the behavior of the brew installer.sh post-install steps.
  eval "$("$BREW_LOCATION" shellenv)"
  unset BREW_LOCATION
fi

if [[ -z "$HOMEBREW_PREFIX" ]]; then
  # Maintain compatibility with potential custom user profiles, where we had
  # previously relied on always sourcing shellenv. OMZ plugins should not rely
  # on this to be defined due to out of order processing.
  export HOMEBREW_PREFIX="$(brew --prefix)"
fi

if [[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]]; then
  fpath+=("$HOMEBREW_PREFIX/share/zsh/site-functions")
fi

alias ba='brew autoremove'
alias bcfg='brew config'
alias bci='brew info --cask'
alias bcin='brew install --cask'
alias bcl='brew list --cask'
alias bcn='brew cleanup'
alias bco='brew outdated --cask'
alias bcrin='brew reinstall --cask'
alias bcubc='brew upgrade --cask && brew cleanup'
alias bcubo='brew update && brew outdated --cask'
alias bcup='brew upgrade --cask'
alias bdr='brew doctor'
alias bfu='brew upgrade --formula'
alias bi='brew install'
alias bl='brew list'
alias bo='brew outdated'
alias brewp='brew pin'
alias brewsp='brew list --pinned'
alias bs='brew search'
alias bsl='brew services list'
alias bsoff='brew services stop'
alias bsoffa='bsoff --all'
alias bson='brew services start'
alias bsona='bson --all'
alias bsr='brew services run'
alias bsra='bsr --all'
alias bu='brew update'
alias bubo='brew update && brew outdated'
alias bubu='bubo && bup'
alias bubug='bubo && bugbc'
alias bugbc='brew upgrade --greedy && brew cleanup'
alias bup='brew upgrade'
alias buz='brew uninstall --zap'

function brews() {
  local formulae="$(brew leaves | xargs brew deps --installed --for-each)"
  local casks="$(brew list --cask 2>/dev/null)"

  local blue="$(tput setaf 4)"
  local bold="$(tput bold)"
  local off="$(tput sgr0)"

  echo "${blue}==>${off} ${bold}Formulae${off}"
  echo "${formulae}" | sed "s/^\(.*\):\(.*\)$/\1${blue}\2${off}/"
  echo "\n${blue}==>${off} ${bold}Casks${off}\n${casks}"
}
