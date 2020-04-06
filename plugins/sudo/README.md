# sudo

Easily prefix your current or previous commands with `sudo` by pressing <kbd>esc</kbd> twice

To use it, add `sudo` to the plugins array in your zshrc file:

```zsh
plugins=(... sudo)
```

## Usage

### Current typed commands

Say you have typed a long command and forgot to add `sudo` in front:

```console
$ apt-get install build-essential
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `sudo` prefixed without typing:

```console
$ sudo apt-get install build-essential
```

### Previous executed commands

Say you want to delete a system file and denied:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `sudo` prefixed without typing:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$ sudo rm some-system-file.txt
Password:
$
```
