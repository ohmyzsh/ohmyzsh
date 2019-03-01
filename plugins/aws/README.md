# aws

This plugin provides completion support for [awscli](https://docs.aws.amazon.com/cli/latest/reference/index.html). It also offers management utilities and theming for AWS profiles.

To use it, add `aws` to the plugins array in your zshrc file.

```zsh
plugins=(... aws)
```

## Plugin commands

* `aws_set_profile <profile>`: Sets `AWS_PROFILE` and `AWS_DEFAULT_PROFILE` (legacy) to `<profile>`.

* `aws_unset_profile`: Unsets `AWS_PROFILE` and `AWS_DEFAULT_RPOFILE` (legacy).

* `aws_get_profile`: Prints the current value of `AWS_PROFILE`.

* `aws_profiles`: Lists the available profiles in the file referenced in `AWS_CONFIG_FILE` (default: ~/.aws/config). Used to provide completion for the `aws_set_profile` function.

## Theme

The plugin creates a `aws_profile_prompt_info` function that you can use in your theme, which displays the current `$AWS_PROFILE`. It uses two variables to control how that is shown:

- ZSH_THEME_AWS_PREFIX: sets the prefix of the AWS_PROFILE. Defaults to [.

- ZSH_THEME_AWS_SUFFIX: sets the suffix of the AWS_PROFILE. Defaults to ].
