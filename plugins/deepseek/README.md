# deepseek

This plugin adds the `ds` command, which turns natural language queries into
shell commands using the DeepSeek API. The generated command is echoed to the
terminal, pushed onto the next prompt line (ready to execute or edit), and
copied to the system clipboard.

To use it, add `deepseek` to the plugins array in your `.zshrc` file:

```zsh
plugins=(... deepseek)
```

## Requirements

- [curl](https://curl.se/)
- [jq](https://jqlang.github.io/jq/)
- A [DeepSeek API key](https://platform.deepseek.com/api_keys)

## Configuration

Set your API key as an environment variable (e.g. in `.zshrc` or `.zprofile`):

```zsh
export DEEPSEEK_API_KEY="sk-..."
```

## Usage

```zsh
# Ask for a command in plain English (or any language)
ds find the 10 largest files in the current directory

# The output looks like:
#   find . -type f -exec du -h {} + | sort -rh | head -10
#   $ █
#
# The command is:
#   1. Printed to the terminal for review
#   2. Copied to the system clipboard
#   3. Pre-filled on the next prompt line — press Enter to run it,
#      or edit it first
```

The system prompt instructs the model to respond with **only** the shell command
or code — no explanations, no markdown formatting.

## Commands

| Command | Description                              |
| ------- | ---------------------------------------- |
| `ds`    | Query DeepSeek for a shell command       |

## Cross-platform clipboard

| Platform      | Clipboard tool          |
| ------------- | ----------------------- |
| macOS         | `pbcopy`                |
| Linux (X11)   | `xclip`                 |
| Linux (Wayland)| `wl-copy`              |
