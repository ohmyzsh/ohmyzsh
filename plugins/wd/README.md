# wd

[![Build Status](https://travis-ci.org/mfaerevaag/wd.png?branch=master)](https://travis-ci.org/mfaerevaag/wd)

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`. Why? Because `cd` seems inefficient when the folder is frequently visited or has a long path.

![tty.gif](https://raw.githubusercontent.com/mfaerevaag/wd/master/tty.gif)

*NEWS*: If you are not using zsh, check out the c-port, [wd-c](https://github.com/mfaerevaag/wd-c), which works with all shells using wrapper functions.

## Setup

### oh-my-zsh

`wd` comes bundled with [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)!

Just add the plugin in your `~/.zshrc` file:

```zsh
plugins=(... wd)
```

### [Antigen](https://github.com/zsh-users/antigen)

In your `.zshrc`:

```zsh
antigen bundle mfaerevaag/wd
```

### [Antibody](https://github.com/getantibody/antibody)

In your `.zshrc`:

```zsh
antibody bundle mfaerevaag/wd
```

### Arch ([AUR](https://aur.archlinux.org/packages/zsh-plugin-wd-git/))

```zsh
yay -S zsh-plugin-wd-git
# or use any other AUR helper
```

### [zplug](https://github.com/zplug/zplug)

```zsh
zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
```

### Automatic

Run either in terminal:

```zsh
curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh
```

or

```zsh
wget --no-check-certificate https://github.com/mfaerevaag/wd/raw/master/install.sh -O - | sh
```

### Manual

* Clone this repo to your liking

* Add `wd` function to `.zshrc` (or `.profile` etc.):

  ```zsh
  wd() {
      . ~/path/to/cloned/repo/wd/wd.sh
  }
  ```

* Install manpage. From `wd`'s base directory (requires root permissions):

  ```zsh
  cp wd.1 /usr/share/man/man1/wd.1
  chmod 644 /usr/share/man/man1/wd.1
  ```

  **Note:** when pulling and updating `wd`, you'll need to do this again in case of changes to the manpage.

## Completion

If you're NOT using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) and you want to utilize the zsh-completion feature, you will also need to add the path to your `wd` installation (`~/bin/wd` if you used the automatic installer) to your `fpath`. E.g. in your `~/.zshrc`:

```zsh
fpath=(~/path/to/wd $fpath)
```

Also, you may have to force a rebuild of `zcompdump` by running:

```zsh
rm -f ~/.zcompdump; compinit
```

## Usage

* Add warp point to current working directory:

  ```zsh
  wd add foo
  ```

  If a warp point with the same name exists, use `wd add! foo` to overwrite it.

  **Note:** a warp point cannot contain colons, or consist of only spaces and dots. The first will conflict in how `wd` stores the warp points, and the second will conflict with other features, as below.

  You can omit point name to automatically use the current directory's name instead.

* From any directory, warp to `foo` with:

  ```zsh
  wd foo
  ```

* You can also warp to a directory within foo, with autocompletion:

  ```zsh
  wd foo some/inner/path
  ```

* You can warp back to previous directory and higher, with this dot syntax:

  ```zsh
  wd ..
  wd ...
  ```

  This is a wrapper for the zsh's `dirs` function.  
  _You might need to add `setopt AUTO_PUSHD` to your `.zshrc` if you are not using [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh))._

* Remove warp point:

  ```zsh
  wd rm foo
  ```

  You can omit point name to use the current directory's name instead.

* List all warp points (stored in `~/.warprc`):

  ```zsh
  wd list
  ```

* List files in given warp point:

  ```zsh
  wd ls foo
  ```

* Show path of given warp point:

  ```zsh
  wd path foo
  ```

* List warp points to current directory, or optionally, path to given warp point:

  ```zsh
  wd show
  ```

* Remove warp points to non-existent directories.

  ```zsh
  wd clean
  ```

  Use `wd clean!` to not be prompted with confirmation (force).

* Print usage info:

  ```zsh
  wd help
  ```

  The usage will be printed also if you call `wd` with no command

* Print the running version of `wd`:

  ```zsh
  wd --version
  ```

* Specifically set the config file (default being `~/.warprc`), which is useful for testing:

  ```zsh
  wd --config ./file <command>
  ```

* Force `exit` with return code after running. This is not default, as it will *exit your terminal*, though required for testing/debugging.

  ```zsh
  wd --debug <command>
  ```

* Silence all output:

  ```zsh
  wd --quiet <command>
  ```

## Configuration

You can configure `wd` with the following environment variables:

### `WD_CONFIG`

Defines the path where warp points get stored. Defaults to `$HOME/.warprc`.

## Testing

`wd` comes with a small test suite, run with [shunit2](https://code.google.com/p/shunit2/). This can be used to confirm that things are working as they should on your setup, or to demonstrate an issue.

To run, simply `cd` into the `test` directory and run the `tests.sh`.

```zsh
cd ./test
./tests.sh
```

## License

The project is licensed under the [MIT license](https://github.com/mfaerevaag/wd/blob/master/LICENSE).

## Contributing

If you have issues, feedback or improvements, don't hesitate to report it or submit a pull request. In the case of an issue, we would much appreciate if you would include a failing test in `test/tests.sh`. For an explanation on how to run the tests, read the section "Testing" in this README.

----

Credit to [altschuler](https://github.com/altschuler) for an awesome idea.

Hope you enjoy!
