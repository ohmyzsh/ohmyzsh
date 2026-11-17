# bun-simple

This plugin adds zsh completion and convenient aliases for [Bun](https://bun.com), modeled after the
Oh My Zsh `npm` plugin.

To use it, add `bun-simple` to the plugins array in your `~/.zshrc` file:

```zsh
plugins=(... bun-simple)
```

## Completion

When `bun` is installed, the plugin automatically loads zsh completions via `SHELL=zsh bun completions`.

## Aliases

| Alias | Command | Description |
| :--- | :--- | :--- |
| `bung` | `bun add -g ` | Install dependencies globally |
| `bunA` | `bun add ` | Install and save to `dependencies` in `package.json` |
| `bunD` | `bun add -d ` | Install and save to `devDependencies` in `package.json` |
| `bunF` | `bun i -f` | Force bun to fetch remote resources and reinstall all dependencies |
| `bunE` | `PATH="$(bun pm bin 2>/dev/null \|\| printf "%s/node_modules/.bin" "$PWD")":"$PATH"` | Execute a command from local `node_modules/.bin` (e.g., `bunE eslint`) |
| `bunO` | `bun outdated` | Check which dependencies are outdated |
| `bunU` | `bun update` | Update dependencies to the latest compatible versions |
| `bunV` | `bun -v` | Check installed Bun version |
| `bunL` | `bun pm ls --all` | List all installed packages in the dependency tree |
| `bunL0` | `bun pm ls` | List top-level installed packages |
| `bunst` | `bun start` | Run the `start` script in `package.json` |
| `bunt` | `bun test` | Run tests with `bun test` |
| `bunR` | `bun run` | Run `package.json` scripts or files |
| `bunP` | `bun publish` | Publish a package to the npm registry |
| `bunI` | `bun init` | Initialize a new Bun project |
| `buni` | `bun info` | Display package metadata from the registry |
| `bunrd` | `bun run dev` | Run the `dev` script in `package.json` |
| `bunrb` | `bun run build` | Run the `build` script in `package.json` |

> [!NOTE]
> Bun does not include a built-in registry search command, so there is no `bunSe` counterpart to `npm search`.
