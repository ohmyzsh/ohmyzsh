# Globalias plugin

Expands all glob expressions, subcommands and aliases (including global).

Idea from: https://blog.patshead.com/2012/11/automatically-expaning-zsh-global-aliases---simplified.html.

## Usage

Add `globalias` to the plugins array in your zshrc file:

```zsh
plugins=(... globalias)
```

Then just press `SPACE` to trigger the expansion of a command you've written.

If you only want to insert a space without expanding the command line, press
`CTRL`+`SPACE`.

if you would like to filter out any values from expanding set `GLOBALIAS_FILTER_VALUES` to
an array of said values. See [Filtered values](#filtered-values).

## Examples

#### Glob expressions

```
$ touch {1..10}<space>
# expands to
$ touch 1 2 3 4 5 6 7 8 9 10

$ ls **/*.json<space>
# expands to
$ ls folder/file.json anotherfolder/another.json
```

#### Subcommands

```
$ mkdir "`date -R`"
# expands to
$ mkdir Tue,\ 04\ Oct\ 2016\ 13:54:03\ +0300
```

#### Aliases

```
# .zshrc:
alias -g G="| grep --color=auto -P"
alias l='ls --color=auto -lah'

$ l<space>G<space>
# expands to
$ ls --color=auto -lah | grep --color=auto -P
```

```
# .zsrc:
alias S="sudo systemctl"

$ S<space>
# expands to:
$ sudo systemctl
```

#### Filtered values

```
# .zshrc
alias l='ls -lh'
alias la='ls --color=auto -lah'
GLOBALIAS_FILTER_VALUES=(l)

$ l<space>
# does not expand
$ la<space>
# expands to:
$ ls --color=auto -lah
```
