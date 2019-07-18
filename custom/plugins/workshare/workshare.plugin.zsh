## --------------- Work Functions ---------------

function gcojira {
  echo "WEB code:";
  read CODE;
  echo "Task:";
  read TASK;
  TR_TASK="$( echo "$TASK" | tr "[:upper:]" "[:lower:]" | tr ' ' '-' )";
  BRANCH_NAME="WEB-$CODE-$TR_TASK";
  git checkout master && git pull && git checkout -b "$BRANCH_NAME" && git push -u origin "$BRANCH_NAME";
}

function gcommitjira {
  echo "Task:";
  read MESSAGE;
  BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
  ARR=(`echo ${BRANCH}`);
  CODE=(`echo ${ARR[2]}`);
  COMMIT_MESSAGE="WEB-$CODE $MESSAGE";
  git add --all && git commit -am "$COMMIT_MESSAGE";
}

## Jest functions
function jw { # jest watch
  ## -- means pass params to jest
  npm test -- --watch --runInBand --bail ${1};
}

function jwnc { # jest watch no cache
  ## -- means pass params to jest
  npm test -- --watch --no-cache --runInBand --bail ${1};
}

function jwa { # jest watch all
  ## -- means pass params to jest
  npm test -- --watchAll --runInBand --bail ${1};
}

function workshare {
  echo "gcojira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "gcommitjira - Commit to a branch in the format required to correspond to a Jira issue";
  echo "jw <regex pattern for files> - Run tests, watch and bail";
  echo "jwnc <regex pattern for files> - Run tests, watch and bail";
  echo "jwa <regex pattern for files> - Run all tests, watch and bail";
}

gcot () {
  gco "$@";

  BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
  ARR=(`echo ${BRANCH}`);
  CODE=(`echo ${ARR[2]}`);
  
  t out;
  t sheet workshare;
  t in "WEB-$CODE";
}

# Automatically checkin to time tracker when opening a git repo
# cd () { 
#   builtin cd "$@"; 
#   cd_git_checker;

#   if [ -d .git ]; then
#     BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
#     ARR=(`echo ${BRANCH}`);
#     CODE=(`echo ${ARR[2]}`);
    
#     t out;
#     t sheet workshare;
#     t in "WEB-$CODE";
#   fi;
# }