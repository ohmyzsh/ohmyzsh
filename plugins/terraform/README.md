# Terraform plugin

Plugin for Terraform, a tool from Hashicorp for managing infrastructure safely and efficiently.
It adds completion for `terraform`, as well as aliases and a prompt function.

To use it, add `terraform` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... terraform)
```

## Requirements

* [Terraform](https://terraform.io/)

## Aliases

| Alias | Command              |
| ----- | -------------------- |
| `tf`  | `terraform`          |
| `tfa` | `terraform apply`    |
| `tfc` | `terraform console`  |
| `tfd` | `terraform destroy`  |
| `tff` | `terraform fmt`      |
| `tfi` | `terraform init`     |
| `tfo` | `terraform output`   |
| `tfp` | `terraform plan`     |
| `tfv` | `terraform validate` |

## Prompt function

You can add the current Terraform workspace in your prompt by adding `$(tf_prompt_info)`
to your `PROMPT` or `RPROMPT` variable.

```sh
RPROMPT='$(tf_prompt_info)'
```

You can also specify the PREFIX and SUFFIX for the workspace with the following variables:

```sh
ZSH_THEME_TF_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TF_PROMPT_SUFFIX="%{$reset_color%}"
```
