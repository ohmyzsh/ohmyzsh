# The version of the format of .rake_tasks. If the output of _rake_generate
# changes, incrementing this number will force it to regenerate
_rake_tasks_version=2

_rake_refresh () {
  if [ -f .rake_tasks ]; then
    rm .rake_tasks
  fi
  echo "Generating .rake_tasks..." > /dev/stderr
  _rake_generate
  cat .rake_tasks
}

_rake_does_task_list_need_generating () {
  _rake_tasks_missing ||
  _rake_tasks_version_changed ||
  _rakefile_has_changes
}

_rake_tasks_missing () {
  [[ ! -f .rake_tasks ]]
}

_rake_tasks_version_changed () {
  local -a file_version
  file_version=`head -n 1 .rake_tasks | sed "s/^version\://"`

  if ! [[ $file_version =~ '^[0-9]*$' ]]; then
    return true
  fi

  [[ $file_version -ne $_rake_tasks_version ]]
}

_rakefile_has_changes () {
  [[ Rakefile -nt .rake_tasks ]]
}

_rake_generate () {
  echo "version:$(_rake_tasks_version)" > .rake_tasks

  rake --silent --tasks \
    | sed "s/^rake //"  \
    | sed "s/\:/\\\:/g" \
    | sed "s/\[.*\]//g" \
    | sed "s/ *# /\:/"  \
    >> .rake_tasks
}

_rake () {
  if [ -f Rakefile ]; then
    if _rake_does_task_list_need_generating; then
      echo "\nGenerating .rake_tasks..." > /dev/stderr
      _rake_generate
    fi
    local -a rake_options
    rake_options=( "${(f)mapfile[.rake_tasks]}" )
    shift rake_options
    _describe 'values' rake_options
  fi
}

compdef _rake rake
alias rake_refresh='_rake_refresh'
