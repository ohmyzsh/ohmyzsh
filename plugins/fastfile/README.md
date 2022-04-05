# Fastfile plugin

This plugin adds a way to reference certain files or folders used frequently using
a global alias or shortcut.

To use it, add `fastfile` to the plugins array in your zshrc file:

```zsh
plugins=(... fastfile)
```

## Usage

Example: you access folder `/code/project/backend/database` very frequently.

First, generate a shortcut with the name `pjdb`:

```zsh
$ fastfile pjdb /code/project/backend/database
```

Next time you want to access it, use `§pjdb`. For example:

```zsh
$ cd §pjdb
$ subl §pjdb
```

where § is the fastfile prefix (see [below](#options) for how to change).

**Note:** shortcuts with spaces in the name are assigned a global alias
where the spaces have been substituted with underscores (`_`). For example:
a shortcut named `"hello world"` corresponds with `§hello_world`.

## Functions

- `fastfile <shortcut_name> [path/to/file/or/folder]`: generate a shortcut.
  If the second argument is not provided, the current directory is used.

- `fastfile_print <shortcut_name>`: prints a shortcut, with the format
  `<prefix><shortcut_name> -> <shortcut_path>`.

- `fastfile_ls`: lists all shortcuts.

- `fastfile_rm <shortcut_name>`: remove a shortcut.

- `fastfile_sync`: generates the global aliases for the shortcuts.

### Internal functions

- `fastfile_resolv <shortcut_name>`: resolves the location of the shortcut
  file, i.e., the file in the fastfile directory where the shortcut path
  is stored.

- `fastfile_get <shortcut_name>`: get the real path of the shortcut.

## Aliases

| Alias  | Function         |
|--------|------------------|
| ff     | `fastfile`       |
| ffp    | `fastfile_print` |
| ffrm   | `fastfile_rm`    |
| ffls   | `fastfile_ls`    |
| ffsync | `fastfile_sync`  |

## Options

These are options you can set to change certain parts of the plugin. To change
them, add `<variable>=<value>` to your zshrc file, before Oh My Zsh is sourced.
For example: `fastfile_var_prefix='@'`.

- `fastfile_var_prefix`: prefix for the global aliases created. Controls the prefix of the
  created global aliases.  
  **Default:** `§` (section sign), easy to type in a german keyboard via the combination
  [`⇧ Shift`+`3`](https://en.wikipedia.org/wiki/German_keyboard_layout#/media/File:KB_Germany.svg),
  or using `⌥ Option`+`6` in macOS.

- `fastfile_dir`: directory where the fastfile shortcuts are stored. Needs to end
  with a trailing slash.  
  **Default:** `$HOME/.fastfile/`.

## Author

- [Karolin Varner](https://github.com/koraa)
