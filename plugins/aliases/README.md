# Aliases cheatsheet

**Maintainer:** [@hqingyi](https://github.com/hqingyi)

With lots of 3rd-party amazing aliases installed, this plugin helps list the shortcuts
that are currently available based on the plugins you have enabled.

To use it, add `aliases` to the plugins array in your zshrc file:

```zsh
plugins=(aliases)
```

Requirements: Python needs to be installed.

## Usage

- `als`: show all aliases by group

- `als -h/--help`: print help message

- `als <keyword(s)>`: filter and highlight aliases by `<keyword>`

- `als -g <group>/--group <group>`: show only aliases for group `<group>`. Multiple uses of the flag show all groups

- `als --groups`: show only group names

  ![screenshot](https://github.com/ohmyzsh/ohmyzsh/assets/66907184/5bfa00ea-5fc3-4e97-8b22-2f74f6b948c7)
