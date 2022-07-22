# npm plugin

The npm plugin provides completion as well as adding many useful aliases.

To use it, add npm to the plugins array of your zshrc file:

```zsh
plugins=(... npm)
```

## Aliases

| Alias   | Command                      | Description                                                     |
|:------  |:-----------------------------|:----------------------------------------------------------------|
| `npmg`  | `npm i -g`                   | Install dependencies globally                                   |
| `npmS`  | `npm i -S`                   | Install and save to dependencies in your package.json           |
| `npmD`  | `npm i -D`                   | Install and save to dev-dependencies in your package.json       |
| `npmF`  | `npm i -f`                   | Force install from remote registries ignoring local cache       |
| `npmE`  | `PATH="$(npm bin)":"$PATH"`  | Run command from node_modules folder based on current directory |
| `npmO`  | `npm outdated`               | Check which npm modules are outdated                            |
| `npmU`  | `npm update`                 | Update all the packages listed to the latest version            |
| `npmV`  | `npm -v`                     | Check package versions                                          |
| `npmL`  | `npm list`                   | List installed packages                                         |
| `npmL0` | `npm ls --depth=0`           | List top-level installed packages                               |
| `npmst` | `npm start`                  | Run npm start                                                   |
| `npmt`  | `npm test`                   | Run npm test                                                    |
| `npmR`  | `npm run`                    | Run npm scripts                                                 |
| `npmP`  | `npm publish`                | Run npm publish                                                 |
| `npmI`  | `npm init`                   | Run npm init                                                    |
| `npmi`  | `npm info`                   | Run npm info                                                    |
| `npmSe` | `npm search`                 | Run npm search                                                  |

## `npm install` / `npm uninstall` toggle

The plugin adds a function that toggles between `npm install` and `npm uninstall` in
the current command or the last command, for up to 2 previous commands. **The default
key binding is pressing <kbd>F2</kbd> twice**.

You can change this key binding by adding the following line to your zshrc file:

```zsh
bindkey -M emacs '<seq>' npm_toggle_install_uninstall
bindkey -M vicmd '<seq>' npm_toggle_install_uninstall
bindkey -M viins '<seq>' npm_toggle_install_uninstall
```

where `<seq>` is a key sequence obtained by running `cat` and pressing the keyboard
sequence you want.
