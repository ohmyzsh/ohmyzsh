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

| Alias    | Command                                                                                                               |
| -------- | --------------------------------------------------------------------------------------------------------------------- |
| `tf`     | `terraform`                                                                                                           |
| `tfi`    | `terraform init`                                                                                                      |
| `tff`    | `terraform fmt`                                                                                                       |
| `tffr`   | `terraform fmt -recursive`                                                                                            |
| `tfv`    | `terraform validate`                                                                                                  |
| `tfp`    | `terraform plan`                                                                                                      |
| `tfa`    | `terraform apply`                                                                                                     |
| `tfa!`   | `terraform apply -auto-approve`                                                                                       |
| `tfd`    | `terraform destroy`                                                                                                   |
| `tfd!`   | `terraform destroy -auto-approve`                                                                                     |
| `tfc`    | `terraform console`                                                                                                   |
| `tfo`    | `terraform output`                                                                                                    |
| `tfall`  | `terraform init && terraform fmt -recursive && terraform validate && terraform plan && terraform apply`               |
| `tfall!` | `terraform init && terraform fmt -recursive && terraform validate && terraform plan && terraform apply -auto-approve` |

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
