# exa

This zsh plugin adds several aliases, allowing `exa`, to be used in place of `ls` and `tree`.

## Requirements

The `exa` package must be installed. On MacOS it is available from `brew`, on many Linux platforms it is available through the package manager.

See: [`exa`](https://the.exa.website) for details.

Add `exa` to the plugins array of your zshrc file:

```bash
plugins=(... exa)
```

## Aliases

```bash
alias ls='exa'
alias l='exa -lbF --git'
alias ll='exa -lbGF --git'
alias llm='exa -lbGF --git --sort=modified'
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale'
alias lS='exa -1'
alias lt='exa --tree --level=2'
alias tree='exa --tree'
```

