# RushJS

This plugin adds aliases for frequent [rush](https://rushjs.io/) commands.

## Commands

The commands aliased are non-destructive; non of them ought to create, delete, or modify any non-generated files. There is a convenience alias (`rj`) where you can add your preferred impactful commands (e.g. `rj init`, `rj update`).

| Alias    | Command                    |
| -------- | -------------------------- |
| *rj*     | `rush`                     |
| *rji*    | `rush install`             |
| *rjb*    | `rush build`               |
| *rjbv*   | `rush build --verbose`     |
| *rjr*    | `rush rebuild`             |
| *rjrv*   | `rush rebuild --verbose`   |
| *rjcl*   | `rush clean`               |
| *rjp*    | `rush purge`               |
| *rjt*    | `rush test`                |
| *rjtv*   | `rush test --verbose`      |
| *rjc*    | `rush check`               |


## Installation

**Required**: You must install the rush monorepo manager yourself before you can use this plugin.

To use it, add `rushjs` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... rushjs)
```
