# Podman-compose

This plugin provides completion for [podman-compose](https://github.com/containers/podman-compose) as well as some aliases for frequent podman-compose commands.

To use it, add podman-compose to the plugins array of your zshrc file:

```zsh
plugins=(... podman-compose)
```

## Aliases

| Alias     | Command                        | Description                                                                      |
|-----------|--------------------------------|----------------------------------------------------------------------------------|
| pco       | `podman-compose`               | Podman-compose main command                                                      |
| pcb       | `podman-compose build`         | Build containers                                                                 |
| pce       | `podman-compose exec`          | Execute command inside a container                                               |
| pcps      | `podman-compose ps`            | List containers                                                                  |
| pcrestart | `podman-compose restart`       | Restart container                                                                |
| pcrm      | `podman-compose rm`            | Remove container                                                                 |
| pcr       | `podman-compose run`           | Run a command in container                                                       |
| pcstop    | `podman-compose stop`          | Stop a container                                                                 |
| pcup      | `podman-compose up`            | Build, (re)create, start, and attach to containers for a service                 |
| pcupb     | `podman-compose up --build`    | Same as `pcup`, but build images before starting containers                      |
| pcupd     | `podman-compose up -d`         | Same as `pcup`, but starts as daemon                                             |
| pcupdb    | `podman-compose up -d --build` | Same as `pcup`, but build images before starting containers and starts as daemon |
| pcdn      | `podman-compose down`          | Stop and remove containers                                                       |
| pcl       | `podman-compose logs`          | Show logs of container                                                           |
| pclf      | `podman-compose logs -f`       | Show logs and follow output                                                      |
| pcpull    | `podman-compose pull`          | Pull image of a service                                                          |
| pcstart   | `podman-compose start`         | Start a container                                                                |
| pcpause   | `podman-compose pause`         | Pause a container                                                                |
| pck       | `podman-compose kill`          | Kills containers                                                                 |
