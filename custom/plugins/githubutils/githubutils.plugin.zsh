# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

## --------------- Work Functions ---------------

## Utility function for other functions
function gitCurrentBranch {
  git symbolic-ref -q --short HEAD
}

alias gpr='gco master; git pull; gco -; git rebase master; git push --force-with-lease'

function grebb { ## git rebase branch
  git rebase -i $( git merge-base $( gitCurrentBranch ) master );
  git push --force;
}

function greba { ## git rebase all
  if [ $# -eq 0 ]; then # nor args
    git rebase -i --root;
  else;
    git rebase -i "master~$1";
  fi;
  git push --force;
}

function githubutils {
  echo "gpr - git rebase on master";
  echo "grebb - trigger rebase, allowing you to rebase all commits since branching off master";
  echo "greba <number of commits to rebase> - trigger rebase, allowing you to rebase all commits ever or ~X";
}