# Git auto status

If you found yourself constantly typing `git status` after bunch of commands like
`git commit` and you want to avoid that, than this plugin is for you.

### Tuning

The default list of command that git status is automatically running after is
next:

```bash
gitPreAutoStatusCommands=(
    'add'
    'rm'
    'reset'
    'commit'
    'checkout'
)
```

You can adjust this list by setting this var in your **.zshrc** after
`plugins=(...)` initialization.

### Maintainers

[@oshybystyi](https://github.com/oshybystyi/)
