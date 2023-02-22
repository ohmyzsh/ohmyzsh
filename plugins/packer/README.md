# Packer plugin

Plugin for Packer, a tool from Hashicorp for managing docker safely and efficiently.
It adds aliases for `packer`

To use it, add `packer` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... packer)
```

## Requirements

* [packer](https://packer.io/)

## Aliases

| Alias    | Command                                                                           |
| -------- | --------------------------------------------------------------------------------- |
| `pkr`    | `packer`                                                                          |
| `pkri`   | `packer init .`                                                                   |
| `pkrf`   | `packer fmt . -recursive`                                                         |
| `pkrv`   | `packer validate .`                                                               |
| `pkrb`   | `packer build .`                                                                  |
| `pkrall` | `packer init . && packer fmt . -recursive && packer validate . && packer build .` |
