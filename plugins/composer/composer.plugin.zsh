#alias
if which composer.phar &> /dev/null; then
  if which composer &> /dev/null; then
  else
    alias composer="composer.phar"
  fi
else
  if which composer &> /dev/null; then
    alias composer.phar="composer"
  fi
fi
