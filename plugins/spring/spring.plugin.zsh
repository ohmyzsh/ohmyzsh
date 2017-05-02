spring_commands=(rails rake rspec)

_spring_installed() {
  which spring > /dev/null 2>&1
}

_within_springified_rails_project() {
  local check_dir=$PWD
  while [ $check_dir != "/" ]; do
    [ -f "$check_dir/bin/spring" ] && return
    check_dir="$(dirname $check_dir)"
  done
  false
}

_run_with_spring() {
  if _spring_installed && _within_springified_rails_project; then
    spring $@
  else
    $@
  fi
}

for cmd in $spring_commands; do
  eval "function springified_$cmd () { _run_with_spring $cmd \$@}"
  alias $cmd=springified_$cmd

  if which _$cmd > /dev/null 2>&1; then
    compdef _$cmd springified_$cmd=$cmd
  fi
done
