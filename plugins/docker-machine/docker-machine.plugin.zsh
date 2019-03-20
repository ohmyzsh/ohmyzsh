DEFAULT_MACHINE="default"

docker-up() {
    if [ -z "$1" ]
    then
        docker-machine start "${DEFAULT_MACHINE}"
        eval $(docker-machine env "${DEFAULT_MACHINE}")
    else
        docker-machine start $1
        eval $(docker-machine env $1)
    fi
    echo $DOCKER_HOST
}
docker-stop() {
    if [ -z "$1" ]
    then
        docker-machine stop "${DEFAULT_MACHINE}"
    else
        docker-machine stop $1
    fi
}
docker-switch() {
    eval $(docker-machine env $1)
    echo $DOCKER_HOST
}
docker-vm() {
    if [ -z "$1" ]
    then
        docker-machine create -d virtualbox --virtualbox-disk-size 20000 --virtualbox-memory 4096 --virtualbox-cpu-count 2 "${DEFAULT_MACHINE}"
    else
        docker-machine create -d virtualbox --virtualbox-disk-size 20000 --virtualbox-memory 4096 --virtualbox-cpu-count 2 $1
    fi
}