# npm plugin

The npm plugin provides completion as well as adding many useful aliases.

To use it, add npm to the plugins array of your zshrc file:

```zsh
plugins=(... npm)
```

## Aliases

| Alias   | Command                      | Descripton                                                      |
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
