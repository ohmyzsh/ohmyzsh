_mix_refresh () {
  if [ -f .mix_tasks ]; then
    rm .mix_tasks
  fi
  echo "Generating .mix_tasks..." > /dev/stderr
  _mix_generate
  cat .mix_tasks
}

_mix_does_task_list_need_generating () {
  [ ! -f .mix_tasks ];
}

_mix_generate () {
  mix --help | grep -v 'iex -S' | tail -n +2 | cut -d " " -f 2 > .mix_tasks
}

_mix () {
  if [ -f mix.exs ]; then
    if _mix_does_task_list_need_generating; then
      echo "\nGenerating .mix_tasks..." > /dev/stderr
      _mix_generate
    fi
    compadd `cat .mix_tasks`
  fi
}

compdef _mix mix
alias mix_refresh='_mix_refresh'
