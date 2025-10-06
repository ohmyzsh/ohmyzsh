# aws

This plugin provides completion support for [awscli v2](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/index.html)
and a few utilities to manage AWS profiles/regions and display them in the prompt.
[awscli v1](https://docs.aws.amazon.com/cli/latest/userguide/cliv2-migration.html) is no longer supported.

To use it, add `aws` to the plugins array in your zshrc file.

```zsh
plugins=(... aws)
```

## Plugin commands

* `asp [<profile>]`: sets `$AWS_PROFILE` and `$AWS_DEFAULT_PROFILE` (legacy) to `<profile>`.
  It also sets `$AWS_EB_PROFILE` to `<profile>` for the Elastic Beanstalk CLI. It sets `$AWS_PROFILE_REGION` for display in `aws_prompt_info`.
  Run `asp` without arguments to clear the profile.
* `asp [<profile>] login`: If AWS SSO has been configured in your aws profile, it will run the `aws sso login` command following profile selection.
* `asp [<profile>] login [<sso_session>]`: In addition to `asp [<profile>] login`, if SSO session has been configured in your aws profile, it will run the `aws sso login --sso-session <sso_session>` command following profile selection.
* `asp [<profile>] logout`: If AWS SSO has been configured in your aws profile, it will run the `aws sso logout` command following profile selection.

* `asr [<region>]`: sets `$AWS_REGION` and `$AWS_DEFAULT_REGION` (legacy) to `<region>`.
  Run `asr` without arguments to clear the profile.

* `acp [<profile>] [<mfa_token>]`: in addition to `asp` functionality, it actually changes
   the profile by assuming the role specified in the `<profile>` configuration. It supports
   MFA and sets `$AWS_ACCESS_KEY_ID`, `$AWS_SECRET_ACCESS_KEY` and `$AWS_SESSION_TOKEN`, if
   obtained. It requires the roles to be configured as per the
   [official guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html).
   Run `acp` without arguments to clear the profile.

* `agp`: gets the current value of `$AWS_PROFILE`.

* `agr`: gets the current value of `$AWS_REGION`.

* `aws_change_access_key`: changes the AWS access key of a profile.

* `aws_profiles`: lists the available profiles in the  `$AWS_CONFIG_FILE` (default: `~/.aws/config`).
  Used to provide completion for the `asp` function.

* `aws_regions`: lists the available regions.
  Used to provide completion for the `asr` function.

## Plugin options

* Set `SHOW_AWS_PROMPT=false` in your zshrc file if you want to prevent the plugin from modifying your RPROMPT.
  Some themes might overwrite the value of RPROMPT instead of appending to it, so they'll need to be fixed to
  see the AWS profile/region prompt.

* Set `AWS_PROFILE_STATE_ENABLED=true` in your zshrc file if you want the aws profile to persist between shell sessions.
  This option might slow down your shell startup time.
  By default the state file path is `/tmp/.aws_current_profile`. This means that the state won't survive a reboot or otherwise GC.
  You can control the state file path using the `AWS_STATE_FILE` environment variable.

## Theme

The plugin creates an `aws_prompt_info` function that you can use in your theme, which displays
the current `$AWS_PROFILE` and `$AWS_REGION`. It uses four variables to control how that is shown:

* ZSH_THEME_AWS_PROFILE_PREFIX: sets the prefix of the AWS_PROFILE. Defaults to `<aws:`.

* ZSH_THEME_AWS_PROFILE_SUFFIX: sets the suffix of the AWS_PROFILE. Defaults to `>`.

* ZSH_THEME_AWS_REGION_PREFIX: sets the prefix of the AWS_REGION. Defaults to `<region:`.

* ZSH_THEME_AWS_REGION_SUFFIX: sets the suffix of the AWS_REGION. Defaults to `>`.

* ZSH_THEME_AWS_DIVIDER: sets the divider between ZSH_THEME_AWS_PROFILE_SUFFIX and ZSH_THEME_AWS_REGION_PREFIX. Defaults to ` ` (single space).

## Configuration

[Configuration and credential file settings](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) by AWS

### Scenario: IAM roles with a source profile and MFA authentication

Source profile credentials in `~/.aws/credentials`:

```ini
[source-profile-name]
aws_access_key_id = ...
aws_secret_access_key = ...
```

Role configuration in `~/.aws/config`:

```ini
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
