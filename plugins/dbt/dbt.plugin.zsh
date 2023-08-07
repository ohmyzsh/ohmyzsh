# list modified models only
alias dbtlm="dbt ls -s state:modified"

# run modified models only
alias dbtrm="dbt run -s state:modified"

# test modified models only
alias dbttm="dbt test -m state:modified"

# run and test modified models only
alias dbtrtm="dbtrm && dbttm"

# re-seed data
alias dbtrs="dbt clean; dbt deps; dbt seed"

# perform a full fresh run with tests
alias dbtfrt="dbtrs; dbt run --full-refresh; dbt test"

# generate and serve docs
alias dbtcds="dbt docs generate; dbt docs serve"

# generate and serve docs skipping doc. re-compilation
alias dbtds="dbt docs generate --no-compile; dbt docs serve"
