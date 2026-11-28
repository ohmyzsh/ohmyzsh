# herdr plugin

This plugin adds completion, aliases, an interactive session picker and a prompt
function for [herdr](https://herdr.dev), the runtime your
coding agents live on. herdr keeps agent terminals running in the background across
projects and machines, so you can close your terminal, reconnect later, and pick up
where the agents left off.

To use it, add `herdr` to the plugins array in your zshrc file:

```zsh
plugins=(... herdr)
```

Install herdr first if you have not already:

```sh
curl -fsSL https://herdr.dev/install.sh | sh   # or: brew install herdr
```

## Learning herdr from the terminal

The fastest way to explore herdr is tab completion. Every command group and flag shows a
short description, so you can discover what is available without leaving the shell:

```
$ herdr <TAB>
agent         -- Control and inspect agent panes
session       -- Manage named persistent sessions
workspace     -- Manage workspaces over the socket API
worktree      -- Manage Git worktree-backed workspaces
...
$ herdr agent <TAB>
list          -- List agents
prompt        -- Submit a prompt to an agent
start         -- Start a supported interactive agent in an existing pane
wait          -- Wait until an agent reaches one of the requested states
...
```

A few other ways to learn as you go:

- `herdr <group>` with no subcommand prints that group's help, for example `herdr pane`.
- `herdr --skill` prints the instructions herdr gives to agents that drive it. It is a
  good tour of the full command surface.
- Most control commands return JSON, so you can pipe them into `jq` in scripts.

## Common workflows

### Start and reconnect

```sh
herdr                          # launch, or attach to the default session
herdr --session work           # use or create a named session
herdr session list             # see running and stopped sessions
herdr session attach work      # reconnect to a named session
herdr status                   # check the local client and running server
herdr update                   # install the latest release
```

### Organize work into workspaces and tabs

```sh
herdr workspace list
herdr workspace create --cwd ~/projects/app
herdr tab create
herdr pane split --direction right
herdr worktree create --branch feature/login   # open a Git worktree in its own workspace
```

### Run and watch agents

```sh
herdr agent list                               # what is running, and is it idle, working or blocked
herdr agent start reviewer --kind claude --pane w1:p2
herdr agent prompt reviewer "review the last commit" --wait
herdr agent read reviewer                      # read the agent's terminal output
herdr agent wait reviewer --until idle
herdr agent attach reviewer                    # jump straight into that terminal
```

### Work across machines

```sh
herdr --remote user@build-box                  # attach through SSH with your local keybindings
```

### Keep the server healthy

```sh
herdr config check                             # validate config.toml
herdr server reload-config                     # apply config changes without restarting panes
herdr server stop
herdr channel set preview                      # switch between stable and preview releases
herdr integration status                       # which agent CLIs have herdr hooks installed
```

See the [CLI reference](https://herdr.dev/docs/cli-reference/) for every command and flag.

## Aliases

| Alias   | Command                       |
| ------- | ----------------------------- |
| `hrdr`   | `herdr`                       |
| `hrdrst` | `herdr status`                |
| `hrdrup` | `herdr update`                |
| `hrdrsl` | `herdr session list`          |
| `hrdrsa` | `herdr session attach`        |
| `hrdrr`  | `herdr --remote`              |
| `hrdral` | `herdr agent list`            |
| `hrdrwl` | `herdr workspace list`        |
| `hrdrwc` | `herdr workspace create`      |
| `hrdrwt` | `herdr worktree create`       |
| `hrdrps` | `herdr pane split`            |
| `hrdrrc` | `herdr server reload-config`  |

Tab completion works through the aliases too, so `hrdr agent <TAB>` completes the same
way `herdr agent <TAB>` does.

## Session picker

`hrdrs` lists your herdr sessions and attaches to the one you pick. It uses
[fzf](https://github.com/junegunn/fzf) when it is installed and falls back to a numbered
menu otherwise, so it works everywhere.

```
$ hrdrs
name                 status   directory
1) default              running  /Users/me/.config/herdr
2) work                 stopped  /Users/me/projects/app
Attach to session: 2
```

## Prompt

This plugin provides the `herdr_prompt_info` function to show the current pane ID in
your prompt when the shell is running inside herdr. It reads environment variables only,
so it adds no cost to prompt rendering.

For example:
```
PROMPT="%~$ "
RPROMPT='$(herdr_prompt_info)'
```
changes your prompt inside a herdr pane to:
```
~/projects/app$ ▋                                                    w1:p4
```
and shows nothing outside herdr.

Wrap it with `ZSH_THEME_HERDR_PROMPT_PREFIX` and `ZSH_THEME_HERDR_PROMPT_SUFFIX`, for
example:
```
ZSH_THEME_HERDR_PROMPT_PREFIX="%{$fg[cyan]%}[herdr "
ZSH_THEME_HERDR_PROMPT_SUFFIX="]%{$reset_color%}"
```

## Cache

This plugin caches the completion script and automatically updates it when the plugin is
loaded, which is usually when you start a new terminal emulator.

The cache is stored at `$ZSH_CACHE_DIR/completions/_herdr`.
