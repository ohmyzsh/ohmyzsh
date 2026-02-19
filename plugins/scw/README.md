## Scaleway CLI plugin

This plugin adds completion for [scw](https://github.com/scaleway/scaleway-cli), the command line interface for Scaleway.

To use it, add `scw` to the plugins array in your zshrc file:

```zsh
plugins=(... scw)
```

This plugin also adds functions to easily manage your Scaleway profiles with the
`scw` command.

## Prerequisites

Scaleway CLI (scw) should be installed. You can install it from
https://github.com/scaleway/scaleway-cli.

Copy and paste the code into your Oh My Zsh configuration file (e.g., .zshrc):

```bash
plugins=(... scw)
```

## Functions

| Commands          | Description                                              |
| :---------------: |:-------------------------------------------------------- |
| scw_upgrade       | Update your Scaleway CLI version if needed.              |
| sgp               | Displays the current Scaleway profile.                   |
| ssp <profilename> | Sets the Scaleway profile. If no profile name is provided, fallback to the curent active profile set in your configuration file. |
| scw_profiles      | Displays a list of available Scaleway profiles.          |
| scw_config_path   | Returns the path to the Scaleway CLI configuration file (config.yaml). |

In addition to setting the `SCW_PROFILE` environment variable, `ssp` also sets
the following variables: `SCW_DEFAULT_ORGANIZATION_ID`,
`SCW_DEFAULT_PROJECT_ID`, `SCW_DEFAULT_REGION`, `SCW_DEFAULT_ZONE`,
`SCW_API_URL`.
Additionnally, if `SCW_EXPORT_TOKENS` is set to "true", `SCW_ACCESS_KEY` and
`SCW_SECRET_KEY` are also exported.

## Customizations

| Env variables                | Description                                   |
| :--------------------------: |:--------------------------------------------- |
| SHOW_SCW_PROMPT              | Controls whether to display the Scaleway profile information in the shell prompt. Set this variable to false if you don't want to show the profile information. |
| ZSH_THEME_SCW_PROFILE_PREFIX |  sets the prompt prefix.  Defaults to `<scw:` |
| ZSH_THEME_SCW_PROFILE_SUFFIX | Set the prompt suffix. Default to `>`         |

## Scaleway CLI Autocompletion

If Scaleway CLI autocompletion is not already loaded, the code automatically
loads the autocompletion script for the scw command. This enables autocompletion
for all Scaleway CLI commands.
