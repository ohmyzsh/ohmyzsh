if [ -f /usr/share/autojump/autojump.zsh ]; then # debian and ubuntu package
  . /usr/share/autojump/autojump.zsh
elif [ -f /etc/profile.d/autojump.zsh ]; then # manual installation
  . /etc/profile.d/autojump.zsh
elif (`command -v brew >/dev/null`); then # mac os x with brew
  if [ -f `brew --prefix`/etc/autojump ]; then
    . `brew --prefix`/etc/autojump
  fi
fi
