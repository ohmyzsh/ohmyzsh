# zsh-aliases-exa

## Purpose

This zsh plugin enables a number of aliases extending `exa`, the modern replacement for `ls`.

## Use

To use it, you should first install [`exa`](https://the.exa.website). You can do so easily using [Homebrew](https://brew.sh) on the Mac:

```bash
brew install exa
```

Next, download this repo into your custom plugins directory. For my installation using [Oh My Zsh](https://ohmyz.sh/), I cloned the repo to `~/.oh-my-zsh/custom/plugins`.

Lastly, add `zsh-aliases-exa` to the plugins array of your zshrc file:

```bash
plugins=(... zsh-aliases-exa)
```

Restart your zsh session, and the aliases will be available.

## Aliases

```bash
alias ls='exa'                                                         # ls
alias l='exa -lbF --git'                                               # list, size, type, git
alias ll='exa -lbGF --git'                                             # long list
alias llm='exa -lbGF --git --sort=modified'                            # long list, modified date sort
alias la='exa -lbhHigUmuSa --time-style=long-iso --git --color-scale'  # all list
alias lx='exa -lbhHigUmuSa@ --time-style=long-iso --git --color-scale' # all + extended list
alias lS='exa -1'			                                                 # one column, just names
alias lt='exa --tree --level=2'                                        # tree
alias tree='exa --tree'
```


