#---oh-my-zsh plugin : task Autocomplete for Jake tool---
# Jake : https://github.com/mde/jake
# Warning : Jakefile should have the right case : Jakefile
# Warnign : Add a .jake_tasks file to your working directory
# Author : Alexandre Lacheze (@al3xstrat)
# Inspiration : http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh 

function _jake_does_task_list_need_generating () {
  if [ ! -f .jake_tasks ]; then
    return 0;
  else
    accurate=$(stat -f%m .jake_tasks)
    changed=$(stat -f%m Jakefile)
    return $(expr $accurate '>=' $changed)
  fi
}

function _jake () {
  if [ -f Jakefile ]; then
    if _jake_does_task_list_need_generating; then
      echo "\nGenerating .jake_tasks..." > /dev/stderr
      jake -T | cut -d " " -f 2 | sed -E "s/.\[([0-9]{1,2}(;[0-9]{1,2})?)?[m|K]//g" > .jake_tasks
    fi
    reply=( `cat .jake_tasks` )
  fi
}

compctl -K _jake jake