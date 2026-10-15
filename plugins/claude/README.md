# claude plugin

This plugin adds aliases for the [Claude Code](https://code.claude.com) CLI.
Install Claude Code using its [installation instructions](https://code.claude.com/docs/en/setup),
and make sure `claude` is available on your `$PATH`.

To enable it, add `claude` to the plugins array in your `.zshrc`:

```zsh
plugins=(... claude)
```

## Aliases

| Alias  | Command             | Description                               |
| ------ | ------------------- | ----------------------------------------- |
| `cla`  | `claude`            | Start an interactive session              |
| `clac` | `claude --continue` | Continue the most recent conversation     |
| `clar` | `claude --resume`   | Pick a past conversation to resume        |
| `clap` | `claude --print`    | Print a response without interactive mode |

To skip the aliases, set this in your `.zshrc`, above the line that sources
Oh My Zsh:

```zsh
# ~/.zshrc
zstyle ':omz:plugins:claude' aliases no

plugins=(... claude)

source $ZSH/oh-my-zsh.sh
```

## Common workflows

All aliases accept additional arguments:

```zsh
cla "Explain the test setup in this project"

clac

git diff | clap "Write a commit message for this diff"
```

Run `claude --help` for the full list of options, and see the
[CLI reference](https://code.claude.com/docs/en/cli-reference) for more workflows.
