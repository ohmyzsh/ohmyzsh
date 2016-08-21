_rake_refresh () {
  if [ -f .rake_tasks ]; then
    rm .rake_tasks
  fi
  echo "Generating .rake_tasks..." > /dev/stderr
  _rake_generate
  cat .rake_tasks
}

_rake_does_task_list_need_generating () {
  [[ ! -f .rake_tasks ]] || [[ Rakefile -nt .rake_tasks ]] || (_is_rails_app && _tasks_changed)
}

_is_rails_app () {
  [[ -e "bin/rails" ]] || [ -e "script/rails" ]
}

_tasks_changed () {
  local -a paths
  paths=(lib/tasks lib/tasks/**/*(N))

  for path in $paths; do
    if [[ "$path" -nt .rake_tasks ]]; then
      return 0
    fi
  done

  return 1
}

_rake_generate () {
  rake --silent --tasks | cut -d " " -f 2 > .rake_tasks
}

_rake () {
  if [ -f Rakefile ]; then
    if _rake_does_task_list_need_generating; then
      echo "\nGenerating .rake_tasks..." > /dev/stderr
      _rake_generate
    fi
    compadd `cat .rake_tasks`
  fi
}

compdef _rake rake
alias rake_refresh='_rake_refresh'
