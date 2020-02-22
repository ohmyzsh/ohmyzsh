# doas

Easily prefix your current or previous commands with `doas` by pressing <kbd>esc</kbd> twice

## Enabling the plugin

1.  Open your `.zshrc` file and add `doas` in the plugins section:

    ```zsh
    plugins=(
        # all your enabled plugins
        doas
    )
    ```

2.  Restart your shell or restart your Terminal session:

    ```console
    $ exec zsh
    $
    ```

## Usage examples

### Current typed commands

Say you have typed a long command and forgot to add `doas` in front:

```console
$ pacman -S base
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with `doas` prefixed without typing:

```console
$ doas pacman -S base
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
