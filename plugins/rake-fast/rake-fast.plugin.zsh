# rake-fast
# Fast rake autocompletion plugin for oh-my-zsh

# This script caches the output for later usage and significantly speeds it up.
# It generates a .rake_tasks file in parallel to the Rakefile.

# You'll want to add `.rake_tasks` to your global .git_ignore file:
# https://help.github.com/articles/ignoring-files#global-gitignore

# You can force .rake_tasks to refresh with:
# $ rake_refresh

# This is entirely based on Ullrich Schäfer's work
# (https://github.com/robb/.dotfiles/pull/10/),
# which is inspired by this Ruby on Rails trick from 2006:
# http://weblog.rubyonrails.org/2006/3/9/fast-rake-task-completion-for-zsh/

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
    accurate=$(stat -f%m .rake_tasks)
    changed=$(stat -f%m Rakefile)
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
