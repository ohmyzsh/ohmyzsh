# Podman Compose Plugin

This plugin provides aliases for working with `podman-compose` (or `podman compose`, based on availability) to simplify multi-container Podman workflows.

To use it, add `podman-compose` to the plugins array in your `.zshrc` file.

```zsh
plugins=(... podman-compose)
```

## Aliases

| Alias     | Command                                       | Description                                                                              |
| :------   | :-------------------------------------------- | :--------------------------------------------------------------------------------------- |
| pco       | `podman-compose`                              | Alias for podman-compose or podman compose                                               |
| pcb       | `podman-compose build`                        | Build images for all services defined in the compose file                                |
| pce       | `podman-compose exec`                         | Execute a command in a running container defined in the compose file                     |
| pcps      | `podman-compose ps`                           | List all containers defined in the compose project                                       |
| pcrestart | `podman-compose restart`                      | Restart all or specific containers in the compose project                                |
| pcrm      | `podman-compose rm`                           | Remove stopped containers and networks                                                   |
| pcr       | `podman-compose run`                          | Run a one-off command in a new container                                                 |
| pcstop    | `podman-compose stop`                         | Stop all running containers in the compose project                                       |
| pcup      | `podman-compose up`                           | Create and start all containers defined in the compose file                              |
| pcupb     | `podman-compose up --build`                   | Build and start all services                                                             |
| pcupd     | `podman-compose up -d`                        | Start all services in detached mode                                                      |
| pcupdb    | `podman-compose up -d --build`                | Build images if needed, then start all services in detached mode                         |
| pcdn      | `podman-compose down`                         | Stop and remove containers, networks, images, and volumes                                |
| pcl       | `podman-compose logs`                         | Display logs from all containers in the compose project                                  |
| pclf      | `podman-compose logs -f`                      | Follow logs output in real-time                                                          |
| pclF      | `podman-compose logs -f --tail 0`             | Follow logs and display only new output                                                  |
| pcpull    | `podman-compose pull`                         | Pull service images                                                                      |
| pcstart   | `podman-compose start`                        | Start all stopped containers                                                             |
| pck       | `podman-compose kill`                         | Forcefully stop all running containers                                                   |


