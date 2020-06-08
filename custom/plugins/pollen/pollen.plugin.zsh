## --------------- Pollen Work Functions ---------------

## Spin up needed server components
function pollen-server-up {
  bin/server --exclude pollen_ui phoenix_ui ambassador_ui customer_ui calvin_ui    
}

## seed demo data
function pollen-dummy-data {
  # bin/demo-data
  ambassador_api/bin/demo-data
}

## reset demo data
function pollen-reset-dummy-data {
  #bin/reset_db && bin/demo-data
  bin/reset_db && ambassador_api/bin/demo-data
}

## clean build
function pollen-clean-build {
  docker-compose down && bin/bootstrap
}

## clean build
function pollen-clean-build2 {
  docker-compose down && npm run bootstrap
}


## really clean build
function pollen-really-clean-build {
  docker-compose down && bin/setup && bin/bootstrap
}

## run fe
function pollen-phoenix-arise {
  npm run dev
}

## serve styleguide
function pollen-styleguide {
  styleguide_docs/bin/server
}

## setup e2e
function pollen-setup-e2e {
  docker-compose down && bin/server-e2e
}

function pollen-run-tests-all {
  ./e2e/bin/test --staging
}

function pollen-deploy-branch-to-staging {
  bin/deploy --envname ${1} --services=phoenix_ui,ambassador_api,ambassador_ui,gateway_api,auth_ui --confirm
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
  echo "pollen-clean-build - docker-compose down && bin/bootstrap";
  echo "pollen-clean-build2 - docker-compose down && npm run bootstrap";
  echo "pollen-clear-virtual-env - delete the .virtualenv folders in all dirs";
  echo "pollen-dummy-data - create demo data";
  echo "pollen-gco-jira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "pollen-git-commit-jira - Commit to a branch in the format required to correspond to a Jira issue";
  echo "pollen-phoenix-arise - run FE";
  echo "pollen-really-clean-build - bin/setup";
  echo "pollen-reset-dummy-data - delete then re-create dummy data";
  echo "pollen-server-up - spin up pollen server";
  echo "pollen-styleguide - run styleguide server";
  echo "pollen-setup-e2e - docker-compose down && bin/server-e2e";
  echo "pollen-run-tests-all - runs tests";
  echo "pollen-deploy-branch-to-staging {x}- pushes local branch to a branch, x";
}