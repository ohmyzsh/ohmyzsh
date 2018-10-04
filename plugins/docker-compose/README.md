# Docker-compose plugin for oh my zsh

A copy of the completion script from the [docker-compose](https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose) git repo.

## Aliases

| Alias    | Command                                   | Description                                                 |
|-------   |-------------------------------------------|-------------------------------------------------------------|
| dco      | `docker-compose`                          | Docker compose
| dcb      | `docker-compose build`                    | Build containers
| dce      | `docker-compose exec`                     | Execute command inside a container
| dcps     | `docker-compose ps`                       | Lists containers
| dcrestart| `docker-compose restart`                  | Restat container
| dcrm     | `docker-compose rm`                       | Remove container
| dcr      | `docker-compose run`                      | Runs a command in container
| dcstop   | `docker-compose stop`                     | Stop a container
| dcup     | `docker-compose up`                       | Builds, (re)creates, starts, and attaches to containers for a service.
| dcupd    | `docker-compose up -d`                    | Same as dcup, but starts as daemon
| dcdn     | `docker-compose down`                     | Stops and removes containers
| dcl      | `docker-compose logs`                     | Show logs of container
| dclf     | `docker-compose logs -f`                  | Show logs and follow output
| dcpull   | `docker-compose pull`                     | Pull image of a service
| dcstart  | `docker-compose start`                    | Start a container