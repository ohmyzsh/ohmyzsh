# Useful aliases
drexited() {
      docker rm `sudo docker ps -a | grep Exited | awk '{print $1 }'`
}

druntagged() {
      docker rmi $(sudo docker images -a | grep "^<none>" | awk '{print $3}')
}      
