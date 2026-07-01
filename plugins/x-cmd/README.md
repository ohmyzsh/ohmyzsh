# X-CMD

To start using it, add the `x-cmd` plugin to your `plugins` array in `~/.zshrc`:

```zsh
plugins=(... x-cmd)
```

## Functions

### `x`

```zsh
x yq                # Using yq command to interract with YML. If yq is not avaiable in the machine. X-CMD will download and directly execute the binary on demand without installation. X-CMD try to avoid influence the environment and folder and always find the solution with least impact.

x fjo               # Posix shell CLI to interactve with forgejo.
x cb                # Posix shell CLI to interactve with codeberg.

x nihao             # For more information about using gpt, gemini, etc in terminal.
```

### `m`

m for `machine`.

In mac, it is [`x mac`](https://x-cmd.com/mod/mac).
In termux, it is [`x termux`](https://x-cmd.com/mod/termux).

```bash
m ss                        # Info about systemsetup
m app                       # List application status
m proxy enable 8090         # Set
```
