# doas-zsh-plugin

Easily prefix your current or previous commands with `doas` by pressing <kbd>esc</kbd> twice

To use it, add the following to your zshrc:

```console
plugins=(doas)
```

## Usage

### Current typed commands

Say you have typed a long command and forgot to add `doas` in front:

```console
$ apt-get install build-essential
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `doas` prefixed without typing:

```console
$ doas apt-get install build-essential
```

### Previous executed commands

Say you want to delete a system file and denied:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `doas` prefixed without typing:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$ doas rm some-system-file.txt
Password:
$
```

Plugin inspired by sudo plugin by [Dongweiming](https://github.com/dongweiming)
