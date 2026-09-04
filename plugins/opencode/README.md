# opencode plugin

This plugin adds several aliases and shell completion for the [`opencode`](https://opencode.ai) command line tool from Anomaly Innovations.

To use it, add `opencode` to the plugins array of your `.zshrc` file:

```zsh
plugins=(... opencode)
```

## Installation

See the [opencode docs](https://opencode.ai/docs#install) for installation instructions.


## Aliases

|Alias|Command|Description|
|-|-|-|
|`oc`|`opencode`|Run the `opencode` command|
|`ocr`|`opencode run` |Run `opencode` with a message| 

## Completions

This plugin configures shell completion for the `opencode` command.
