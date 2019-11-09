# Docker plugin

This plugin adds auto-completion for [docker](https://www.docker.com/).

To use it add `docker` to the plugins array in your zshrc file.
```zsh
plugins=(... docker)
```

A copy of the completion script from the docker/cli git repo:
https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker
