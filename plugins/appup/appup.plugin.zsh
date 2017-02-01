# Docker
_appup_docker () {
    if type docker-compose >/dev/null 2>&1; then
        # <cmd> <project name> will look for docker-compose.<project name>.yml
        if [ -n "$2" -a -e "docker-compose.$2.yml" ]; then
            project=$(source ".env.$2"; echo $COMPOSE_PROJECT_NAME)

            if [ -n $project ]; then
                docker-compose -p "${project}" -f docker-compose.yml -f "docker-compose.${2}.yml" $1 "${@:3}"
                return
            fi

            docker-compose -f docker-compose.yml -f "docker-compose.${2}.yml" $1 "${@:3}"
            return
        fi

        docker-compose $1 "${@:2}"
    else
        echo >&2 "Docker compose file found but docker-compose is not installed."
    fi
}

# Vagrant
_appup_vagrant () {
    if type vagrant >/dev/null 2>&1; then
        vagrant $1 "${@:2}"
    else
        echo >&2 "Vagrant file found but vagrant is not installed."
    fi
}

up () {
    if [ -e "docker-compose.yml" ]; then
        _appup_docker up "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant up "$@"
    elif hash up >/dev/null 2>&1; then
        env up "$@"
    fi
}

down () {
    if [ -e "docker-compose.yml" ]; then
        _appup_docker down "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant destroy "$@"
    elif hash down >/dev/null 2>&1; then
        env down "$@"
    fi
}

start () {
    if [ -e "docker-compose.yml" ]; then
        _appup_docker start "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant resume "$@"
    elif hash start >/dev/null 2>&1; then
        env start "$@"
    fi
}

stop () {
    if [ -e "docker-compose.yml" ]; then
        _appup_docker stop "$@"
    elif [ -e "Vagrantfile" ]; then
        _appup_vagrant suspend "$@"
    elif hash stop >/dev/null 2>&1; then
        env stop "$@"
    fi
}
