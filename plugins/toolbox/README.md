# toolbox plugin

Plugin for [toolbox](https://containertoolbx.org), a tool to use containerized CLI environments.

To use it, add `toolbox` to your plugins array in your `.zshrc` file:

```zsh
plugins=(... toolbox)
```

## Prompt function

This plugin provides the `toolbox_prompt_info()` function. Use this in your prompt to show the toolbox indicator (`⬢`) if you are running in a toolbox container, and nothing if not.

You can use it by adding `$(toolbox_prompt_info)` to your `PROMPT` or `RPROMPT` variable:

```zsh
RPROMPT='$(toolbox_prompt_info)'
```

Additionally, this also provides `toolbox_prompt_info_name()`, which will display the toolbox name following the toolbox indicator (e.g. `⬢ example`).

```zsh
RPROMPT='$(toolbox_prompt_info_name)'
```

## Aliases

| Alias | Command              | Description                            |
|-------|----------------------|----------------------------------------|
| tb    | `toolbox enter`      | Enters the toolbox environment         |


## Completion

As of version `0.0.99.3`, toolbox includes shell completion commands via `toolbox completion`. This plugin will load these completions if available.
