alias be="bundle exec"
alias bl="bundle list"
alias bp="bundle package"
alias bo="bundle open"
alias bu="bundle update"

# The following is based on https://github.com/gma/bundler-exec

bundled_commands=(annotate berks cap capify cucumber foodcritic foreman guard irb jekyll kitchen knife middleman nanoc puma rackup rainbows rake rspec ruby shotgun spec spin spork strainer tailor taps thin thor unicorn unicorn_rails)

# Remove $UNBUNDLED_COMMANDS from the bundled_commands list
for cmd in $UNBUNDLED_COMMANDS; do
  bundled_commands=(${bundled_commands#$cmd});
done

## Functions

bi() {
  if _bundler-installed && _within-bundled-project; then
    local bundler_version=`bundle version | cut -d' ' -f3`
    if [[ $bundler_version > '1.4.0' || $bundler_version = '1.4.0' ]]; then
      if [[ "$(uname)" == 'Darwin' ]]
      then
        local cores_num="$(sysctl hw.ncpu | awk '{print $2}')"
      else
        local cores_num="$(nproc)"
      fi
      bundle install --jobs=$cores_num $@
    else
      bundle install $@
    fi
  else
    echo "Can't 'bundle install' outside a bundled project"
  fi
}

_bundler-installed() {
  which bundle > /dev/null 2>&1
}

_within-bundled-project() {
  local check_dir=$PWD
  while [ $check_dir != "/" ]; do
    [ -f "$check_dir/Gemfile" ] && return
    check_dir="$(dirname $check_dir)"
  done
  false
}

_run-with-bundler() {
  if _bundler-installed && _within-bundled-project; then
    bundle exec $@
  else
    $@
  fi
}

## Main program
for cmd in $bundled_commands; do
  eval "function unbundled_$cmd () { $cmd \$@ }"
  eval "function bundled_$cmd () { _run-with-bundler $cmd \$@}"
  alias $cmd=bundled_$cmd

  if which _$cmd > /dev/null 2>&1; then
        compdef _$cmd bundled_$cmd=$cmd
  fi
done

