## --------------- Pollen Work Functions ---------------

## Spin up needed server components
function pollen-server-up {
  bin/server --exclude pollen_ui phoenix_ui ambassador_ui customer_ui calvin_ui    
}

function pollen-gco-jira {
  echo "TE code:";
  read CODE;
  echo "Task:";
  read TASK;
  TR_TASK="$( echo "$TASK" | tr "[:upper:]" "[:lower:]" | tr ' ' '-' )";
  BRANCH_NAME="TE-$CODE-$TR_TASK";
  git checkout master && git pull && git checkout -b "$BRANCH_NAME" && git push -u origin "$BRANCH_NAME";
}

function pollen-git-commit-jira {
  echo "Task:";
  read MESSAGE;
  BRANCH="$( echo "$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)" | tr '-' ' ' )";
  ARR=(`echo ${BRANCH}`);
  CODE=(`echo ${ARR[2]}`);
  COMMIT_MESSAGE="TE-$CODE $MESSAGE";
  git add --all && git commit -am "$COMMIT_MESSAGE";
}

function pollen {
  echo "pollen-server-up - spin up pollen server";
  echo "pollen-gco-jira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "pollen-git-commit-jira - Commit to a branch in the format required to correspond to a Jira issue";
}