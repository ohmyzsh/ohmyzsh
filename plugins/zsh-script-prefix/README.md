# zsh-script-prefix

Easily prefix your current or previous commands with `./` by pressing <kbd>esc</kbd> once.

_Modified version of ohmyzsh_ [plugins/sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)

To use it, add `zsh-script-prefix` to the plugins array in your zshrc file:

```zsh
plugins=(... zsh-script-prefix)
```

## Usage

### Current typed commands

Say you have typed a script name and forgot to add `./` in front:

```bash
$ somescript.sh
```

By pressing the <kbd>esc</kbd> key once, you will have the same command with `./` prefixed without typing:

```bash
$ ./somescript.sh
```

### Previous executed commands

By pressing the <kbd>esc</kbd> key once, you will have the same command with `./` prefixed without typing:

```bash
$ somescript.sh
zsh: command not found: somescript.sh
$ ./somescript.sh
```

## Key binding

By default, the `zsh-script-prefix` plugin uses <kbd>Esc</kbd> as the trigger.
If you want to change it, you can use the `bindkey` command to bind it to a different key:

```sh
bindkey -M emacs '<seq>' script-prefix-command-line
bindkey -M vicmd '<seq>' script-prefix-command-line
bindkey -M viins '<seq>' script-prefix-command-line
```

where `<seq>` is the sequence you want to use. You can find the keyboard sequence
by running `cat` and pressing the keyboard combination you want to use.

### Credits

ohmyzsh [plugins/sudo](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo)