# Usage:
# Just add pip to your installed plugins.

# If you would like to change the cheeseshops used for autocomplete set
# ZSH_PIP_INDEXES in your zshrc. If one of your indexes are bogus you won't get
# any kind of error message, pip will just not autocomplete from them. Double
# check!
#
# If you would like to clear your cache, go ahead and do a
# "zsh-pip-clear-cache".

ZSH_PIP_CACHE_FILE=~/.pip/zsh-cache
ZSH_PIP_INDEXES=(https://pypi.python.org/simple/)

zsh-pip-clear-cache() {
  rm $ZSH_PIP_CACHE_FILE
  unset piplist
}

zsh-pip-cache-packages() {
  if [[ ! -d ${PIP_CACHE_FILE:h} ]]; then
      mkdir -p ${PIP_CACHE_FILE:h}
  fi

  if [[ ! -f $ZSH_PIP_CACHE_FILE ]]; then
      echo -n "(...caching package index...)"
      tmp_cache=/tmp/zsh_tmp_cache
      for index in $ZSH_PIP_INDEXES ; do
          # well... I've already got two problems
          curl $index 2>/dev/null | \
              sed -nr '/^<a href/ s/.*>([^<]+).*/\1/p' \
               >> $tmp_cache
      done
      sort $tmp_cache | uniq | tr '\n' ' ' > $ZSH_PIP_CACHE_FILE
      rm $tmp_cache
  fi
}
