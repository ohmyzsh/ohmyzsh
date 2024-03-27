# OpenTofu plugin

Plugin for OpenTofu, a fork of Terraform that is open-source, community-driven, and managed by the Linux Foundation. It adds
completion for `tofu` command, as well as aliases and a prompt function.

To use it, add `opentofu` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... opentofu)
```

## Requirements

- [OpenTofu](https://opentofu.org/)

## Aliases

| Alias | Command         |
| ----- | --------------- |
| `tt`  | `tofu`          |
| `tta` | `tofu apply`    |
| `ttc` | `tofu console`  |
| `ttd` | `tofu destroy`  |
| `ttf` | `tofu fmt`      |
| `tti` | `tofu init`     |
| `tto` | `tofu output`   |
| `ttp` | `tofu plan`     |
| `ttv` | `tofu validate` |
| `tts` | `tofu state`    |
| `ttsh`| `tofu show`     |
| `ttr` | `tofu refresh`  |
| `ttt` | `tofu test`     |
| `ttws`| `tofu workspace`|


## Prompt function

You can add the current OpenTofu workspace in your prompt by adding `$(tofu_prompt_info)`,
`$(tofu_version_prompt_info)` to your `PROMPT` or `RPROMPT` variable.

```sh
RPROMPT='$(tofu_prompt_info)'
RPROMPT='$(tofu_version_prompt_info)'
```

You can also specify the PREFIX and SUFFIX for the workspace with the following variables:

```sh
ZSH_THEME_TOFU_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TOFU_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_TOFU_VERSION_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TOFU_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
```