## --------------- Pollen Work Functions ---------------

## Spin up needed server components
function pollen-server-up {
  bin/server --exclude pollen_ui phoenix_ui ambassador_ui customer_ui calvin_ui    
}

## seed demo data
function pollen-dummy-data {
  bin/demo-data
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


function pollen-clear-virtual-env {
  for FOLDER in ambassador_api ambassador_ui auth_ui bin calvin_ui customer_ui devtools e2e_cypress etl_service finance_service gateway_api infrastructure lib licensed_travel_api logs node_modules notification_service phoenix_ui pollen_ui review_automation_service shortlinks_service styleguide_docs ; do
    pushd $FOLDER
      rm -rf .virtualenv;
    popd
  done
}


function pollen {
  echo "pollen-server-up - spin up pollen server";
  echo "pollen-dummy-data - seed demot data";
  echo "pollen-gco-jira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "pollen-git-commit-jira - Commit to a branch in the format required to correspond to a Jira issue";
}