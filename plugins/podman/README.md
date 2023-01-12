# Podman plugin

This plugin adds auto-completion and aliases for [podman](https://podman.io/).

To use it add `podman` to the plugins array in your zshrc file.

```zsh
plugins=(... podman)
```

A copy of the completion script from the podman/cli git repo:
https://github.com/containers/podman/blob/main/completions/zsh/_podman

## Settings

By default, the completion doesn't allow option-stacking, meaning if you try to complete
`podman container run -it <TAB>` it won't work, because you're _stacking_ the `-i` and `-t` options.

## Aliases

| Alias   | Command                                 | Description                                                                              |
|:--------|:----------------------------------------|:-----------------------------------------------------------------------------------------|
| pcin    | `podman container inspect`              | Display detailed information on one or more containers                                   |
| pcls    | `podman container ls`                   | List all the running podman containers                                                   |
| pclsa   | `podman container ls -a`                | List all running and stopped containers                                                  |
| pib     | `podman image build`                    | Build an image from a Dockerfile                                                         | 
| pii     | `podman image inspect`                  | Display detailed information on one or more images                                       |
| pils    | `podman image ls`                       | List podman images                                                                       |
| pipu    | `podman image push`                     | Push an image or repository to a remote registry                                         |
| pirm    | `podman image rm`                       | Remove one or more images                                                                |
| pit     | `podman image tag`                      | Add a name and tag to a particular image                                                 |
| plo     | `podman container logs`                 | Fetch the logs of a podman container                                                     |
| pnc     | `podman network create`                 | Create a new network                                                                     |
| pncn    | `podman network connect`                | Connect a container to a network                                                         |
| pndcn   | `podman network disconnect`             | Disconnect a container from a network                                                    |
| pni     | `podman network inspect`                | Return information about one or more networks                                            |
| pnls    | `podman network ls`                     | List all networks the engine daemon knows about, including those spanning multiple hosts |
| pnrm    | `podman network rm`                     | Remove one or more networks                                                              |
| ppo     | `podman container port`                 | List port mappings or a specific mapping for the container                               |
| ppu     | `podman image pull`                     | Pull an image or a repository from a registry                                            |
| pr      | `podman container run`                  | Create a new container and start it using the specified command                          |
| prit    | `podman container run -it`              | Create a new container and start it in an interactive shell                              |
| prm     | `podman container rm`                   | Remove the specified container(s)                                                        |
| prm!    | `podman container rm -f`                | Force the removal of a running container (uses SIGKILL)                                  |
| prs     | `podman container restart`              | Restart one or more containers                                                           |
| pst     | `podman container start`                | Start one or more stopped containers                                                     |
| psta    | `podman stop $(podman container ls -q)` | Stop all running containers                                                              |
| pstp    | `podman container stop`                 | Stop one or more running containers                                                      |
| ptop    | `podman container top`                  | Display the running processes of a container                                             |
| pvi     | `podman volume inspect`                 | Display detailed information about one or more volumes                                   |
| pvls    | `podman volume ls`                      | List all the volumes known to podman                                                     |
| pvprune | `podman volume prune`                   | Cleanup dangling volumes                                                                 |
| pxc     | `podman container exec`                 | Run a new command in a running container                                                 |
| pxcit   | `podman container exec -it`             | Run a new command in a running container in an interactive shell                         |
