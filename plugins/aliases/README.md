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

- `acs`: show all aliases by group.

- `acs -h/--help`: print help mesage.

- `acs <keyword>`: filter aliases by `<keyword>` and highlight.

- `acs -g <group>/--group <group`: show only aliases for group `<group>`. Multiple uses of the flag show all groups,

- `acs --groups-only`: show only group names

  ![screenshot](https://cloud.githubusercontent.com/assets/3602957/11581913/cb54fb8a-9a82-11e5-846b-5a67f67ad9ad.png)
