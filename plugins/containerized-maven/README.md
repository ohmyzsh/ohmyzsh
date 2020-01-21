# Containerized Maven Plugin for zsh

This plugin makes all Maven commands available to your shell without having
Maven installed.

## Pre-Requisites

You must have Docker installed and belong to the `docker` group. In other
words, you need to be able to run a container without sudo.

## Installation

### Antigen

```zsh
antigen bundle hermitmaster/containerized-maven
```

### Oh-My-Zsh

```zsh
git clone git@github.com:hermitmaster/containerized-maven.git \
  ${HOME}/.oh-my-zsh/cutom/plugins/
```
