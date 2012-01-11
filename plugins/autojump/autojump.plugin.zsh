if [ -f /usr/share/autojump/autojump.zsh ] ; then
  . /usr/share/autojump/autojump.zsh
elif [ -f /opt/local/etc/profile.d/autojump.sh ]; then
  . /opt/local/etc/profile.d/autojump.sh
elif [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
fi
