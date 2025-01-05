###
### DOCKER UTIL
###

alias dc='docker-compose '
alias ddp="echo '\$DOCKER_DEFAULT_PLATFORM': $DOCKER_DEFAULT_PLATFORM"
alias dk="docker"
alias dl="docker logs "
alias dlf="docker logs -f "
alias dkl="dl"
alias dlf="dlf"
alias docker-killall="killall com.docker.hyperkit"
alias dps="docker ps"
alias dkps="dps"
alias killall-docker="killall com.docker.hyperkit"
alias dkls="dk container ls"

function docker-stop-all-containers () {
  echo "Stopping all containers..." ; docker container stop -t 2 $(docker container ls -q) 2>/dev/null ; echo ""
}

function docker-lsg () {
  docker image ls | grep -Ei "'IMAGE ID'|$1"
}


# kill most recent container instance
alias docker-kill-latest='docker ps -l --format="{{.Names}}" | xargs docker kill'
alias docker-kill-last='docker-kill-latest'
alias docker-kill-most-recent='docker-kill-latest'

function docker-ls-grep () {
  docker image ls | grep -Ei "'IMAGE ID'|$1"
}


alias dkl='docker-ls-grep'

# kill most recent container instance
alias docker-kill-latest='docker ps -l --format="{{.Names}}" | xargs docker kill'
alias kill-docker-latest=docker-kill-latest

# Params: container ID or name
function dlc() {
  docker logs $1 | pbcopy
}

# Params: container ID/name, human date or relative period
function dls() {
  docker logs $1 --since $2
}
