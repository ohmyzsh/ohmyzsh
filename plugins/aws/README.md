# aws

This plugin provides completion support for [awscli](https://docs.aws.amazon.com/cli/latest/reference/index.html)
and a few utilities to manage AWS profiles and display them in the prompt.

To use it, add `aws` to the plugins array in your zshrc file.

```zsh
plugins=(... aws)
```

## Plugin commands

* `asp [<profile>]`: sets `$AWS_PROFILE` and `$AWS_DEFAULT_PROFILE` (legacy) to `<profile>`.
  It also sets `$AWS_EB_PROFILE` to `<profile>` for the Elastic Beanstalk CLI.
  Run `asp` without arguments to clear the profile.

* `agp`: gets the current value of `$AWS_PROFILE`.

* `aws_change_access_key`: changes the AWS access key of a profile.

* `aws_profiles`: lists the available profiles in the  `$AWS_CONFIG_FILE` (default: `~/.aws/config`).
  Used to provide completion for the `asp` function.

**Note**: The credentials file (`~/.aws/credentials`) uses a different naming
format than the CLI config file (`~/.aws/config`) for named profiles. Include
the prefix word "profile" only when configuring a named profile in the config
file. Do not use the word profile when creating an entry in the credentials
file.

**Example**

`~/.aws/credentials`

```
[root]
aws_access_key_id=<...>
aws_secret_access_key=<...>
```

`~/.aws/config`

```
[profile root]
region=us-east-1
output=json
```

## Plugin options

* Set `SHOW_AWS_PROMPT=false` in your zshrc file if you want to prevent the plugin from modifying your RPROMPT.
  Some themes might overwrite the value of RPROMPT instead of appending to it, so they'll need to be fixed to
  see the AWS profile prompt.

## Theme

The plugin creates an `aws_prompt_info` function that you can use in your theme, which displays
the current `$AWS_PROFILE`. It uses two variables to control how that is shown:

- ZSH_THEME_AWS_PREFIX: sets the prefix of the AWS_PROFILE. Defaults to `<aws:`.

- ZSH_THEME_AWS_SUFFIX: sets the suffix of the AWS_PROFILE. Defaults to `>`.
