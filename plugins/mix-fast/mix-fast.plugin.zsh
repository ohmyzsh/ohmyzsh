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
<<<<<<< HEAD
  mix --help | grep -v 'iex -S' | tail -n +2 | cut -d " " -f 2 > .mix_tasks
=======
  mix help | grep '^mix [^ ]' | sed -E "s/mix ([^ ]*) *# (.*)/\1:\2/" > .mix_tasks
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
}

_mix () {
  if [ -f mix.exs ]; then
    if _mix_does_task_list_need_generating; then
      echo "\nGenerating .mix_tasks..." > /dev/stderr
      _mix_generate
    fi
<<<<<<< HEAD
    compadd `cat .mix_tasks`
=======
    local tasks=(${(f)"$(cat .mix_tasks)"})
    _describe 'tasks' tasks
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
  fi
}

compdef _mix mix
alias mix_refresh='_mix_refresh'
