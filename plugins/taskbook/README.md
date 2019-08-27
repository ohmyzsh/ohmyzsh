Taskbook
========
*Tasks, boards & notes for the command-line habitat*

[Join us Taskbook Github](https://github.com/klaussinani/taskbook)

## Usage

To use it, add `taskbook` to the plugins array in your zshrc file:

```zsh
plugins=(... taskbook)
```

## Aliases

| Alias       | Command              | Description                                                                                            |
|:------------|:---------------------|:-------------------------------------------------------------------------------------------------------|
| tb          | taskbook             | Display board view                                                                                     |
| tba         | taskbook --archive   | Display archived items                                                                                 |
| tbb         | taskbook --begin     | Start/pause task                                                                                       |
| tbch        | taskbook --check     | Check/uncheck task                                                                                     |
| tbc         | taskbook --clear     | Delete all checked items                                                                               |
| tby         | taskbook --copy      | Copy item description                                                                                  |
| tbd         | taskbook --delete    | Delete item                                                                                            |
| tbe         | taskbook --edit      | Edit item description                                                                                  |
| tbf         | taskbook --find      | Search for items                                                                                       |
| tbh         | taskbook --help      | Display help message                                                                                   |
| tbl         | taskbook --list      | List items by attributes                                                                               |
| tbm         | taskbook --move      | Move item between boards                                                                               |
| tbn         | taskbook --note      | Create note                                                                                            |
| tbp         | taskbook --priority  | Update priority of task                                                                                |
| tbr         | taskbook --restore   | Restore items from archive                                                                             |
| tbs         | taskbook --star      | Start/unstar item                                                                                      |
| tbt         | taskbook --task      | Create task                                                                                            |
| tbi         | taskbook --timeline  | Display timeline view                                                                                  |
| tbv         | taskbook --version   | Display installed version                                                                              |


## Examples

```
$ tb
$ tb --archive
$ tb --begin 2 3
$ tb --check 1 2
$ tb --clear
$ tb --copy 1 2 3
$ tb --delete 4
$ tb --edit @3 Merge PR #42
$ tb --find documentation
$ tb --list pending coding
$ tb --move @1 cooking
$ tb --note @coding Mergesort worse-case O(nlogn)
$ tb --priority @3 2
$ tb --restore 4
$ tb --star 2
$ tb --task @coding @reviews Review PR #42
$ tb --task @coding Improve documentation
$ tb --task Make some buttercream
$ tb --timeline
```

