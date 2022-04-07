# Docker plugin

This plugin adds auto-completion for [docker](https://www.docker.com/).

To use it add `docker` to the plugins array in your zshrc file.

```zsh
plugins=(... docker)
```

A copy of the completion script from the docker/cli git repo:
https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker

## Settings

By default, the completion doesn't allow option-stacking, meaning if you try to
complete `docker run -it <TAB>` it won't work, because you're _stacking_ the
`-i` and `-t` options.

[You can enable it](https://github.com/docker/cli/commit/b10fb43048) by **adding
the lines below to your zshrc file**, but be aware of the side effects:

> This enables Zsh to understand commands like `docker run -it
> ubuntu`. However, by enabling this, this also makes Zsh complete
> `docker run -u<tab>` with `docker run -uapprox` which is not valid. The
> users have to put the space or the equal sign themselves before trying
> to complete.
>
> Therefore, this behavior is disabled by default. To enable it:
>
> ```
> zstyle ':completion:*:*:docker:*' option-stacking yes
> zstyle ':completion:*:*:docker-*:*' option-stacking yes
> ```


## Aliases

| Alias   | Command                             | Description                                                                                      |
|:--------|:------------------------------------|:-------------------------------------------------------------------------------------------------|
| di      | `docker info`                       | System wide information regarding the Docker installation                                        |
| dlg     | `docker container logs`             | Fetch the logs of a docker container                                                             |
| dls     | `docker container ls`               | List all the running docker containers                                                           |
| dlsa    | `docker container ls -a`            | List all running and stopped containers                                                          |
| dr      | `docker container run`              | Create a new container and start it using the specified command                                  |
| drit    | `docker container run -it`          | Create a new container and start it in an interactive shell                                      |
| drm     | `docker container rm`               | Remove the specified container(s)                                                                |
| drmf    | `docker container rm -f`            | Force the removal of a running container (uses SIGKILL)                                          |
| dst     | `docker container start`            | Start one or more stopped containers                                                             |
| dstp    | `docker container stop`             | Stop one or more running containers                                                              |
| dt      | `docker top`                        | Display the running processes of a container                                                     |
| dv      | `docker version`                    | Show version information of the docker installation                                              |
| dpo     | `docker container port`             | List port mappings or a specific mapping for the container                                       |
| dpu     | `docker pull`                       | Pull an image or a repository from a registry                                                    |
| dx      | `docker container exec`             | Run a new command in a running container                                                         |
| dxit    | `docker container exec -it`         | Run a new command in a running container in an interactive shell                                 |
| dbl     | `docker build`                      | Build an image from a Dockerfile                                                                 |
| dhh     | `docker help`                       | List all the top level commands along with their description and options                         |
| dcin    | `docker container inspect`          | Display detailed information on one or more containers                                           |
| dpsa    | `docker container ps -a`            | Show all containers (similar to ls -a)                                                           |
|         |                                     | **Docker Images**                                                                                |
| dirm    | `docker image rm`                   | Remove one or more images                                                                        |
| dils    | `docker image ls`                   | List docker images                                                                               |
| dit     | `docker image tag`                  | Add a name and tag to a particular image                                                         |
| dip     | `docker image push`                 | Push an image or repository to a remote registry                                                 |
| dib     | `docker image build`                | Build an image from a Dockerfile (same as docker build)                                          |
| dii     | `docker image inspect`              | Display detailed information on one or more images                                               |
|         |                                     | **Docker Network**                                                                               |
| dnls    | `docker network ls`                 | List all networks the engine daemon knows about, including those spanning multiple hosts         |
| dni     | `docker network inspect`            | Return information about one or more networks                                                    |
| dnc     | `docker network create`             | Create a new network                                                                             |
| dncn    | `docker network connect`            | Connect a container to a network                                                                 |
| dndcn   | `docker network disconnect`         | Disconnect a container from a network                                                            |
| dnrm    | `docker network rm`                 | Remove one or more networks                                                                      |
|         |                                     | **Docker Volume**                                                                                |
| dvls    | `docker volume ls`                  | List all the volumes known to  docker                                                            |
| dvi     | `docker volume inspect`             | Display detailed information about one or more volumes                                           |
| dvclean | `docker volume rm $(docker volume ls -qf dangling=true)`| Cleanup dangling volumes                                                     |
