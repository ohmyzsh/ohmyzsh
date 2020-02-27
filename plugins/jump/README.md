# Jump plugin

This plugin allows to easily jump around the file system by manually adding marks.
Those marks are stored as symbolic links in the directory `$MARKPATH` (default `$HOME/.marks`)

To use it, add `jump` to the plugins array in your zshrc file:

```zsh
plugins=(... jump)
```

## Commands

| Command              | Description                                                                                     |
|----------------------|-------------------------------------------------------------------------------------------------|
| `jump <mark-name>`   | Jump to the given mark                                                                          |
| `mark [mark-name]`   | Create a mark with the given name or with the name of the current directory if none is provided |
| `unmark <mark-name>` | Remove the given mark                                                                           |
| `marks`              | List the existing marks and the directories they point to                                       |

## Key bindings

Pressing `CTRL`+`G` substitutes the written mark name for the full path of the mark.
For example, with a mark named `mymark` pointing to `/path/to/my/mark`:
```zsh
$ cp /tmp/file mymark<C-g>
```
will become:
```zsh
$ cp /tmp/file /path/to/my/mark
```
