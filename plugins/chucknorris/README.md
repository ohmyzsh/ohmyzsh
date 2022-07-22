# chucknorris

Chuck Norris fortunes plugin for Oh My Zsh. Perfectly suitable as MOTD.

To use it add `chucknorris` to the plugins array in you zshrc file.

```zsh
plugins=(... chucknorris)
```

## Usage

| Command     | Description                     |
| ----------- | ------------------------------- |
| `chuck`     | Print random Chuck Norris quote |
| `chuck_cow` | Print quote in cowthink         |

Example: output of `chuck_cow`:

```
Last login: Fri Jan 30 23:12:26 on ttys001
 ______________________________________
( When Chuck Norris plays Monopoly, it )
( affects the actual world economy.    )
 --------------------------------------
        o   ^__^
         o  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```

## Requirements

- `fortune`
- `cowsay` if using `chuck_cow`

Available via homebrew, apt, ...
