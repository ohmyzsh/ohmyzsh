# toolbox plugin

Plugin for [toolbox](https://containertoolbx.org), a tool to use containerized CLI environments.

To use it, add `toolbox` to your plugins array in your `.zshrc` file:

```zsh
plugins=(... toolbox)
```

## Prompt function

This plugins adds `toolbox_prompt_info()` function. Using it in your prompt, it will show the toolbox indicator ⬢ (if you are running in a toolbox container), and nothing if not.

You can use it by adding `$(toolbox_prompt_info)` to your `PROMPT` or `RPROMPT` variable:

```zsh
RPROMPT='$(toolbox_prompt_info)'
```

## Aliases

| Alias | Command              | Description                            |
|-------|----------------------|----------------------------------------|
| tbe   | `toolbox enter`      | Enters the toolbox environment         |
| tbr   | `toolbox run`        | Run a command in an existing toolbox   |
