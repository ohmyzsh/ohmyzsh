# aws

This plugin provides completion to set the AWS_PROFILE environment variable, as well as a
function to get the current value of it.

To use it, add `aws` to the plugins array in your zshrc file.

```zsh
plugins=(... aws)
```

## Plugin commands

* `asp <profile>`: Sets `AWS_PROFILE` and `AWS_DEFAULT_PROFILE` (legacy) to `<profile>`.
It also adds it to your RPROMPT.
* `agp`: Gets the current value of `AWS_PROFILE`
* `aws_profiles`: Lists the available profiles in the file referenced in `AWS_CONFIG_FILE` (default: ~/.aws/config). Used to provide completion.
