# load autocomplete function and necessary zsh modules
autoload -Uz compinit && compinit
autoload -Uz colors && colors

# dynamically set prisma orm schema based on environment
_prisma_set_schema() {
    local env_file=".env"
    local default_schema="./prisma/schema.prisma"
    local schema_var="PRISMA_SCHEMA"

    # check if .env file exists
    if [[ -f "$env_file" ]]; then
        source "$env_file"  # load environment variables
        echo "${(P)${schema_var}:-$default_schema}"  # return schema path from env or default
    else
        echo "$default_schema"  # default schema path
    fi
}

# dynamic model names from prisma orm schema
_prisma_models() {
    local schema_file=$(_prisma_set_schema)
    [[ -f "$schema_file" ]] || return 1

    awk '/model [A-Za-z0-9_]+ {/{print $2}' "$schema_file"
}

# toggle verbose output for prisma orm commands
alias prisma_verbose='export PRISMA_LOG_LEVEL="info"'
alias prisma_quiet='unset PRISMA_LOG_LEVEL'

# prisma orm autocomplete function
_prisma_autocomplete() {
    local -a commands migrate_opts generate_opts model_names

    commands=(
        'init:Initialize a new Prisma project'
        'migrate:Run database migrations'
        'generate:Generate Prisma client'
        'studio:Open Prisma Studio'
        'introspect:Introspect your database'
        'env:List environment variables used by Prisma'
    )

    migrate_opts=('dev:Create a new migration and apply it' 'deploy:Apply pending migrations to the database' 'reset:Reset the database and apply all migrations' 'status:Check the status of your database migrations')

    generate_opts=('--schema:Specify the Prisma schema file')

    model_names=($(_prisma_models))

    case "$words[2]" in
        migrate)
            _describe -t commands 'migrate subcommand' migrate_opts
            ;;
        generate)
            _describe -t commands 'generate options' generate_opts
            ;;
        studio)
            _wanted models expl 'model name' compadd -a model_names
            ;;
        *)
            _describe -t commands 'prisma command' commands
            ;;
    esac
}

compdef _prisma_autocomplete prisma

# model-specific aliases - replace 'User' with your model names
alias prisma_user_create='prisma studio --create User'
alias prisma_user_delete='prisma studio --delete User'

