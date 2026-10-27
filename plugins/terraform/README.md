# Terraform plugin

Plugin for Terraform, a tool from Hashicorp for managing infrastructure safely and efficiently. It adds
completion for `terraform`, as well as aliases and a prompt function.

To use it, add `terraform` to the plugins array of your `~/.zshrc` file:

```shell
plugins=(... terraform)
```

## Requirements

- [Terraform](https://terraform.io/)
- [terraform-docs](https://terraform-docs.io/) (optional, for completion)

## terraform-docs completion

If `terraform-docs` is installed, this plugin also enables its completion.
The completion script is generated from the installed version and cached in
`$ZSH_CACHE_DIR/completions/_terraform-docs`. It is refreshed in the background
each time the plugin loads, so completion stays in sync with the installed CLI.

## Aliases

| Alias   | Command                                |
|---------|----------------------------------------|
| `tf`    | `terraform`                            |
| `tfa`   | `terraform apply`                      |
| `tfa!`  | `terraform apply -auto-approve`        |
| `tfap`  | `terraform apply -parallelism=1`       |
| `tfc`   | `terraform console`                    |
| `tfd`   | `terraform destroy`                    |
| `tfd!`  | `terraform destroy -auto-approve`      |
| `tfdp`  | `terraform destroy -parallelism=1`     |
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
| `tfw`   | `terraform workspace`                  |
| `tfwl`  | `terraform workspace list`             |
| `tfws`  | `terraform workspace select`           |

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
