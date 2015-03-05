function dock_usage () {
  echo
  echo  " usage: dock <command>"
  echo
  echo  "   clean             Remove all containers";
  echo  "   help              show Docker cheat sheet";
}

function dock_clean {
  docker rm $(docker ps -a -q);
}

function dock_help {
  echo
  echo "  # build a tagged docker docker image";
  echo "  docker build -t <tag name> <folder>";
  echo
  echo "  # run a docker image as a daemon on a port";
  echo "  docker run -d --name <give it a name> -p <inside port : outside port> <tag>";
  echo
  echo "  # run bash in a container";
  echo "  docker exec -ti <name, tag, or id> bash";
  echo
  echo "  # tunnel to boot2docker";
  echo "  boot2docker ssh -L 5000:localhost:5000";
}

function dock () {
  if [ -z "$1" ]; then
    dock_usage;
  else
    [ "$1" = "clean" ] && dock_clean "$2"
    [ "$1" = "help" ] && dock_help
 fi
}
