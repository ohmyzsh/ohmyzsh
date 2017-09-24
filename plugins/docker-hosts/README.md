### docker-hosts

docker hosts is a simple zsh plugin to make managing multiple docker hosts easily.

#### Usage

dh-init: initializes the plugin dir and files for use

dh-add (nickname) (host IP/FQDN): adds a host with a nickname to the hosts list

dh-delete (nickname/IP/FQDN): removes the given host from the list

dh-list: shows all hosts in the hostlist

dh-set (nickname): sets the $DOCKER_HOST variable to the given host

dh-set-default (nickname): sets the host that will be automaticly loaded on shell startup

dh-current: shows the current $DOCKER_HOST vaule

dh-clear: clears the DOCKER_HOST and allows docker to connect to localhost
