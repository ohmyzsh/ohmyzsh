<<<<<<< HEAD
# Docker-compose plugin for oh my zsh

A copy of the completion script from the [docker-compose](1) git repo.

[1]:[https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose]
=======
# Docker-compose

This plugin provides completion for [docker-compose](https://docs.docker.com/compose/) as well as some
aliases for frequent docker-compose commands.

To use it, add docker-compose to the plugins array of your zshrc file:

```zsh
plugins=(... docker-compose)
```

## Aliases

| Alias     | Command                        | Description                                                      |
|-----------|--------------------------------|------------------------------------------------------------------|
| dco       | `docker-compose`               | Docker-compose main command                                      |
| dcb       | `docker-compose build`         | Build containers                                                 |
| dce       | `docker-compose exec`          | Execute command inside a container                               |
| dcps      | `docker-compose ps`            | List containers                                                  |
| dcrestart | `docker-compose restart`       | Restart container                                                |
| dcrm      | `docker-compose rm`            | Remove container                                                 |
| dcr       | `docker-compose run`           | Run a command in container                                       |
| dcstop    | `docker-compose stop`          | Stop a container                                                 |
| dcup      | `docker-compose up`            | Build, (re)create, start, and attach to containers for a service |
| dcupb     | `docker-compose up --build`    | Same as `dcup`, but build images before starting containers      |
| dcupd     | `docker-compose up -d`         | Same as `dcup`, but starts as daemon                             |
| dcdn      | `docker-compose down`          | Stop and remove containers                                       |
| dcl       | `docker-compose logs`          | Show logs of container                                           |
| dclf      | `docker-compose logs -f`       | Show logs and follow output                                      |
| dcpull    | `docker-compose pull`          | Pull image of a service                                          |
| dcstart   | `docker-compose start`         | Start a container                                                |
| dck       | `docker-compose kill`          | Kills containers                                                 |
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
