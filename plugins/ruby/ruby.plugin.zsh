# Install local gems according to Mac OS X conventions.
if [[ "$OSTYPE" == darwin* ]]; then
  export GEM_HOME=$HOME/Library/Ruby/Gems/1.8
  export PATH=$GEM_HOME/bin:$PATH

  # gem is slow; cache its output.
  cache_file="${0:h}/cache.zsh"
  if [[ ! -f "$cache_file" ]]; then
    echo export GEM_PATH=$GEM_HOME:$(gem env gempath) >! "$cache_file"
    source "$cache_file"
  else
    source "$cache_file"
  fi
  unset cache_file
fi

