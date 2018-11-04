# aws

This plugin provides completion support for [awscli](https://docs.aws.amazon.com/cli/latest/reference/index.html)
and a few utilities to manage AWS profiles: a function to change profiles with autocompletion support
and a function to get the current AWS profile. The current AWS profile is also displayed in `RPROMPT`.

To use it, add `aws` to the plugins array in your zshrc file.

```zsh
plugins=(... aws)
```

## Plugin commands

| Alias  | Command              | Description   |
|--------|----------------------|---------------|
| asp  | `asp <profile>` | Sets `AWS_PROFILE`, `AWS_DEFAULT_PROFILE` (legacy) and `AWS_EB_PROFILE` to `<profile>`. It also adds it to your RPROMPT. |
| agp | `echo $AWS_PROFILE` | Gets the current value of `AWS_PROFILE`. |
| aws_profiles | `aws_profiles` | Lists the available profiles in the file referenced in `AWS_CONFIG_FILE` (default: ~/.aws/config). Used to provide completion for the `asp` function. |
