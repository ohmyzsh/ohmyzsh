## Forge plugin

The Forge plugin provides completion and useful aliases for
[Foundry Forge](https://getfoundry.sh/forge/overview), a command-line tool that tests, builds, and deploys
smart contracts.

To use it, add `forge` to the plugins array of your zshrc file:

```zsh
plugins=(... forge)
```

## Aliases

| Alias     | Command          | Description              |
| :-------- | :--------------- | :----------------------- |
| `finit`   | `forge init`     | Initialize a new project |
| `fb`      | `forge build`    | Build the project        |
| `fcmp`    | `forge compile`  | Compile contracts        |
| `ft`      | `forge test`     | Run tests                |
| `fdoc`    | `forge doc`      | Generate documentation   |
| `ffmt`    | `forge fmt`      | Format code              |
| `fl`      | `forge lint`     | Lint code                |
| `fsnap`   | `forge snapshot` | Create a snapshot        |
| `fcov`    | `forge coverage` | Generate coverage report |
| `ftree`   | `forge tree`     | Show dependency tree     |
| `fcl`     | `forge clean`    | Clean build artifacts    |
| `fgeiger` | `forge geiger`   | Run geiger (security)    |
| `fcfg`    | `forge config`   | Show configuration       |
| `fupd`    | `forge update`   | Update dependencies      |
| `fbind`   | `forge bind`     | Generate bindings        |

## Requirements

This plugin requires [Foundry](https://book.getfoundry.sh/getting-started/installation) to be installed and
the `forge` command to be available in your PATH.
