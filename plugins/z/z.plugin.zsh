if [ -f `brew --prefix`/etc/profile.d/z.sh ]; then
  . `brew --prefix`/etc/profile.d/z.sh
  function precmd () {
    z --add "$(pwd -P)"
  }
fi
