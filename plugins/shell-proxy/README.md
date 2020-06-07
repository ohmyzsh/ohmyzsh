# Shell Proxy oh-my-zsh plugin

This a pure user-space program, shell-proxy setter, written Python3 and Bash.

100% only no side-effects, only effect **environment variables** and **aliases**

## Key feature

- Support Ubuntu, Archlinux, etc (Linux)
- Support macOS
- Support git via based-`$GIT_SSH`
- Support ssh, sftp, scp, slogin and ssh-copy-id via based-`alias`
- Built-in Auto-complete

## Usage

Method 1:

`$DEFAULT_PROXY` is the proxy URL you will set

Method 2:

Write a program to `$HOME/.config/proxy` in the file.

Example program:

```bash
#!/bin/bash
# The file path: $HOME/.config/proxy
if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "http://127.0.0.1:6152" # Surge Mac
else
  echo "http://127.0.0.1:8123" # polipo
fi
```

Method 3:

The working path of **Method 2** can be changed via `$CONFIG_PROXY`

## Reference

- `$GIT_SSH`: <https://www.git-scm.com/docs/git#Documentation/git.txt-codeGITSSHcode>
- OpenSSH manual: <https://man.openbsd.org/ssh>

## Maintainer

- <https://github.com/septs>

## The oh-my-zsh plugin (shell-proxy)

Public Domain
