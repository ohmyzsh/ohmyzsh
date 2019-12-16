## --------------- Work Functions ---------------

function workshare-gcojira {
  echo "WEB code:";
  read CODE;
  echo "Task:";
  read TASK;
  TR_TASK="$( echo "$TASK" | tr "[:upper:]" "[:lower:]" | tr ' ' '-' )";
  BRANCH_NAME="WEB-$CODE-$TR_TASK";
  git checkout master && git pull && git checkout -b "$BRANCH_NAME" && git push -u origin "$BRANCH_NAME";
}

function workshare-gcommitjira {
  echo "Task:";
  read MESSAGE;
  BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
  ARR=(`echo ${BRANCH}`);
  CODE=(`echo ${ARR[2]}`);
  COMMIT_MESSAGE="WEB-$CODE $MESSAGE";
  git add --all && git commit -am "$COMMIT_MESSAGE";
}

function workshare {
  echo "workshare-gcojira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "workshare-gcommitjira - Commit to a branch in the format required to correspond to a Jira issue";
}

# Checkout branch and begin time tracker
# gcot () {
#   gco "$@";

#   BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
#   ARR=(`echo ${BRANCH}`);
#   CODE=(`echo ${ARR[2]}`);
  
#   t out;
#   t sheet workshare;
#   t in "WEB-$CODE";
# }

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