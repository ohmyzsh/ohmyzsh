if hash brew &> /dev/null && [ -f `brew --prefix`/etc/autojump ]; then
  . `brew --prefix`/etc/autojump
elif [ -f /opt/local/etc/profile.d/autojump.sh ]; then
  export FPATH="$FPATH:/opt/local/share/zsh/site-functions/"
  . /opt/local/etc/profile.d/autojump.sh
fi
