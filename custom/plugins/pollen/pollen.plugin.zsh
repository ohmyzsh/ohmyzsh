## --------------- Pollen Work Functions ---------------

## Spin up needed server components
function pollen-server-up {
  #bin/server --exclude pollen_ui phoenix_ui ambassador_ui customer_ui calvin_ui avocado_ui  
  bin/server ambassador_api ambassador_api_worker phoenix_ui notification_service gateway_api           
}

function pollen-server-up-phoenix {
  pollen-server-up
}

function pollen-server-up-pollen {
  bin/server ambassador_api ambassador_api_worker phoenix_ui notification_service gateway_api pollen_ui
}

## seed demo data
function pollen-data-demo {
  # bin/demo-data
  ambassador_api/bin/demo-data
}

## seed demo data
function pollen-data-production {
  # bin/get-production-data
  ambassador_api/bin/get-production-data --force-download
}

## seed demo data
function pollen-data-production-anonymized {
  # bin/get-anonymized-production-data
  ambassador_api/bin/get-anonymized-production-data --force-download
}

## reset demo data
function pollen-reset-demo-data {
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

## clean build + clear virtul env
function pollen-really-clean-build {
  pollen-clear-virtual-env && docker-compose down && bin/bootstrap
}

## really clean build
function pollen-really-really-clean-build {
  docker-compose down && bin/setup && bin/bootstrap
}

## run fe
function pollen-phoenix-arise {
  npm run dev
}

## serve styleguide
function pollen-styleguide {
  styleguide/bin/server
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
  for FOLDER in ambassador_api ambassador_ui auth_ui bin calvin_ui customer_ui devtools e2e_cypress etl_service finance_service gateway_api infrastructure lib licensed_travel_api logs node_modules notification_service phoenix_ui pollen_ui review_automation_service shortlinks_service styleguide ; do
    pushd $FOLDER
      rm -rf .virtualenv;
    popd
  done
}

function pollen {
  echo "pollen-clean-build - docker-compose down && bin/bootstrap";
  echo "pollen-clean-build2 - docker-compose down && npm run bootstrap";
  echo "pollen-clear-virtual-env - delete the .virtualenv folders in all dirs";
  echo "pollen-data-demo - create demo data";
  echo "pollen-data-production - download data from prod";
  echo "pollen-data-production-anonymized - download data from prod, anonymized";
  echo "pollen-deploy-branch-to-staging {x}- pushes local branch to a branch, x";
  echo "pollen-gco-jira - Checkout a branch in the format required to correspond to a Jira issue";
  echo "pollen-git-commit-jira - Commit to a branch in the format required to correspond to a Jira issue";
  echo "pollen-phoenix-arise - run FE";
  echo "pollen-really-clean-build - clean build but with virtual env cleared";
  echo "pollen-really-really-clean-build - bin/setup";
  echo "pollen-reset-demo-data - delete then re-create demo data";
  echo "pollen-run-tests-all - runs tests";
  echo "pollen-server-up - spin up pollen server";
  echo "pollen-server-up-phoenix - server config for phoenix";
  echo "pollen-server-up-pollen - server config for pollen";
  echo "pollen-setup-e2e - docker-compose down && bin/server-e2e";
  echo "pollen-styleguide - run styleguide server";
}