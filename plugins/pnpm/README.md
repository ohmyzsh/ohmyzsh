# pnpm plugin

The pnpm plugin provides completion as well as adding many useful aliases.

To use it, add pnpm to the plugins array of your zshrc file:

```zsh
plugins=(... pnpm)
```

## Aliases

| Alias    | Command                      | Description                                                     |
| :------- | :--------------------------- | :-------------------------------------------------------------- |
| `pnpmg`  | `pnpm add -g`                | Install dependencies globally                                   |
| `pnpmS`  | `pnpm add -S`                | Install and save to dependencies in your package.json           |
| `pnpmD`  | `pnpm add -D`                | Install and save to dev-dependencies in your package.json       |
| `pnpmF`  | `pnpm add -f`                | Force install from remote registries ignoring local cache       |
| `pnpmE`  | `PATH="$(pnpm bin)":"$PATH"` | Run command from node_modules folder based on current directory |
| `pnpmO`  | `pnpm outdated`              | Check which pnpm modules are outdated                           |
| `pnpmU`  | `pnpm update`                | Update all the packages listed to the latest version            |
| `pnpmV`  | `pnpm -v`                    | Check package versions                                          |
| `pnpmL`  | `pnpm list`                  | List installed packages                                         |
| `pnpmL0` | `pnpm ls --depth=0`          | List top-level installed packages                               |
| `pnpmst` | `pnpm start`                 | Run pnpm start                                                  |
| `pnpmt`  | `pnpm test`                  | Run pnpm test                                                   |
| `pnpmR`  | `pnpm run`                   | Run pnpm scripts                                                |
| `pnpmP`  | `pnpm publish`               | Run pnpm publish                                                |
| `pnpmI`  | `pnpm init`                  | Run pnpm init                                                   |
| `pnpmi`  | `pnpm info`                  | Run pnpm info                                                   |
| `pnpmSe` | `pnpm search`                | Run pnpm search                                                 |
| `pnpmrd` | `pnpm run dev`               | Run pnpm run dev                                                |
| `pnpmrb` | `pnpm run build`             | Run pnpm run build                                              |

## `pnpm install` / `pnpm uninstall` toggle

The plugin adds a function that toggles between `pnpm install` and `pnpm uninstall` in the current command or
the last command, for up to 2 previous commands. **The default key binding is pressing <kbd>F2</kbd> twice**.

You can change this key binding by adding the following line to your zshrc file:

```zsh
bindkey -M emacs '<seq>' pnpm_toggle_install_uninstall
bindkey -M vicmd '<seq>' pnpm_toggle_install_uninstall
bindkey -M viins '<seq>' pnpm_toggle_install_uninstall
```

where `<seq>` is a key sequence obtained by running `cat` and pressing the keyboard sequence you want.
