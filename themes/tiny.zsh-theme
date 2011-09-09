# This is a theme that tends to be smaller than minimal, but it still has some neat features:
# * if the working directory is a git repository, you'll see a '±'
# * git status is shown by the color of the '±'
# * you'll only ever see the branch name it isn't master

function collapse_pwd {
  echo `pwd | sed -e "s,^$HOME,~,"`
}

function prompt_character {
  # if you're in a git branch, the prompt character is '±'
  # (this is handled by git_colors)
  git branch >> /dev/null 2>> /dev/null && echo "%{$fg[`git_colors`]%}±%{$reset_color%}" && return
  # else, it's a blank space
  echo " "
}

function git_colors {
  # if everything has been committed, return 'green'
  git status | grep "nothing to commit (working directory clean)" >> /dev/null && echo 'green' \
    && return
  # if it's dirty, return 'rd'
  git status | grep "# Changes not staged for commit:" >> /dev/null && echo 'red' && return
  git status | grep "# Untracked files:" >> /dev/null && echo 'red' && return
  # if everything is staged, return 'magenta'
  echo 'magenta'
}

function git_branch {
  # only actually echo anything if this is a git repo and the branch isn't master
  local cb=$(current_branch)
  if [ -n "$cb" ]; then
    if [ "$cb" != "master" ]; then
      echo "[`current_branch`] "
    fi
  fi
}

PROMPT='$(collapse_pwd) %{$fg[cyan]%}$(git_branch)%{$reset_color%}$(prompt_character) » '
