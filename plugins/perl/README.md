# Perl

This plugin adds [perl](https://www.perl.org/) useful aliases/functions.

To use it, add `perl` to the plugins array in your zshrc file:

```zsh
plugins=(... perl)
```

## Aliases

| Aliases       | Command            |  Description                           |
| :------------ | :----------------- | :------------------------------------- |
| pbi           | `perlbrew install` | Install specific perl version          |
| pbl           | `perlbrew list`    | List all perl version installed        |
| pbo           | `perlbrew off`     | Go back to the system perl             |
| pbs           | `perlbrew switch`  | Turn it back on                        |
| pbu           | `perlbrew use`     | Use specific version of perl           |
| pd            | `perldoc`          | Show the perl documentation            |
| ple           | `perl -wlne`       | Use perl like awk/sed                  |
| latest-perl   | `curl ...`         | Show the latest stable release of Perl |

## Functions

* `newpl`: creates a basic Perl script file and opens it with $EDITOR.

* `pgs`: Perl Global Substitution: `pgs <find_pattern> <replace_pattern> <filename>`
  Looks for `<find_pattern>` and replaces it with `<replace_pattern>` in `<filename>`.

* `prep`: Perl grep, because 'grep -P' is terrible: `prep <pattern> [<filename>]`
  Lets you work with pipes or files (if no `<filename>` provided, use stdin).

## Requirements

In order to make this work, you will need to have perl installed.
More info on the usage and install: https://www.perl.org/get.html
