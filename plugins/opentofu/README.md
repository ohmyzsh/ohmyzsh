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

| Alias  | Command                      |
|--------|------------------------------|
| `tt`   | `tofu`                       |
| `tta`  | `tofu apply`                 |
| `ttaa` | `tofu apply -auto-approve`   |
| `ttc`  | `tofu console`               |
| `ttd`  | `tofu destroy`               |
| `ttd!` | `tofu destroy -auto-approve` |
| `ttf`  | `tofu fmt`                   |
| `ttfr` | `tofu fmt -recursive`        |
| `tti`  | `tofu init`                  |
| `tto`  | `tofu output`                |
| `ttp`  | `tofu plan`                  |
| `ttv`  | `tofu validate`              |
| `tts`  | `tofu state`                 |
| `ttsh` | `tofu show`                  |
| `ttr`  | `tofu refresh`               |
| `ttt`  | `tofu test`                  |
| `ttws` | `tofu workspace`             |


## Prompt functions

- `tofu_prompt_info`: shows the current workspace when in an OpenTofu project directory.

- `tofu_version_prompt_info`: shows the current version of the `tofu` command.

To use them, add them to a `PROMPT` variable in your theme or `.zshrc` file:

```sh
PROMPT='$(tofu_prompt_info)'
RPROMPT='$(tofu_version_prompt_info)'
```

You can also specify the PREFIX and SUFFIX strings for both functions, with the following variables:

```sh
# for tofu_prompt_info
ZSH_THEME_TOFU_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TOFU_PROMPT_SUFFIX="%{$reset_color%}"
# for tofu_version_prompt_info
ZSH_THEME_TOFU_VERSION_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TOFU_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
```
