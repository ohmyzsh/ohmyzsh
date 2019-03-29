## Terraform oh-my-zsh plugin

Plugin for Terraform, a tool from Hashicorp for managing infrastructure safely and efficiently.

Current as of Terraform v0.11.7

### Requirements

 * [Terraform](https://terraform.io/)

### Usage

 * Type `terraform` into your prompt and hit `TAB` to see available completion options

### Expanding ZSH prompt with current Terraform workspace name

If you want to get current Terraform workspace name in your ZSH prompt open
your .zsh-theme file and in a chosen place insert:

```
$FG[045]\
$(tf_prompt_info)\
```
