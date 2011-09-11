if [[ -f /etc/profile.d/autojump.zsh ]]; then
  source /etc/profile.d/autojump.zsh
elif [[ -f /opt/local/etc/profile.d/autojump.zsh ]]; then
  source /opt/local/etc/profile.d/autojump.zsh
elif [[ -f "$(brew --prefix 2> /dev/null)/etc/autojump.zsh" ]]; then
  source "$(brew --prefix)/etc/autojump.zsh"
fi

