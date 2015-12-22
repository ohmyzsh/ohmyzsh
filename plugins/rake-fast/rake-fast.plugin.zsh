_rake_refresh () {
  if [ -f .rake_tasks ]; then
    rm .rake_tasks
  fi
  echo "Generating .rake_tasks..." > /dev/stderr
  _rake_generate
  cat .rake_tasks
}

_rake_does_task_list_need_generating () {
  [[ ! -f .rake_tasks ]] || [[ Rakefile -nt .rake_tasks ]]
}

_rake_generate () {
  rake --silent --tasks \
    | sed "s/^rake //"  \
    | sed "s/\:/\\\:/g" \
    | sed "s/\[.*\]//g" \
    | sed "s/ *# /\:/"  \
    > .rake_tasks
}

_rake () {
  if [ -f Rakefile ]; then
    if _rake_does_task_list_need_generating; then
      echo "\nGenerating .rake_tasks..." > /dev/stderr
      _rake_generate
    fi
    local -a rake_options
    rake_options=( "${(f)mapfile[.rake_tasks]}" )
    _describe 'values' rake_options
  fi
}

compdef _rake rake
alias rake_refresh='_rake_refresh'
