# Terragrunt plugin

Terragrunt is a thin wrapper for opentofu/terraform that provides extra tools
and features to enhance the management of Infrastructure as Code (IaC) using
opentofu/terraform. Ths plugin adds completion for `terragrunt` command, as well
as aliases and a prompt function.

To use it, add `terragrunt` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... terragrunt)
```

## Requirements

- [Terragrunt](https://terragrunt.gruntwork.io//)

## Aliases

| Alias  | Command                              |
|--------|--------------------------------------|
| `tg`   | `terragrunt`                               |
| `tga`  | `terragrunt -- apply`                 |
| `tgaa` | `terragrunt -- apply -auto-approve`   |
| `tgc`  | `terragrunt -- console`               |
| `tgd`  | `terragrunt -- destroy`               |
| `tgd!` | `terragrunt -- destroy -auto-approve` |
| `tgf`  | `terragrunt -- fmt`                   |
| `tgfr` | `terragrunt -- fmt -recursive`        |
| `tgi`  | `terragrunt -- init`                  |
| `tgo`  | `terragrunt -- output`                |
| `tgp`  | `terragrunt -- plan`                  |
| `tgv`  | `terragrunt -- validate`              |
| `tgs`  | `terragrunt -- state`                 |
| `tgsh` | `terragrunt -- show`                  |
| `tgr`  | `terragrunt -- refresh`               |
| `tgt`  | `terragrunt -- test`                  |
| `tgws` | `terragrunt -- workspace`             |

## Prompt functions

- `terragrunt_prompt_info`: shows the current workspace when in a Terragrunt project directory.

- `terragrunt_version_prompt_info`: shows the current version of the `terragrunt` command.

To use them, add them to a `PROMPT` variable in your theme or `.zshrc` file:

```sh
PROMPT='$(terragrunt_prompt_info)'
RPROMPT='$(terragrunt_version_prompt_info)'
```

You can also specify the PREFIX and SUFFIX strings for both functions, with the following variables:

```sh
# for terragrunt_prompt_info
ZSH_THEME_TERRAGRUNT_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TERRAGRUNT_PROMPT_SUFFIX="%{$reset_color%}"
# for terragrunt_version_prompt_info
ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TERRAGRUNT_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
```
