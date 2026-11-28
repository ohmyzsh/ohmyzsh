# Usage:
# Just add pip to your installed plugins.

# If you would like to change the cheeseshops used for autocomplete set
# ZSH_PIP_INDEXES in your zshrc. If one of your indexes are bogus you won't get
# any kind of error message, pip will just not autocomplete from them. Double
# check!
#
# If you would like to clear your cache, go ahead and do a
# "zsh-pip-clear-cache".

if [[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/pip" ]]; then
  ZSH_PIP_CACHE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/pip/zsh-cache"
else
  ZSH_PIP_CACHE_FILE=~/.pip/zsh-cache
fi
ZSH_PIP_INDEXES=(https://pypi.org/simple/)

zsh-pip-clear-cache() {
  rm $ZSH_PIP_CACHE_FILE
  unset piplist
}

zsh-pip-clean-packages() {
    sed -n '/<a href/ s/.*>\([^<]\{1,\}\).*/\1/p'
}

zsh-pip-cache-packages() {
  if [[ ! -d ${ZSH_PIP_CACHE_FILE:h} ]]; then
      mkdir -p ${ZSH_PIP_CACHE_FILE:h}
  fi

  if [[ ! -f $ZSH_PIP_CACHE_FILE ]]; then
      echo -n "(...caching package index...)"
      tmp_cache=/tmp/zsh_tmp_cache
      touch $tmp_cache
      for index in $ZSH_PIP_INDEXES ; do
          # well... I've already got two problems
          curl -L $index 2>/dev/null | \
              zsh-pip-clean-packages \
               >> $tmp_cache
      done
      sort $tmp_cache | uniq | tr '\n' ' ' > $ZSH_PIP_CACHE_FILE
      rm $tmp_cache
  fi
}

# A test function that validates the regex against known forms of the simple
# index. If you modify the regex to make it work for you, you should add a test
# case in here and make sure that your changes don't break things for someone
# else.
zsh-pip-test-clean-packages() {
    local expected
    local actual
    expected="0x10c-asm
1009558_nester"

    actual=$(echo -n "<html><head><title>Simple Index</title><meta name=\"api-version\" value=\"2\" /></head><body>
<a href='0x10c-asm'>0x10c-asm</a><br/>
<a href='1009558_nester'>1009558_nester</a><br/>
</body></html>" | zsh-pip-clean-packages)

    if [[ $actual != $expected ]] ; then
        echo -e "python's simple index is broken:\n$actual\n  !=\n$expected"
    else
        echo "python's simple index is fine"
    fi

    actual=$(echo -n '<html>
  <head>
    <title>Simple Package Index</title>
  </head>
  <body>
    <a href="0x10c-asm">0x10c-asm</a><br/>
    <a href="1009558_nester">1009558_nester</a><br/>
</body></html>' | zsh-pip-clean-packages)

    if [[ $actual != $expected ]] ; then
        echo -e "the djangopypi2 index is broken:\n$actual\n  !=\n$expected"
    else
        echo "the djangopypi2 index is fine"
    fi
}

if (( $+commands[pip3] && !$+commands[pip] )); then
  alias pip="noglob pip3"
else
  alias pip="noglob pip"
fi

alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipun="pip uninstall"
alias pipgi="pip freeze | grep"
alias piplo="pip list -o"

# Create requirements file
alias pipreq="pip freeze > requirements.txt"

# Install packages from requirements file
alias pipir="pip install -r requirements.txt"

# Upgrade all installed packages
function pipupall {
  # non-GNU xargs does not support nor need `--no-run-if-empty`
  local xargs="xargs --no-run-if-empty"
  xargs --version 2>/dev/null | grep -q GNU || xargs="xargs"
  pip list --outdated | awk 'NR > 2 { print $1 }' | ${=xargs} pip install --upgrade
}

# Uninstall all installed packages
function pipunall {
  # non-GNU xargs does not support nor need `--no-run-if-empty`
  local xargs="xargs --no-run-if-empty"
  xargs --version 2>/dev/null | grep -q GNU || xargs="xargs"
  pip list --format freeze | cut -d= -f1 | ${=xargs} pip uninstall
}

# Install from GitHub repository
function pipig {
  pip install "git+https://github.com/$1.git"
}
compdef _pip pipig

# Install from GitHub branch
function pipigb {
  pip install "git+https://github.com/$1.git@$2"
}
compdef _pip pipigb

# Install from GitHub pull request
function pipigp {
  pip install "git+https://github.com/$1.git@refs/pull/$2/head"
}
compdef _pip pipigp
