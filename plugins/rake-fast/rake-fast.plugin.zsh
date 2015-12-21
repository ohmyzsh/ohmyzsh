_rake_refresh () {
  if [ -f .rake_tasks ]; then
    rm .rake_tasks
  fi
  echo "Generating .rake_tasks..." > /dev/stderr
  _rake_generate
  cat .rake_tasks
}

_rake_does_task_list_need_generating () {
  _rake_tasks_missing || _rakefile_has_changes || _sub_rake_files_have_changes
}

_rake_tasks_missing () {
  [[ ! -f .rake_tasks ]]
}

_rakefile_has_changes () {
  [[ Rakefile -nt .rake_tasks ]]
}

_sub_rake_files_have_changes () {
  if find . -type f -name "*.rake" 2>/dev/null | grep -q .; then
    [[ $(find ./**/*.rake(.om[1])) -nt .rake_tasks ]]
  else
    false
  fi
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
