function dock_usage () {
cat <<-USAGE

  usage: dock <command>

    clean             Remove all stopped containers
    help              show Docker cheat sheet
USAGE
}

function dock_clean {
  docker rm $(docker ps -a -q);

  [ "$1" = "images" ] && docker rmi $(docker images -q);
}

function dock_help {
cat <<-HELP
  # list local images
  docker images

  # build a tagged docker image;
  docker build -t <tag name> <folder>;

  # run a docker image as a daemon on a port;
  docker run -d --name <give it a name> -p <inside port : outside port> <tag>;

  # run bash in a container;
  docker exec -ti <name, tag, or id> bash;

  # remove an image
  docker rmi <tag, name, id>

  # remove a container
  docker rm <tag, name, id>

  # view logs from a container
  docker logs -f <tag, name, id>
HELP
}

function dock () {
  if [ -z "$1" ]; then
    dock_usage;
  else
    [ "$1" = "clean" ] && dock_clean "$2"
    [ "$1" = "help" ] && dock_help
 fi
}
