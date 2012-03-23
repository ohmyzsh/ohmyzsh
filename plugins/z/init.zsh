#
# Maintains a frequently used directory list for fast directory changes.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if [[ -f /etc/profile.d/z.zsh ]]; then
  source /etc/profile.d/z.zsh
elif [[ -f /opt/local/etc/profile.d/z.zsh ]]; then
  source /opt/local/etc/profile.d/z.zsh
elif [[ -f "$(brew --prefix 2> /dev/null)/etc/profile.d/z.sh" ]]; then
  source "$(brew --prefix 2> /dev/null)/etc/profile.d/z.sh"
fi

if (( $+functions[_z] )); then
  alias z='nocorrect _z 2>&1'
  alias j='z'
  function z-precmd {
    z --add "$(pwd -P)"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook precmd z-precmd
fi

