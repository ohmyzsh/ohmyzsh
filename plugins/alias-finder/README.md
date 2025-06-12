# alias-finder plugin

This plugin searches the defined aliases and outputs any that match the command inputted. This makes learning new aliases easier.

## Setup

To use it, add `alias-finder` to the `plugins` array of your zshrc file:
```
plugins=(... alias-finder)
```

To enable it for every single command, set zstyle in your `~/.zshrc`.

If the user has installed `rg`([ripgrep](https://github.com/BurntSushi/ripgrep)), it will be used because it's faster. Otherwise, it will use the `grep` command.

```zsh
# ~/.zshrc

zstyle ':omz:plugins:alias-finder' autoload yes # disabled by default
zstyle ':omz:plugins:alias-finder' longer yes # disabled by default
zstyle ':omz:plugins:alias-finder' exact yes # disabled by default
zstyle ':omz:plugins:alias-finder' cheaper yes # disabled by default
```

As you can see, options are also available with zstyle.

## Usage

When you execute a command alias finder will look at your defined aliases and suggest shorter aliases you could have used, for example:

Running the un-aliased `git status` command:
```sh
╭─tim@fox ~/repo/gitopolis ‹main›
╰─$ git status

gst='git status'         # <=== shorter suggestion from alias-finder

On branch main
Your branch is up-to-date with 'origin/main'.
nothing to commit, working tree clean
```

Running a shorter `git st` alias from `.gitconfig` that it suggested :
```sh
╭─tim@fox ~/repo/gitopolis ‹main›
╰─$ git st
gs='git st'         # <=== shorter suggestion from alias-finder
## main...origin/main
```

Running the shortest `gs` shell alias that it found:
```sh
╭─tim@fox ~/repo/gitopolis ‹main›
╰─$ gs
         # <=== no suggestions alias-finder because this is the shortest
## main...origin/main
```

![image](https://github.com/ohmyzsh/ohmyzsh/assets/19378/39642750-fb10-4f1a-b7f9-f36789eeb01b)


### Options

> In order to clarify, let's say `alias a=abc` has source 'abc' and destination 'a'.

- Use `--longer` or `-l` to include aliases where the source is longer than the input (in other words, the source could contain the whole input).
- Use `--exact` or `-e` to avoid aliases where the source is shorter than the input (in other words, the source must be the same with the input).
- Use `--cheaper` or `-c` to avoid aliases where the destination is longer than the input (in other words, the destination must be the shorter than the input).


