# run0

Easily prefix your current or previous commands with `run0` by pressing <kbd>esc</kbd> twice.

To use it, add `run0` to the plugins array in your zshrc file:

```zsh
plugins=(... run0)
```

## Usage

### Current typed commands

Say you have typed a long command and forgot to add `run0` in front:

```console
$ apt-get install build-essential
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `run0` prefixed without typing:

```console
$ run0 apt-get install build-essential
```

### Previous executed commands

Say you want to delete a system file and denied:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `run0` prefixed without typing:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$ run0 rm some-system-file.txt
Password:
$
```

The same happens for file editing, as told before.

## Key binding

By default, the `run0` plugin uses <kbd>Esc</kbd><kbd>Esc</kbd> as the trigger.
If you want to change it, you can use the `bindkey` command to bind it to a different key:

```sh
bindkey -M emacs '<seq>' run0-command-line
bindkey -M vicmd '<seq>' run0-command-line
bindkey -M viins '<seq>' run0-command-line
```

where `<seq>` is the sequence you want to use. You can find the keyboard sequence
by running `cat` and pressing the keyboard combination you want to use.
