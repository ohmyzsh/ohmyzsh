# Terragrunt plugin

Terragrunt is a thin wrapper for opentofu/terraform that provides extra tools
and features to enhance the management of Infrastructure as Code (IaC) using
opentofu/terraform. This plugin adds completion for `terragrunt` command, as well
as aliases and a prompt function.

To use it, add `terragrunt` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... terragrunt)
```

## Requirements

- [Terragrunt](https://docs.terragrunt.com/) v0.77.22 or later

## Aliases

| Alias  | Command                                   |
| ------ | ----------------------------------------- |
| `tg`   | `terragrunt`                              |
| `tga`  | `terragrunt run -- apply`                 |
| `tgaa` | `terragrunt run -- apply -auto-approve`   |
| `tgc`  | `terragrunt run -- console`               |
| `tgd`  | `terragrunt run -- destroy`               |
| `tgd!` | `terragrunt run -- destroy -auto-approve` |
| `tgi`  | `terragrunt run -- init`                  |
| `tgo`  | `terragrunt run -- output`                |
| `tgp`  | `terragrunt run -- plan`                  |
| `tgv`  | `terragrunt run -- validate`              |
| `tgs`  | `terragrunt run -- state`                 |
| `tgsh` | `terragrunt run -- show`                  |
| `tgr`  | `terragrunt run -- refresh`               |
| `tgt`  | `terragrunt run -- test`                  |
| `tgws` | `terragrunt run -- workspace`             |

## Prompt function

- `terragrunt_version_prompt_info` shows the current version of the `terragrunt` command.

To use it, add it to a `PROMPT` or `RPROMPT` variable in your theme or `.zshrc` file.

```sh
RPROMPT='$(terragrunt_version_prompt_info)'
```

You can also specify the PREFIX and SUFFIX strings with the following variables.

```sh
ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
```
