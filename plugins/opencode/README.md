# opencode plugin

This plugin adds completion and aliases for the [OpenCode](https://opencode.ai) CLI.
Install OpenCode using its [installation instructions](https://opencode.ai/docs/#install),
and make sure `opencode` is available on your `$PATH`.

To enable it, add `opencode` to the plugins array in your `.zshrc`:

```zsh
plugins=(... opencode)
```

## Learning OpenCode from the terminal

Use tab completion to explore commands and their descriptions without leaving the
shell. For example, these are some of the candidates shown by the CLI:

```text
$ opencode <TAB>
agent         -- manage agents
models        -- list all available models
run           -- run opencode with a message
session       -- manage sessions
stats         -- show token usage and cost statistics
...

$ opencode session <TAB>
delete        -- delete a session
list          -- list sessions

$ opencode run --<TAB>
--agent       -- agent to use
--continue    -- continue the last session
--file        -- file(s) to attach to message
--model       -- model to use in the format of provider/model
...
```

Completion works through the aliases too. Type a partial command or option and
press Tab to finish it:

```text
$ opc session li<TAB>
$ opc session list

$ opcr --att<TAB>
$ opcr --attach

$ opcc --log-l<TAB>
$ opcc --log-level
```

Candidates depend on your installed OpenCode version. In OpenCode 1.18.29, the
CLI's completion output omits top-level TUI flags such as `--model` and `--fork`,
even though those flags work when typed. Use `opencode --help` or
`opencode run --help` for the full options, and see the
[CLI reference](https://opencode.ai/docs/cli/) for more workflows.

## Aliases

| Alias  | Command               | Description                         |
| ------ | --------------------- | ----------------------------------- |
| `opc`  | `opencode`            | Launch the terminal UI              |
| `opcc` | `opencode --continue` | Continue the last session           |
| `opcr` | `opencode run`        | Run a prompt without opening the UI |

To keep completion but disable aliases, add this before sourcing Oh My Zsh:

```zsh
zstyle ':omz:plugins:opencode' aliases no
```

## Common workflows

All aliases accept additional arguments:

```zsh
# Open a project
opc ~/projects/my-app

# Explore a different approach by forking the last session
opcc --fork

# Ask a question without entering the terminal UI
opcr "Explain the test setup in this project"

# Reuse an already running backend to avoid MCP server cold starts
opcr --attach http://localhost:4096 "Explain this project's architecture"
```

## Completion

Completion queries the installed OpenCode CLI on demand for commands and options,
including through the aliases above. It falls back to Zsh's default completion when
the CLI returns no candidates. No OpenCode process is started at shell startup,
and no generated completion cache is needed.

## Credits

Based on the OpenCode plugin proposals by
[pranavavva](https://github.com/pranavavva) in
[#13545](https://github.com/ohmyzsh/ohmyzsh/pull/13545) and
[mskadu](https://github.com/mskadu) in
[#13794](https://github.com/ohmyzsh/ohmyzsh/pull/13794).
The completion adapter is derived from OpenCode's `opencode completion` output.
