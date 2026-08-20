# Crystal plugin

This plugin adds aliases for common commands used in dealing with [Crystal](https://crystal-lang.org) and [Crystal shards](https://crystal-lang.org/reference/the_shards_command/index.html) - package manager.

To use it, add `crystal` to the plugins array in your zshrc file:

```zsh
plugins=(... crystal)
```

## Aliases

| Alias | Command                       | Description                                                    |
|:------|:------------------------------|:---------------------------------------------------------------|
| cry   | `crystal`                     | language executable.                                           |
| cryb  | `crystal build`               | build an executable.                                           |
| crybr | `crystal build --release`     | build an executable (Compile in release mode).                 |
| cryr  | `crystal run`                 | build and run program.                                         |
| cryrr | `crystal run --release`       | build and run program (Compile in release mode).               |
| crys  | `crystal spec --order random` | build and run specs (in random order).                         |
| crysu | `crystal spec`                | build and run specs.                                           |
| sha   | `shards`                      | shard executable.                                              |
| shac  | `shards check`                | Verify all dependencies are installed.                         |
| shai  | `shards install`              | Install dependencies, creating or using the `shard.lock` file. |
| shal  | `shards list`                 | List installed dependencies.                                   |
| shao  | `shards outdated`             | List dependencies that are outdated.                           |
| shap  | `shards prune`                | Remove unused dependencies from `lib` folder.                  |
| shau  | `shards update`               | Update dependencies and `shard.lock`.                          |
| shav  | `shards version`              | Print the current version of the shard.                        |
