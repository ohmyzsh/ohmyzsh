## apple-passwords-otp

This plugin adds a function that allows to quickly copy the One-Time-Password (OTP) for a specific domain from
Apple Passwords to the clipboard.

To use it, add `apple-passwords-otp` to the plugins array of your zshrc file:

```zsh
plugins=(... apple-passwords-otp)
```

## Functions

- `otp(domain)` : copies the OTP for the specified domain to the clipboard

## Usage

```bash
otp domain
```

## Requirements

This plugin depends on the [Apple Passwords CLI](https://github.com/bendews/apw) tool. It can be installed via
Homebrew. Other requirements are `jq` to parse json files which can be installed via Homebrew as well. You
need to have Mac OS Sequoia or later to use this plugin.
