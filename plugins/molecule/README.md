# Molecule plugin

This plugin adds aliases and completion for [Molecule](https://ansible.readthedocs.io/projects/molecule/), the
project designed to aid in the development and testing of Ansible roles..

To use it, add `molecule` to the plugins array in your zshrc file:

```zsh
plugins=(... molecule)
```

## Aliases

| Alias | Command           | Description                                                                        |
| :---- | :---------------- | ---------------------------------------------------------------------------------- |
| mol   | molecule          | Molecule aids in the development and testing of Ansible roles.                     |
| mcr   | molecule create   | Use the provisioner to start the instances.                                        |
| mcon  | molecule converge | Use the provisioner to configure instances (dependency, create, prepare converge). |
| mls   | molecule list     | List status of instances.                                                          |
| mvf   | molecule verify   | Run automated tests against instances.                                             |
