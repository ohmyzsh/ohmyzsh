# ansible plugin

The `ansible plugin` adds several aliases for useful
[ansible](https://docs.ansible.com/ansible/latest/index.html) commands and [aliases](#aliases).

To use it, add `ansible` to the plugins array of your zshrc file:

```
plugins=(... ansible)
```

## Aliases

| Command             | Description                 |
| :------------------ | :-------------------------- |
| `a`                 | command `ansible`           |
| `acon`              | command `ansible-console`   |
| `aconf`             | command `ansible-config`    |
| `adoc`              | command `ansible-doc`       |
| `agal`              | command `ansible-galaxy`    |
| `ainv`              | command `ansible-inventory` |
| `aplb`, `aplaybook` | command `ansible-playbook`  |
| `apull`             | command `ansible-pull`      |
| `atest`             | command `ansible-test`      |
| `aval`              | command `ansible-vault`     |

## Maintainer

### [PascalKont](https://github.com/PascalKont)
