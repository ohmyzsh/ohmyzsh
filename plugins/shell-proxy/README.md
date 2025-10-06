# shell-proxy plugin

This a pure user-space program, shell-proxy setter, written in Python3 and Zsh.

To use it, add `shell-proxy` to the plugins array in your zshrc file:

```zsh
plugins=(... shell-proxy)
```

## Key features

- Supports macOS and Linux (Ubuntu, Archlinux, etc.)
- Supports git via setting `$GIT_SSH`
- Supports ssh, sftp, scp, slogin and ssh-copy-id via setting aliases
- Built-in autocomplete

## Usage

### Method 1

Set `SHELLPROXY_URL` environment variable to the URL of the proxy server:

```sh
SHELLPROXY_URL="http://127.0.0.1:8123"
SHELLPROXY_NO_PROXY="localhost,127.0.0.1"
proxy enable
```

### Method 2

Write a program file in `$HOME/.config/proxy` so that the proxy URL is defined dynamically.
Note that the program file must be executable.

Example:

```sh
#!/bin/bash

# HTTP Proxy
if [[ "$(uname)" = Darwin ]]; then
  echo "http://127.0.0.1:6152" # Surge Mac
else
  echo "http://127.0.0.1:8123" # polipo
fi

# No Proxy
echo "localhost,127.0.0.1"
```

### Method 3

Use [method 2](#method-2) but define the location of the program file by setting the
`SHELLPROXY_CONFIG` environment variable:

```sh
SHELLPROXY_CONFIG="$HOME/.dotfiles/proxy-config"
```

## Reference

- `$GIT_SSH`: <https://www.git-scm.com/docs/git#Documentation/git.txt-codeGITSSHcode>
- OpenSSH manual: <https://man.openbsd.org/ssh>

## Maintainer

- [@septs](https://github.com/septs)
