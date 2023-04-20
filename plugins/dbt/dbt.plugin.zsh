# Functions
function dbt-version(){
    dbt --version
}

# aliases for dbt
alias dbtb='dbt build' # build the project
alias dbtcl='dbt clean' # clean the project, deletes all folders specified in the clean-targets list specified in dbt_project.yml
alias dbtco='dbt compile' # compile the project
alias dbtdog='dbt docs generate' # generate docs
alias dbtdogn='dbt docs generate --no-compile' # generate docs without compiling
alias dbtdos='dbt docs serve' # serve docs
alias dbtdg='dbt debug' # debug the project
alias dbtdgc='dbt debug --config-dir' # show the configured location for the profiles.yml file 
alias dbtds='dbt deps' # pulls the most recent version of the dependencies listed in packages.yml
alias dbti='dbt init' # initialize a new dbt project
alias dbtl='dbt ls'  # list available models
alias dbtpa='dbt parse' # parse the project
alias dbtr='dbt run' # run a model
alias dbtrf='dbt run --full-refresh' # run a model with a full refresh
alias dbtro='dbt run-operation' # invoke a macro
alias dbts='dbt seed' # load csv files located in the seed-paths directory of the dbt project
alias dbtsw='dbt show' # generates post-transformation preview from a source model, test, or analysis
alias dbtsn='dbt snapshot' # executes the Snapshots defined in the project
alias dbtsof='dbt source freshness' # query all of defined source tables, determining the "freshness" of these tables
alias dbtt='dbt test' # runs tests defined on models, sources, snapshots, and seeds
alias dbtv='dbt-version' # get DBT version