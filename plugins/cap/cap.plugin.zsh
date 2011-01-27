function _cap_does_task_list_need_generating () {
  if [ ! -f .cap_tasks ]; then return 0;
  else
    accurate=$(stat -c%Y .cap_tasks)
    changed=$(stat -c%Y config/deploy.rb)
    return $(expr $accurate '>=' $changed)
  fi
}

function _cap () {
  if [ -f config/deploy.rb ]; then
    if _cap_does_task_list_need_generating; then
      echo "\nGenerating .cap_tasks..." > /dev/stderr
      cap -vT | sed -e '/^cap/!D' | cut -d " " -f 2 > .cap_tasks
    fi
    compadd `cat .cap_tasks`
  fi
}

compdef _cap cap
