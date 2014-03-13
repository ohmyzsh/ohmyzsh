# Symfony2 basic command completion
# And one step further

: ${SYMFONY_COMPLETE_CONSOLE:=""}
: ${SYMFONY_COMPLETE_ENTITIES:=""}

_SYMFONY_COMPLETE_CONSOLE=(
    ./console
    app/console
)

SYMFONY_DO_COMPLETE_CONSOLE=($_SYMFONY_COMPLETE_CONSOLE $SYMFONY_COMPLETE_CONSOLE)

_SYMFONY_COMPLETE_ENTITIES=(
    doctrine:generate:crud
    doctrine:generate:entities
    doctrine:generate:form
    generate:doctrine:crud
    generate:doctrine:entities
    generate:doctrine:form
)

SYMFONY_DO_COMPLETE_ENTITIES=($_SYMFONY_COMPLETE_ENTITIES $SYMFONY_COMPLETE_ENTITIES)

_symfony2 ()
{
    local console=$words[1]
    
    if [ ! -f "$console" ];then
        return
    fi

    local curcontext="$curcontext" state line
    typeset -A opt_args

    _arguments -C \
        ':command:->command' \
        '*::options:->options'

    case $state in
        (command)
            if [ -z "$symfony2_command_list" ];then
                _symfony2_command_list=$(_symfony2_get_command_list $console)
            fi
            compadd "$@" $(echo $_symfony2_command_list)
        ;;

        (options)
            needle=$line[1]
            if [[ ${SYMFONY_DO_COMPLETE_ENTITIES[(i)$needle]} -le ${#SYMFONY_DO_COMPLETE_ENTITIES} ]]; then
                if [ -z "$symfony2_entity_list" ];then
                    _symfony2_entity_list=$(_symfony2_get_entity_list $console)
                fi
                compadd "$@" $(echo $_symfony2_entity_list)
            else
            fi
        ;;
    esac
}

_symfony2_get_command_list () {
	$1 --no-ansi | sed "1,/Available commands/d" | awk '/^  [a-z]+/ { print $1 }' | sed -e 's/:/\:/g'
}

_symfony2_get_entity_list () {
    $1 doctrine:mapping:info | grep Bundle | cut -d ' ' -f 4 | awk '{ split($0, A, /\\/); for ( var in A ) { if ( match(A[var], /.*Bundle/) ) { bundle=A[var]; } } print bundle":"A[var] }'
}

for console_command in $SYMFONY_DO_COMPLETE_CONSOLE
do
    compdef _symfony2 $console_command
done

#Alias

alias sf2='php app/console'
alias sf2clear='php app/console cache:clear'
alias sf='php app/console'
alias sfcl='php app/console cache:clear'
alias sfroute='php app/console router:debug'
alias sfgb='php app/console generate:bundle'
