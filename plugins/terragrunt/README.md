# Terragrunt plugin

This plugin adds completion and aliases for
[Terragrunt](https://terragrunt.gruntwork.io/).

To use it, add `terraform` and `terragrunt` to the plugins array in your zshrc
file:

```zsh
plugins=(... terraform terragrunt)
```

## Requirements

- [Terragrunt](https://terragrunt.gruntwork.io/) 1.1 or newer.
- [Terraform](https://developer.hashicorp.com/terraform).
- Optional: [`jq`](https://jqlang.github.io/jq/) for cached resource and output
  completion.

Without `jq`, resource and output completion uses live Terragrunt queries.

## Completion

The plugin completes Terragrunt commands and options from the installed binary,
then delegates Terraform arguments to the `terraform` plugin completion. It also
completes resource addresses for `-target` and `-replace`, and output names for
`terragrunt output`.

Resource addresses and output names are cached in
`.terragrunt-cache/.zsh-completion`. The cache refreshes after commands that can
change Terraform state. Remove that directory to refresh it manually.

## Aliases

| Alias | Command |
| --- | --- |
| `tg` | `terragrunt` |
| `tga` | `terragrunt apply --use-partial-parse-config-cache` |
| `tgc` | `terragrunt run -- console` |
| `tgd` | `terragrunt destroy --use-partial-parse-config-cache` |
| `tgf` | `terragrunt hcl fmt` |
| `tgi` | `terragrunt init --use-partial-parse-config-cache` |
| `tgiu` | `terragrunt init -upgrade --use-partial-parse-config-cache` |
| `tgo` | `terragrunt output --use-partial-parse-config-cache` |
| `tgoj` | `terragrunt output -json --use-partial-parse-config-cache` |
| `tgp` | `terragrunt plan --use-partial-parse-config-cache` |
| `tgv` | `terragrunt validate` |
| `tgs` | `terragrunt state --use-partial-parse-config-cache` |
| `tgt` | `terragrunt run -- taint` |
| `tgsh` | `terragrunt show` |
