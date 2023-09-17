# pnpm plugin

The pnpm plugin provides completion as well as adding many useful aliases.

To use it, add pnpm to the plugins array of your zshrc file:

```zsh
plugins=(... pnpm)
```

## Aliases

| Alias   | Command                        | Description                                                   |
|:------  |:-------------------------------|:--------------------------------------------------------------|
| `pnI`  | `pnpm install`                | Install project dependencies                                    |
| `pnga`  | `pnpm add -g`                | Install dependencies globally                                   |
| `pnA`  | `pnpm add `                   | Install and save to dependencies in your package.json           |
| `pnD`  | `pnpm add -D`                 | Install and save to dev-dependencies in your package.json       |
| `pnF`  | `pnpm add -f`                 | Force install from remote registries ignoring local cache       |
| `pnO`  | `pnpm outdated`               | Check which pnpm modules are outdated                           |
| `pnU`  | `pnpm update`                 | Update all the packages listed to the latest version            |
| `pnV`  | `pnpm -v`                     | Check package versions                                          |
| `pnL`  | `pnpm list`                   | List installed packages                                         |
| `pnL0` | `pnpm ls --depth=0`           | List top-level installed packages                               |
| `pnst` | `pnpm start`                  | Run pnpm start                                                  |
| `pnt`  | `pnpm test`                   | Run pnpm test                                                   |
| `pnR`  | `pnpm run`                    | Run pnpm scripts                                                |
| `pnP`  | `pnpm publish`                | Run pnpm publish                                                |
| `pnI`  | `pnpm init`                   | Run pnpm init                                                   |
| `pni`  | `pnpm info`                   | Run pnpm info                                                   |
| `pnSe` | `pnpm search`                 | Run pnpm search                                                 |
| `pnd` | `pnpm run dev`                | Run pnpm run dev                                                |
