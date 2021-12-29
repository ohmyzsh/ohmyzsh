# Dirhistory plugin

This plugin adds keyboard shortcuts for navigating directory history and hierarchy.

To use it, add `dirhistory` to the plugins array in your zshrc file:

```zsh
plugins=(... dirhistory)
```

## Keyboard Shortcuts

| Shortcut                          | Description                                               |
|-----------------------------------|-----------------------------------------------------------|
| <kbd>Alt</kbd> + <kbd>Left</kbd>  | Go to previous directory                                  |
| <kbd>Alt</kbd> + <kbd>Right</kbd> | Go to next directory                                      |
| <kbd>Alt</kbd> + <kbd>Up</kbd>    | Move into the parent directory                            |
| <kbd>Alt</kbd> + <kbd>Down</kbd>  | Move into the first child directory by alphabetical order |

**For macOS: use the Option key (<kbd>⌥</kbd>) instead of <kbd>Alt</kbd>**.

> NOTE: some terminals might override the <kbd>Alt</kbd> + Arrows key bindings (e.g. Windows Terminal).
> If these don't work check your terminal settings and change them to a different keyboard shortcut.

## Usage

This plugin allows you to navigate the history of previous working directories using <kbd>Alt</kbd> + <kbd>Left</kbd>
and <kbd>Alt</kbd> + <kbd>Right</kbd>. <kbd>Alt</kbd> + <kbd>Left</kbd> moves to past directories, and
<kbd>Alt</kbd> + <kbd>Right</kbd> goes back to recent directories.

**NOTE: the maximum directory history size is 30.**

You can also navigate **directory hierarchies** using <kbd>Alt</kbd> + <kbd>Up</kbd> and <kbd>Alt</kbd> + <kbd>Down</kbd>.
<kbd>Alt</kbd> + <kbd>Up</kbd> moves to the parent directory, while <kbd>Alt</kbd> + <kbd>Down</kbd> moves into the first
child directory found in alphabetical order (useful to navigate long empty directories, e.g. Java packages).

For example, if the shell was started, and the following commands were entered:

```shell
cd ~
cd /usr
cd share
cd doc
```

the directory stack (`dirs -v`) would look like this:

```console
$ dirs -v
0       /usr/share/doc
1       /usr/share
2       /usr
3       ~
```

then entering <kbd>Alt</kbd> + <kbd>Left</kbd> at the prompt would change directory from `/usr/share/doc` to `/usr/share`,
then if pressed again to `/usr`, then `~`. If <kbd>Alt</kbd> + <kbd>Right</kbd> were pressed the directory would be changed
to `/usr` again.

After that, <kbd>Alt</kbd> + <kbd>Down</kbd> will probably go to `/usr/bin` if `bin` is the first directory in alphabetical
order (depends on your `/usr` folder structure). <kbd>Alt</kbd> + <kbd>Up</kbd> will return to `/usr`, and once more will get
you to the root folder (`/`).
