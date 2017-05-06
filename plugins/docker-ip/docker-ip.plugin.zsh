#
# To get an IP of a container, simply do this:
#   docker-ip YOUR_CONTAINER_ID

docker-ip() {
  docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
}
