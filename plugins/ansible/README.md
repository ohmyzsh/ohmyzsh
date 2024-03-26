# ansible plugin

## Introduction

The `ansible plugin` adds several aliases for useful [ansible](https://docs.ansible.com/ansible/latest/index.html) commands and [aliases](#aliases).

To use it, add `ansible` to the plugins array of your zshrc file:

```
plugins=(... ansible)
```

## Aliases

| Command                                    | Description                                                         |
|:-------------------------------------------|:--------------------------------------------------------------------|
| `ansible-version` / `aver`                 | Show the version on ansible installed in this host                  |
| `ansible-role-init <role name>` / `arinit` | Creates the Ansible Role as per Ansible Galaxy standard             |
| `a`                                        | command `ansible`                                                   |
| `aconf`                                    | command `ansible-config`                                            |
| `acon`                                     | command `ansible-console`                                           |
| `ainv`                                     | command `ansible-inventory`                                         |
| `aplaybook`                                | command `ansible-playbook`                                          |
| `adoc`                                     | command `ansible-doc`                                               |
| `agal`                                     | command `ansible-galaxy`                                            |
| `apull`                                    | command `ansible-pull`                                              |
| `aval`                                     | command `ansible-vault`                                             |

## Maintainer

### [Deepankumar](https://github.com/deepan10)

[https://github.com/deepan10/oh-my-zsh/tree/features/ansible-plugin](https://github.com/deepan10/oh-my-zsh/tree/features/ansible-plugin)
