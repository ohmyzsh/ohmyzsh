function run_cicd_test_containers() {
  echo "Starting local CI/CD tests at $(date)"
  echo "Running bandit..."
  docker-compose run --no-deps --rm clever-sync-api python -m bandit -r . -x /tests/
  RES2=$?
  echo "Running black..."
  docker-compose run --no-deps --rm clever-sync-api black . --check --line-length=120
  RES4=$?
  echo "Running flake8..."
  docker-compose run --no-deps --rm clever-sync-api flake8 --config /app/dev-tools-config/.flake8 .
  RES3=$?
  # echo "Running pylint..."
  # docker-compose run --no-deps --rm  clever-sync-api pylint --rcfile /app/dev-tools-config/.pylintrc classkick
  # RES2=$?
  echo "Running isort..."
  docker-compose run --no-deps --rm clever-sync-api isort . --profile black --line-length=120 --check
  RES1=$?
  echo "Running coverage..."
  docker-compose run --no-deps --rm clever-sync-api pytest --cov .
  RES5=$?
  echo "Finished local CI/CD tests at $(date)"

  if [[ $RES1 -ne 0 || $RES2 -ne 0 || $RES3 -ne 0 || $RES4 -ne 0 || $RES5 -ne 0 ]]; then
    return 1
  fi

  return 0
}

function run-cicd-fix() {
  echo "Starting CI/CD containers in 'fix mode' at $(date)."
  echo "Running black..."
  docker-compose run --no-deps --rm $APP black . --line-length=120
  RES4=$?
  echo "Running ruff fix..."
  docker-compose run --rm $APP ruff check --fix --config /app/dev-tools-config/.ruff.toml .
  RES1=$?
}

alias grep-branches="find-branch"
alias search-branches="find-branch"


function run-cicd-tests() {
  LOGDIR="./cicd-test-logs"
  mkdir -p $LOGDIR
  docker-compose run --rm $APP black . --line-length=120
  docker-compose run --rm $APP ruff check --config /app/dev-tools-config/.ruff.toml .
  docker-compose run --rm $APP python -m bandit -r . -x /tests/
  docker-compose run -e TEST_DB=$APP --rm $APP pytest .
  docker-compose run --rm $APP pytest --cov .
  # docker-compose logs -t -f --tail 5 # Doesn't work - only tails "proper containers", not these temp ones
}

function run-bandit() {
  docker-compose run --rm $APP python -m bandit -r . -x /tests/
}

function run-pytest() {
  docker-compose run -e TEST_DB=$APP --rm $APP pytest .
}

function run-black() {
  docker-compose run --rm $APP black . --line-length=120
}

function run-isort() {
  docker-compose run --rm $APP isort . --profile black --check
}

function run-flake8() {
  docker-compose run --rm $APP flake8 --config /app/dev-tools-config/.flake8 .
}

function run-flake8-on-local-dir() {
  autoflake --remove-unused-variables --remove-all-unused-imports --in-place --recursive $1
}

function classkick-web-build() {
  docker compose build --no-cache --build-arg GITHUB_TOKEN=$GITHUB_TOKEN
}

function run-pylint() {
  docker-compose run --rm $APP pylint --rcfile /app/dev-tools-config/.pylintrc classkick
}

# Obvs adapt to current needs
function run-pytest-dir() {
  cls
  DIR="${1:-.}"
  docker-compose run -e TEST_DB=$APP --rm $APP pytest $DIR
}

function run-pytest-dir-pdb() {
  cls
  DIR="${1:-.}"
  docker-compose run -e TEST_DB=$APP --rm $APP pytest --pdb $DIR
}

function rebuild-db() {
  echo "Deleting backend-db and db containers..."
  docker container rm db 2>/dev/null
  docker container rm backend-db 2>/dev/null

  echo "Running initdev..." &&
    docker-compose run --rm -w /app/tasks salesbuddy-api inv initdev &&
    echo "Running alembic upgrade..." &&
    ops/alembic-ops development upgrade head &&
    echo "Seeding DB..." &&
    docker-compose run --rm -w /app/tasks salesbuddy-api inv seed &&
    echo "Running dbUpdate..." &&
    ops/classkick-v1-dev classkick-schema-init dbUpdate &&
    echo "All done."
}

alias reinit-db=rebuild-db
alias init-db=rebuild-db

function print-ck-env-vars() {
  echo -e "\nDATABASE\n——————————————"
  echo \$MYSQL_USER=$MYSQL_USER
  echo \$MYSQL_PASSWORD=$MYSQL_PASSWORD
  echo \$MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD
  echo \$MYSQL_HOST_IP=$MYSQL_HOST_IP
  echo \$MYSQL_RO_PORT=$MYSQL_RO_PORT
  echo \$MYSQL_TX_PORT=$MYSQL_TX_PORT
  echo \$SSL_CA_FILE=$SSL_CA_FILE
  echo \$SSL_CERT_FILE=$SSL_CERT_FILE
  echo \$SSL_KEY_FILE=$SSL_KEY_FILE
  echo \$TEST_DB=$TEST_DB
  echo \$DOCKER_DB_NAME=$DOCKER_DB_NAME

  echo -e "\nNOT DATABASE\n——————————————"
  echo \$PYTHONPATH=$PYTHONPATH
  echo \$DOCKER_DEFAULT_PLATFORM=$DOCKER_DEFAULT_PLATFORM
  echo \$ENVIRONMENT=$ENVIRONMENT
  echo \$APP=$APP
}

alias ck-env=print-ck-env-vars
alias dump-env=print-ck-env-vars
alias echo-ck-env=print-ck-env-vars

function set-ck-prod-env-vars() {
  export MYSQL_USER='pkingswell'
  export MYSQL_PASSWORD="PxeAnQ(0>'I<d^FV"
  export MYSQL_HOST_IP='35.232.226.146'
  export MYSQL_TX_PORT=3306
  export MYSQL_RO_PORT=3306
  export SSL_CA_FILE='/Users/peter/src/ck/network-ops/certs/production-mysql80/server-ca.pem'
  export SSL_CERT_FILE='/Users/peter/src/ck/network-ops/certs/production-mysql80/client-cert.pem'
  export SSL_KEY_FILE='/Users/peter/src/ck/network-ops/certs/production-mysql80/client-key.pem'
  export PYTHONPATH=$(pwd)/libs:$(pwd)/apps/background-jobs

  echo "PROD env vars set:"
  print-ck-env-vars
}

function set-ck-dev-env-vars() {
  export MYSQL_USER='root'
  export MYSQL_PASSWORD="dev"
  export MYSQL_ROOT_PASSWORD="dev"
  export MYSQL_HOST_IP='127.0.0.1'
  export MYSQL_TX_PORT=3306
  export MYSQL_RO_PORT=3306
  export PYTHONPATH=$(pwd)/libs:$(pwd)/apps/background-jobs

  echo "DEV env vars set:"
  print-ck-env-vars
}

function set-ck-staging-env-vars() {
  export MYSQL_USER='root' # TODO get pkingswell working
  export MYSQL_PASSWORD="^T%#wE%yArYPAgP2f8@k"
  export MYSQL_HOST_IP='104.197.69.215'
  export MYSQL_TX_PORT=3306
  export MYSQL_RO_PORT=3306
  export SSL_CA_FILE='/Users/peter/src/ck/network-ops/certs/staging-mysql80/server-ca.pem'
  export SSL_CERT_FILE='/Users/peter/src/ck/network-ops/certs/staging-mysql80/client-cert.pem'
  export SSL_KEY_FILE='/Users/peter/src/ck/network-ops/certs/staging-mysql80/client-key.pem'
  export PYTHONPATH=$(pwd)/libs:$(pwd)/apps/background-jobs

  echo "STAGING env vars set:"
  print-ck-env-vars
}

########################################################
# HANDY CONTAINER FUNCTIONS
########################################################
make-break ()
{
    echo -e "——————————————————————————————————————————   \n\n——————————————————————————————————————————\n";
    echo -e "——————————————————————————————————————————   \n\n——————————————————————————————————————————\n";
    echo -e "——————————————————————————————————————————   \n\n——————————————————————————————————————————\n";
    echo -e "——————————————————————————————————————————   \n\n——————————————————————————————————————————\n";
    echo -e "——————————————————————————————————————————   \n\n——————————————————————————————————————————\n";
    echo -e "——————————————————————————————————————————
    \n——————————————————————————"
    date +%H:%m:%S
    echo -e "——————————————————————————\n"
}
alias cls=make-break

function run-test-file() {
  cls;  pytest -rP --capture=tee-sys -rs $1 #  --pdb
}

function do_settings() {
  alias l="ls -l"
  alias lrt="ls -lart"
  export TEST_DB=background-jobs
  export SQLALCHEMY_SILENCE_UBER_WARNING=1
}

function switch-app() {
  APP=""
  case "$1" in
    sb)
        APP="salesbuddy-api" ;;
    bg)
        APP="background-jobs" ;;
    cs)
        APP="clever-sync-api" ;;
    *)
        echo $"Usage: $0 {sb|bg|cs}"
        exit 1
  esac
  export APP
  export TEST_DB=$APP
}


function ck-cloud-proxy() {
  CONN=""
  case "$1" in
    staging)
        CONN='"classkick-907:us-central1:staging-mysql80?port=3306" "classkick-907:us-central1:staging-mysql80-replica?port=3307" "classkick-907:us-central1:production-postgres-reporting?port=5432"' ;;
    production)
        CONN='"classkick-907:us-central1:production-mysql80?port=3306" "classkick-907:us-central1:production-mysql80-replica?port=3307" "classkick-907:us-central1:production-postgres-reporting?port=5432"' ;;
    *)
        echo $"Usage: $0 {staging|production}"
        exit 1
  esac

  cloud-sql-proxy $CONN
}
