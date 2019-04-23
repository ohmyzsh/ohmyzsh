# Add your own custom plugins in the custom/plugins directory. Plugins placed
# here will override ones with the same name in the main plugins directory.

## --------------- Work Functions ---------------

function gcojira {
  echo "WEB code:";
  read CODE;
  echo "Task:";
  read TASK;
  TR_TASK="$( echo "$TASK" | tr "[:upper:]" "[:lower:]" | tr ' ' '-' )";
  BRANCH_NAME="WEB-$CODE-$TR_TASK"
  git checkout master && git pull && git checkout -b "$BRANCH_NAME" && git push -u origin "$BRANCH_NAME"
}

## Jest functions
function jw { # jest watch
  ## -- means pass params to jest
  npm test -- --watch --runInBand --bail ${1}
}

function jwnc { # jest watch no cache
  ## -- means pass params to jest
  npm test -- --watch --no-cache --runInBand --bail ${1}
}

function jwa { # jest watch all
  ## -- means pass params to jest
  npm test -- --watchAll --runInBand --bail ${1}
}

function workshare {
  echo "gpr - git rebase on master";
  echo "grebb - trigger rebase, allowing you to rebase all commits since branching off master";
  echo "greba <number of commits to rebase> - trigger rebase, allowing you to rebase all commits ever or ~X";
  echo "gcojira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "jw <regex pattern for files> - Run tests, watch and bail";
  echo "jwnc <regex pattern for files> - Run tests, watch and bail";
  echo "jwa <regex pattern for files> - Run all tests, watch and bail";
}