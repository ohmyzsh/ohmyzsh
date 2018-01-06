alias di='docker info'
alias dlg='docker container logs'
alias dls='docker container ls'
alias dlsa='docker container ls -a'
alias dr='docker container run'
alias drm='docker container rm'
alias drmf='docker container rm -f'
alias ds='docker container stop'
alias dt='docker top'
alias dv='docker version'
alias dpo='docker container port'
alias dpu='docker pull'
alias dx='docker container exec'
alias dbl='docker build'
alias dhh='docker help'
alias dcin='docker container inspect'

#docker images
alias dirm='docker image rm'
alias dils='docker image ls'
alias dit='docker image tag'
alias dip='docker image push'
alias dib='docker image build'
alias dii='docker image inspect'


#docker network
alias dnls='docker network ls'
alias dni='docker network inspect'
alias dnc='docker network create'
alias dncn='docker network connect'
alias dndcn='docker network disconnect'

#docker volume
alias dvl='docker volume ls'
alias dvclean='docker volume rm $(docker volume ls -qf dangling=true)'