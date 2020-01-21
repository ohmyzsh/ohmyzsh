# Containerized Ansible Plugin for zsh

This plugin makes all Ansible commands available to your shell without having
Ansible installed.

## Pre-Requisites

You must have Docker installed and belong to the `docker` group. In other
words, you need to be able to run a container without sudo.

## Installation

### Antigen

```zsh
antigen bundle hermitmaster/containerized-ansible
```

### Oh-My-Zsh

```zsh
git clone git@github.com:hermitmaster/containerized-ansible.git \
  ${HOME}/.oh-my-zsh/cutom/plugins/
```
