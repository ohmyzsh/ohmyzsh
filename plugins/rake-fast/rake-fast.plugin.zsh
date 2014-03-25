_rake_refresh () {
  if [ -f .rake_tasks ]; then
    rm .rake_tasks
  fi
  echo "Generating .rake_tasks..." > /dev/stderr
  _rake_generate
  cat .rake_tasks
}

_rake_does_task_list_need_generating () {
  if [ ! -f .rake_tasks ]; then return 0;
  else
    if [[ $(uname -s) == 'Darwin' ]]; then
      accurate=$(stat -f%m .rake_tasks)
      changed=$(stat -f%m Rakefile)
    else
      accurate=$(stat -c%Y .rake_tasks)
      changed=$(stat -c%Y Rakefile)
    fi
    return $(expr $accurate '>=' $changed)
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
