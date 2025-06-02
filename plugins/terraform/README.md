# Terraform plugin

Plugin for Terraform, a tool from Hashicorp for managing infrastructure safely and efficiently. It adds
completion for `terraform`, as well as aliases and a prompt function.

To use it, add `terraform` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... terraform)
```

## Requirements

- [Terraform](https://terraform.io/)

## Aliases

| Alias   | Command                                |
| ------- | -------------------------------------- |
| `tf`    | `terraform`                            |
| `tfa`   | `terraform apply`                      |
| `tfaa`  | `terraform apply -auto-approve`        |
| `tfc`   | `terraform console`                    |
| `tfd`   | `terraform destroy`                    |
| `tfd!`  | `terraform destroy -auto-approve`      |
| `tff`   | `terraform fmt`                        |
| `tffr`  | `terraform fmt -recursive`             |
| `tfi`   | `terraform init`                       |
| `tfir`  | `terraform init -reconfigure`          |
| `tfiu`  | `terraform init -upgrade`              |
| `tfiur` | `terraform init -upgrade -reconfigure` |
| `tfo`   | `terraform output`                     |
| `tfp`   | `terraform plan`                       |
| `tfv`   | `terraform validate`                   |
| `tfs`   | `terraform state`                      |
| `tft`   | `terraform test`                       |
| `tfsh`  | `terraform show`                       |

## Prompt function

You can add the current Terraform workspace in your prompt by adding `$(tf_prompt_info)`,
`$(tf_version_prompt_info)` to your `PROMPT` or `RPROMPT` variable.

```sh
RPROMPT='$(tf_prompt_info)'
RPROMPT='$(tf_version_prompt_info)'
```

You can also specify the PREFIX and SUFFIX for the workspace with the following variables:

```sh
ZSH_THEME_TF_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TF_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_TF_VERSION_PROMPT_PREFIX="%{$fg[white]%}"
ZSH_THEME_TF_VERSION_PROMPT_SUFFIX="%{$reset_color%}"
```
