# sudo

Easily prefix your current or previous commands with `sudo` (or a custom prefix) by pressing <kbd>esc</kbd> twice.

To use it, add `sudo` to the plugins array in your zshrc file:

```zsh
plugins=(... sudo)
````

## Usage

### Current typed commands

Say you have typed a long command and forgot to add the prefix (default: `sudo`) in front:

```console
$ apt-get install build-essential
```

By pressing the <kbd>esc</kbd> key twice, you will have the same command with the prefix (`sudo` by default) added without typing:

```console
$ sudo apt-get install build-essential
```

The same happens for editing files with your default editor (defined in `$SUDO_EDITOR`, `$VISUAL`, or `$EDITOR`, in that order):

If the editor defined were `vim`:

```console
$ vim /etc/hosts
```

By pressing the <kbd>esc</kbd> key twice, the command will be replaced with the prefix followed by `-e` (default: `sudo -e`), which opens that editor with root privileges:

```console
$ sudo -e /etc/hosts
```

### Previous executed commands

Say you want to delete a system file and get a permission denied error:

```console
$ rm some-system-file.txt
-su: some-system-file.txt: Permission denied
$
```

By pressing the <kbd>esc</kbd> key twice, the plugin will take the last executed command and prefix it with `sudo` (or your configured prefix):

```console
$ sudo rm some-system-file.txt
Password:
$
```

The same applies for file editing commands, as described above.

## Key binding

By default, the plugin uses <kbd>Esc</kbd><kbd>Esc</kbd> as the trigger.

If you want to change it, you can use the `bindkey` command to bind it to a different key:

```sh
bindkey -M emacs '<seq>' sudo-command-line
bindkey -M vicmd '<seq>' sudo-command-line
bindkey -M viins '<seq>' sudo-command-line
```

where `<seq>` is the key sequence you want to use. You can find the keyboard sequence by running `cat` and pressing the desired key combination.

## Configuration

You can override the default prefix (`sudo`) by setting the `ZSH_SUDO_PLUGIN_PREFIX` environment variable in your `.zshrc`:

```zsh
export ZSH_SUDO_PLUGIN_PREFIX="doas"
```

This will make the plugin prefix commands with `doas` instead of `sudo`.


**Important:** If you use a custom prefix different from `sudo`, make sure to create an alias named after that prefix pointing to `sudo`, for example:

```zsh
alias doas='sudo'
```

This ensures proper command substitution and consistent behavior.