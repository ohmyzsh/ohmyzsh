function dock_usage () {
cat <<-USAGE

  usage: dock <command>

    clean             Remove all stopped containers
    info              Info on Docker setup
    help              show Docker cheat sheet
USAGE
}

function dock_clean {
  docker rm $(docker ps -a -q);

  [ "$1" = "images" ] && docker rmi $(docker images -q);
}

function dock_info {
cat <<-INFO
  You are (probably) running docker locally on a Mac using Docker Toolbox.

  Docker Machine is the new boot2docker thing. You have a virtual machine
  created called 'default'. You can check the status by running.

  docker-machine status default

  If it's not 'Running', you can bring it up with docker-machine start

  You should have this in your profile:

  ### Docker
  export DOCKER_TLS_VERIFY="1"
  export DOCKER_HOST="tcp://192.168.99.100:2376"
  export DOCKER_CERT_PATH="/Users/nathan/.docker/machine/machines/default"
  export DOCKER_MACHINE_NAME="default"

  and, you should have this in your /etc/hosts

  ## Docker Machine
  192.168.99.100 docker d

  So, you can access local running containers, by going to:

  http://d:<port of container>
INFO
}

function dock_help {
cat <<-HELP
  # list local images
  docker images

  # build a tagged docker docker image;
  docker build -t <tag name> <folder>;

  ## Example:
  docker build -t chicksphotocracy/photoop:latest .

  # run a docker image as a daemon on a port;
  docker run -d --name <give it a name> -p <inside port : outside port> <tag>;

  ## Example:
  docker run -t -i -p 5678:5678 chicksphotocracy/photoop:1.9.0

  # run bash in a container;
  docker exec -ti <name, tag, or id> bash;

  # remove an image
  docker rmi <tag, name, id>

  # remove a container
  docker rm <tag, name, id>

HELP
}

function dock () {
  if [ -z "$1" ]; then
    dock_usage;
  else
    [ "$1" = "clean" ] && dock_clean "$2"
    [ "$1" = "info" ] && dock_info
    [ "$1" = "help" ] && dock_help
 fi
}
