if [ -e /etc/profile.d/autojump.zsh ]; then
  . /etc/profile.d/autojump.zsh
elif [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi
