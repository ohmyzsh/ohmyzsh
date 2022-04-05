<<<<<<< HEAD
## Docker autocomplete plugin

- Adds autocomplete options for all docker commands.
- Will also show containerIDs and Image names where applicable

####Shows help for all commands
![General Help](http://i.imgur.com/tUBO9jh.png "Help for all commands")


####Shows your downloaded images where applicable
![Images](http://i.imgur.com/R8ZsWO1.png "Images")


####Shows your running containers where applicable
![Containers](http://i.imgur.com/WQtbheg.png "Containers")



Maintainer : Ahmed Azaan ([@aeonazaan](https://twitter.com/aeonazaan))
=======
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
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b
