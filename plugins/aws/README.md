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
* `asp [<profile>] login`: If AWS SSO has been configured in your aws profile, it will run the `aws sso login` command following profile selection. 

* `acp [<profile>] [<mfa_token>]`: in addition to `asp` functionality, it actually changes
   the profile by assuming the role specified in the `<profile>` configuration. It supports
   MFA and sets `$AWS_ACCESS_KEY_ID`, `$AWS_SECRET_ACCESS_KEY` and `$AWS_SESSION_TOKEN`, if
   obtained. It requires the roles to be configured as per the
   [official guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
   Run `acp` without arguments to clear the profile.

* `agp`: gets the current value of `$AWS_PROFILE`.

* `aws_change_access_key`: changes the AWS access key of a profile.

* `aws_profiles`: lists the available profiles in the  `$AWS_CONFIG_FILE` (default: `~/.aws/config`).
  Used to provide completion for the `asp` function.

## Plugin options

* Set `SHOW_AWS_PROMPT=false` in your zshrc file if you want to prevent the plugin from modifying your RPROMPT.
  Some themes might overwrite the value of RPROMPT instead of appending to it, so they'll need to be fixed to
  see the AWS profile prompt.

## Theme

The plugin creates an `aws_prompt_info` function that you can use in your theme, which displays
the current `$AWS_PROFILE`. It uses two variables to control how that is shown:

* ZSH_THEME_AWS_PREFIX: sets the prefix of the AWS_PROFILE. Defaults to `<aws:`.

* ZSH_THEME_AWS_SUFFIX: sets the suffix of the AWS_PROFILE. Defaults to `>`.

## Configuration

[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) by AWS

### Scenario: IAM roles with a source profile and MFA authentication

Source profile credentials in `~/.aws/credentials`:

```
[source-profile-name]
aws_access_key_id = ...
aws_secret_access_key = ...
```

Role configuration in `~/.aws/config`:

```
[profile source-profile-name]
mfa_serial = arn:aws:iam::111111111111:mfa/myuser
region = us-east-1
output = json

[profile profile-with-role]
role_arn = arn:aws:iam::9999999999999:role/myrole
mfa_serial = arn:aws:iam::111111111111:mfa/myuser
source_profile = source-profile-name
region = us-east-1
output = json
```
