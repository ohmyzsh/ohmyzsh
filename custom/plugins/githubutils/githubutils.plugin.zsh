# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

## --------------- Work Functions ---------------

## Utility function for other functions
function gitCurrentBranch {
  git symbolic-ref -q --short HEAD
}

# git pull request
alias gpr='gco master; git pull; gco -; git rebase master; git push --force-with-lease'

# Rebase/rename commigs
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

# Move bitbucket repo to github
# Make sure to create empty github repo first
function move-bb-to-github {
  if [ $# -eq 0 ]; then # nor args
    echo "No destination is set";
  else;
    git remote rename origin bitbucket;
    git remote add origin ${1};
    git push origin master;
    git remote rm bitbucket; 
  fi;
}

# Deleting consecutive commit from a branch
# https://www.clock.co.uk/insight/deleting-a-git-commit
# git rebase --onto $branchName~$firstCommitToRemove $branchName~$firstCommitToKeep $branchName

#Change git commit - 
function change-commit-time {
  GIT_COMMITTER_DATE="Thu Oct 10 11:36:13 2019 +0100" git commit --amend --no-edit --date "Thu Oct 10 11:36:13 2019 +0100"
}

function githubutils {
  echo "gpr - git rebase on master";
  echo "grebb - trigger rebase, allowing you to rebase all commits since branching off master";
  echo "greba <number of commits to rebase> - trigger rebase, allowing you to rebase all commits ever or ~X";
  echo "move-bb-to-github <destination> - rebase repo to new destination (with .git at the end)";
  exho "change-commit-time - change current commits time"
}