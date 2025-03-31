# 1Password

This plugin adds 1Password functionality to oh-my-zsh.

To use, add `1password` to the list of plugins in your `.zshrc` file:

```zsh
plugins=(... 1password)
```

Then, you can use the command `opswd` to copy passwords for services into your
clipboard.

## `opswd`

The `opswd` command is a wrapper around the `op` command. It takes a service
name as an argument and copies the username, then the password for that service
to the clipboard, after confirmation on the user part.

If the service also contains a TOTP, it is copied to the clipboard after confirmation
on the user part. Finally, after 20 seconds, the clipboard is cleared.

For example, `opswd github.com` will put your GitHub username into your clipboard. Then,
it will ask for confirmation to continue, and copy the password to your clipboard. Finally,
if a TOTP is available, it will be copied to the clipboard after your confirmation.

This function has completion support, so you can use tab completion to select which
service you want to get.

> NOTE: you need to be signed in for `opswd` to work. If you are using biometric unlock,
> 1Password CLI will automatically prompt you to sign in. See:
>
> - [Get started with 1Password CLI 2: Sign in](https://developer.1password.com/docs/cli/get-started#sign-in)
> - [Sign in to your 1Password account manually](https://developer.1password.com/docs/cli/sign-in-manually)

## Secrets Injection

This plugin wraps specific commands (e.g., terraform, env) with the op run command from 1Password, automatically injecting any relevant secrets already defined in your environment variables. This ensures seamless integration with 1Password to manage sensitive information without needing .env files.

### Key Features

- Automatic 1Password Integration: The plugin automatically loads secrets from your 1Password vaults into the environment for supported commands.
- Toggle Activation: Easily enable or disable the wrapper with a keybinding (Ctrl+O by default).
- Command-Specific Behavior: Each supported command (e.g., terraform, env) is wrapped with `op run`, and any secrets defined in your environment are automatically passed into the subprocess.

### Basic Setup

```zsh
# setup any commands you wish to wrap
➜  ~ export OP_RUN_WRAPPER_CMDS=(env)
# define a secret and it's path inside your 1Password vault
➜  ~ export AWS_ACCESS_KEY_ID="op://vault/secret/atrribute" 
# enabled injection mode with Ctrl+O, call wrapped command `env` and see result
(🔑) ➜  ~ env | grep AWS_ACCESS_KEY_ID                      
AWS_ACCESS_KEY_ID=<concealed by 1Password>
```

For more information on the `op run` command, check out the official [1Password CLI documentation](https://developer.1password.com/docs/cli/secrets-environment-variables).

## Requirements

- [1Password CLI 2](https://developer.1password.com/docs/cli/get-started#install)

  > NOTE: if you're using 1Password CLI 1, [see how to upgrade to CLI 2](https://developer.1password.com/docs/cli/upgrade).
