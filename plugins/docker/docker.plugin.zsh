# Show only the latest created container ID
alias dl="docker ps -l -q"

# Show all containers
alias ds="docker ps -a"

# List images
alias dim="docker images"

# Check IP Address of specific container
alias dip="docker inspect --format=\"{{ .NetworkSettings.IPAddress }}\""

# Remove all containers.
drm() { docker rm $(docker ps -q -a); }

# Stop all containers
dst() { docker stop $(docker ps -q -a); }

# Kill all running containers.
alias dockerkillall='docker kill $(docker ps -q)'

# Delete all stopped containers.
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

# Delete all untagged images.
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

# Delete all stopped containers and untagged images.
alias dockerclean='dockercleanc || true && dockercleani'
