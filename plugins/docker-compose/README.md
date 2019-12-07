# Docker-compose

This plugin provides completion for [docker-compose](https://docs.docker.com/compose/) as well as some
aliases for frequent docker-compose commands.

To use it, add docker-compose to the plugins array of your zshrc file:
```
plugins=(... docker-compose)
```

## Aliases

| Alias     | Command                  | Description                                                      |
|-----------|--------------------------|------------------------------------------------------------------|
| dco       | `docker-compose`         | Docker-compose main command                                      |
| dcb       | `docker-compose build`   | Build containers                                                 |
| dce       | `docker-compose exec`    | Execute command inside a container                               |
| dcps      | `docker-compose ps`      | List containers                                                  |
| dcrestart | `docker-compose restart` | Restart container                                                |
| dcrm      | `docker-compose rm`      | Remove container                                                 |
| dcr       | `docker-compose run`     | Run a command in container                                       |
| dcstop    | `docker-compose stop`    | Stop a container                                                 |
| dcup      | `docker-compose up`      | Build, (re)create, start, and attach to containers for a service |
| dcupd     | `docker-compose up -d`   | Same as `dcup`, but starts as daemon                             |
| dcdn      | `docker-compose down`    | Stop and remove containers                                       |
| dcl       | `docker-compose logs`    | Show logs of container                                           |
| dclf      | `docker-compose logs -f` | Show logs and follow output                                      |
| dcpull    | `docker-compose pull`    | Pull image of a service                                          |
| dcstart   | `docker-compose start`   | Start a container                                                |

## ENV

Use `DCO_FILE` to set docker-compose yaml file to be used.

```sh
# for one time use
$ DCO_FILE=docker-compose.dev.yml dcps
# = docker-compose -f docker-compose.dev.yml ps

# for long time use (during a whole session)
$ export DCO_FILE=docker-compose.dev.yml
$ dcupd
# = docker-compose -f docker-compose.dev.yml up -d
$ dcps
# = docker-compose -f docker-compose.dev.yml ps
```
