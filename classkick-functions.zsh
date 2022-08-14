
function run_cicd_test_containers() {
    echo "Starting local CI/CD tests at `date`"
    echo "Running bandit..."
    docker-compose run --no-deps --rm clever-sync-api python -m bandit -r . -x /tests/
    RES2=$?
    echo "Running black..."
    docker-compose run --no-deps --rm  clever-sync-api black . --check --line-length=120
    RES4=$?
    echo "Running flake8..."
    docker-compose run --no-deps --rm  clever-sync-api flake8 --config /app/dev-tools-config/.flake8 .
    RES3=$?
    # echo "Running pylint..."
    # docker-compose run --no-deps --rm  clever-sync-api pylint --rcfile /app/dev-tools-config/.pylintrc classkick
    # RES2=$?
    echo "Running isort..."
    docker-compose run --no-deps --rm  clever-sync-api isort . --profile black --line-length=120 --check
    RES1=$?
    echo "Running coverage..."
    docker-compose run --no-deps --rm clever-sync-api  pytest --cov .
    RES5=$?
    echo "Finished local CI/CD tests at `date`"

    if [[ $RES1 -ne 0 || $RES2 -ne 0 || $RES3 -ne 0 || $RES4 -ne 0 || $RES5 -ne 0 ]]
    then
        return 1
    fi

    return 0
}

function run_cicd_fix_containers() {
    echo "Starting CI/CD containers in 'fix mode' at `date`."
    echo "Are you sure you want to continue?"
    read

    echo "Running black..."
    docker-compose run --no-deps --rm  clever-sync-api black . --line-length=120
    RES4=$?
    echo "Running isort..."
    docker-compose run --no-deps --rm  clever-sync-api isort . --profile black --line-length=120
    RES1=$?
}
