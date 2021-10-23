# sudo

This plugin adds a shortcut to easily add or remove `sudo` from the command line
when pressing <kbd>Esc</kbd> twice. It also adds a function to be able to run
zsh functions with sudo.

To use it, add `sudo` to the plugins array in your zshrc file:

```zsh
plugins=(... sudo)
```

## Usage

- **Key binding**: press <kbd>Esc</kbd> twice to add or remove `sudo` from the command line.
  It has support for `sudoedit`. See the [key binding examples](#examples) section for more
  information.

- **Functions**: to run a function with `sudo`, use `sudofn`. This function allows you
  to run a function in a new zsh process, so the whole function has admin privileges.
  This can be helpful when using functions from an Oh My Zsh plugin, like `systemadmin`.
  Be careful when using this; all effects of the function will be run as root.
  Examples:

  ```zsh
  # This runs the sudo-me function with arguments "one", "two" and "three"
  sudofn sudo-me one two three

  # You might want to use this if omz is installed in a directory owned by root
  sudofn omz update

  # This runs the sudo-me function while passing options to the zsh
  # process (you might want to do this for testing purposes)
  # -f: don't read rc files, -x: run zsh in debug mode
  sudofn -f -x sudo-me one two three
  ```

  The key binding will automatically prepend `sudofn` when you want to call a function.

## Examples

- Typed commands:

  Say you have typed a long command and forgot to add `sudo` in front:

  ```console
  $ apt-get install build-essential
  ```

  By pressing the <kbd>Esc</kbd> key twice, you will have the same command with `sudo` prefixed without typing:

  ```console
  $ sudo apt-get install build-essential
  ```

- Previously executed commands:

  Say you want to delete a system file and get permission denied:

  ```console
  $ rm some-system-file.txt
  -su: some-system-file.txt: Permission denied
  $
  ```

  By pressing the <kbd>Esc</kbd> key twice, you will have the same command with `sudo` prefixed without typing:

  ```console
  $ rm some-system-file.txt
  -su: some-system-file.txt: Permission denied
  $ sudo rm some-system-file.txt
  Password:
  $
  ```
