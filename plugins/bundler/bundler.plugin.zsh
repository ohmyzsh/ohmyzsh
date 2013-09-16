alias be="bundle exec"
alias bl="bundle list"
alias bp="bundle package"
alias bo="bundle open"
alias bu="bundle update"

if [[ "$(uname)" == 'Darwin' ]]
then
  local cores_num="$(sysctl hw.ncpu | awk '{print $2}')"
else
  local cores_num="$(nproc)"
fi
eval "alias bi='bundle install --jobs=$cores_num'"

# The following is based on https://github.com/gma/bundler-exec

bundled_commands=(annotate berks cap capify cucumber foodcritic foreman guard jekyll kitchen knife middleman nanoc rackup rainbows rake rspec ruby shotgun spec spin spork strainer tailor thin thor unicorn unicorn_rails puma)

## Functions

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

