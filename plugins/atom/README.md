# Atom Editor Zsh shell Plugin

This plugin will define aliases for the few Atom command line options but not for `apm`.

To enable, add it to the `plugins` array inside your zsh resources file in `~/.zshrc`. Look for 'plugins', which is the name of the plugins array and add it to the end of the list. This can help to discover which line is it via your shell's terminal:

Search for a line or lines begining with the word 'plugins' followed by an iquals sign `=` and an open parenthesis `(` to narrow the results.

```
egrep --recursive --line-number "^plugins\=\(" ~/.zshrc
```

This can put you on the right line, assuming that it got only one (which I hope). I is also assumed that the `EDITOR` varible is defined and contains nano, vi, vim or even atom as the set editor:

```
"${EDITOR}" +$(egrep --recursive --line-number "^plugins\=\(" ~/.zshrc | awk --field-separator ":" '{print $1}') ~/.zshrc
```

Once at the right line, add `atom` after the last item of the array:

```
plugins=(... atom)
```

## Requirements

Besides having ZSH and this plugin, you must install Atom for your OS. Follow one of the guide from these links:

- [Linux instructions](https://flight-manual.atom.io/getting-started/sections/installing-atom/#platform-linux)
- [macOS instructions](https://flight-manual.atom.io/getting-started/sections/installing-atom/#platform-mac)
- [Windows instructions](https://flight-manual.atom.io/getting-started/sections/installing-atom/#platform-windows)

## Atom tips from its help command

Opening the current directory, it will be treated as a project from command line:

```
$ cd /tmp
$ atom .
```

Opening the file from command line. It will open atom if its not already open or use the current open window.

```
atom /etc/os-release
```

Opening a file at a specific line _n_ and at a specific column _n_. Omiting the second _:_ and its value will only put you at the given line.

```
# Opening /etc/os-release at line 3, column 3
$ atom /etc/os-release:3:3
```

## Aliases that will be set

Alias  | Original                       | Usage                        | Description
------ | ------------------------------ | ---------------------------- | ---------------------------------------------------------------------------------------------------------------
atomln | atom `file[:line[:column]]`    | atomln `file 3 3` | Open a file at the desired line and column number. [string] [int] [int] or [string] [int]
atomd  | atom `-d, --dev`               | atomd                        | Run in development mode. [boolean]
atomf  | atom `-f, --foreground`        | atomf                        | Keep the main process in the foreground. [boolean]
atomh  | atom `-h, --help`              | atomh                        | Print this usage message. [boolean]
atoml  | atom -l, --log-file            | atoml                        | Log all output to file. [string]
atomn  | atom -n, --new-window          | atomn                        | Open a new window. [boolean]
atomp  | atom --profile-startup         | atomp                        | Create a profile of the startup execution time. [boolean]
atomr  | atom -r, --resource-path       | atomr                        | Set the path to the Atom source directory and enable dev-mode. [string]
atoms  | atom --safe                    | atoms                        | Do not load packages from ~/.atom/packages or ~/.atom/dev/packages. [boolean]
atomb  | atom --benchmark               | atomb                        | Open a new window that runs the specified benchmarks. [boolean]
atombt | atom --benchmark-test          | atombt                       | Run a faster version of the benchmarks in headless mode. [boolean]
atomt  | atom -t, --test                | atomt                        | Run the specified specs and exit with error code on failures. [boolean]
atomm  | atom -m, --main-process        | atomm                        | Run the specified specs in the main process. [boolean]
atomto | atom --timeout                 | atomto                       | When in test mode, waits until the specified time (in minutes) and kills the process (exit code: 130). [string]
atomv  | atom -v, --version             | atomv                        | Print the version information. [boolean]
atomw  | atom -w, --wait                | atomw                        | Wait for window to be closed before returning. [boolean]
atomc  | atom --clear-window-state      | atomc                        | Delete all Atom environment state. [boolean]
atome  | atom --enable-electron-logging | atome                        | Enable low-level logging messages from Electron. [boolean]
atoma  | atom -a, --add                 | atoma                        | Open path as a new project in last used window. [boolean]

```
# Example with atomln line 3 at column 3:
$ atomln /etc/os-release 3 3
# Example with atomln line 3:
$ atomln /etc/os-release 3
```
