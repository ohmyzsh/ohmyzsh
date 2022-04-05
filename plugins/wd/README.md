<<<<<<< HEAD
wd
==

[![Build Status](https://travis-ci.org/mfaerevaag/wd.png?branch=master)](https://travis-ci.org/mfaerevaag/wd)

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`. Why? Because `cd` seems ineffecient when the folder is frequently visited or has a long path.

*NOTE*: If you are not using zsh, check out the `ruby` branch which has `wd` implemented as a gem.


### Setup

### oh-my-zsh

`wd` comes bundles with [oh-my-zshell](https://github.com/robbyrussell/oh-my-zsh)!

Just add the plugin in your `~/.zshrc` file:

    plugins=(... wd)


#### Automatic

Run either in terminal:

 * `curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh`

 * `wget --no-check-certificate https://github.com/mfaerevaag/wd/raw/master/install.sh -O - | sh`


#### Manual

 * Clone this repo to your liking

 * Add `wd` function to `.zshrc` (or `.profile` etc.):

        wd() {
            . ~/path/to/cloned/repo/wd/wd.sh
        }

 * Install manpage. From `wd`'s base directory (requires root permissions):

        # cp wd.1 /usr/share/man/man1/wd.1
        # chmod 644 /usr/share/man/man1/wd.1

    Note, when pulling and updating `wd`, you'll need to do this again in case of changes to the manpage.


#### Completion

If you're NOT using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) and you want to utelize the zsh-completion feature, you will also need to add the path to your `wd` installation (`~/bin/wd` if you used the automatic installer) to your `fpath`. E.g. in your `~/.zshrc`:

    fpath=(~/path/to/wd $fpath)

Also, you may have to force a rebuild of `zcompdump` by running:

    $ rm -f ~/.zcompdump; compinit



### Usage

 * Add warp point to current working directory:

        $ wd add foo

    If a warp point with the same name exists, use `add!` to overwrite it.

    Note, a warp point cannot contain colons, or only consist of only spaces and dots. The first will conflict in how `wd` stores the warp points, and the second will conflict other features, as below.

 * From an other directory (not necessarily), warp to `foo` with:

        $ wd foo

 * You can warp back to previous directory, and so on, with this dot syntax:

        $ wd ..
        $ wd ...

    This is a wrapper for the zsh `dirs` function.
    (You might need `setopt AUTO_PUSHD` in your `.zshrc` if you hare not using [oh-my-zshell](https://github.com/robbyrussell/oh-my-zsh)).

 * Remove warp point test point:

        $ wd rm foo

 * List all warp points (stored in `~/.warprc`):

        $ wd list

 * List files in given warp point:

        $ wd ls foo

 * Show path of given warp point:

        $ wd path foo

 * List warp points to current directory, or optionally, path to given warp point:

        $ wd show

 * Remove warp points to non-existent directories.

        $ wd clean

    Use `clean!` to not be prompted with confirmation (force).

 * Print usage with no opts or the `help` argument:

        $ wd help

 * Print the running version of `wd`:

        $ wd --version

 * Specifically set the config file (default `~/.warprc`), which is useful when testing:

        $ wd --config ./file <action>

 * Force `exit` with return code after running. This is not default, as it will *exit your terminal*, though required when testing/debugging.

        $ wd --debug <action>

 * Silence all output:

        $ wd --quiet <action>


### Testing

`wd` comes with a small test suite, run with [shunit2](https://code.google.com/p/shunit2/). This can be used to confirm that things are working as it should on your setup, or to demonstrate an issue.

To run, simply `cd` into the `test` directory and run the `tests.sh`.

    $ ./tests.sh


### License

The project is licensed under the [MIT-license](https://github.com/mfaerevaag/wd/blob/master/LICENSE).


### Finally

If you have issues, feedback or improvements, don't hesitate to report it or submit a pull-request. In the case of an issue, we would much appreciate if you would include a failing test in `test/tests.sh`. Explanation on how to run the tests, read the section "Testing" in this README.

Credit to [altschuler](https://github.com/altschuler) for awesome idea.
=======
# wd

[![Build Status](https://travis-ci.org/mfaerevaag/wd.png?branch=master)](https://travis-ci.org/mfaerevaag/wd)

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`.
Why?
Because `cd` seems inefficient when the folder is frequently visited or has a long path.

![tty.gif](https://raw.githubusercontent.com/mfaerevaag/wd/master/tty.gif)

## Setup

### [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)

`wd` comes bundled with oh-my-zsh!

Just add the plugin in your `.zshrc` file:

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

1. Install from the AUR

```zsh
yay -S zsh-plugin-wd-git
# or use any other AUR helper
```

2. Then add to your `.zshrc`:

```zsh
wd() {
    . /usr/share/wd/wd.sh
}
```

### [zplug](https://github.com/zplug/zplug)

```zsh
zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load:"wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"
```

### Automatic

_Note: automatic install does not provide the manpage. It is also poor security practice to run remote code without first reviewing it, so you ought to look [here](https://github.com/mfaerevaag/wd/blob/master/install.sh)_

Run either command in your terminal:

```zsh
curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh
```

or

```zsh
wget --no-check-certificate https://github.com/mfaerevaag/wd/raw/master/install.sh -O - | sh
```

### Manual

1. Clone this repository on your local machine in a sensible location (if you know what you're doing of course all of this is up to you):

```zsh
git clone git@github.com:mfaerevaag/wd.git ~/.local/wd --depth 1
```

2. Add `wd` function to `.zshrc` (or `.profile` etc.):

```zsh
wd() {
    . ~/.local/wd/wd.sh
}
```

3. Install manpage (optional):

```zsh
sudo cp ~/.local/wd/wd.1 /usr/share/man/man1/wd.1
sudo chmod 644 /usr/share/man/man1/wd.1
```

**Note:** when pulling and updating `wd`, you'll need to repeat step 3 should the manpage change

## Completion

If you're NOT using [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) and you want to utilize the zsh-completion feature, you will also need to add the path to your `wd` installation (`~/bin/wd` if you used the automatic installer) to your `fpath`.
E.g. in your `~/.zshrc`:

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

If a warp point with the same name exists, use `wd add foo --force` to overwrite it.

**Note:** a warp point cannot contain colons, or consist of only spaces and dots.
The first will conflict in how `wd` stores the warp points, and the second will conflict with other features, as below.

You can omit point name to automatically use the current directory's name instead.

* From any directory, warp to `foo` with:

```zsh
wd foo
```

* You can also warp to a directory within `foo`, with autocompletion:

```zsh
wd foo some/inner/path
```

* You can warp back to previous directory and higher, with this dot syntax:

```zsh
wd ..
wd ...
```

This is a wrapper for the zsh's `dirs` function.  
_You might need to add `setopt AUTO_PUSHD` to your `.zshrc` if you are not using [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)._

* Remove warp point:

```zsh
wd rm foo
```

You can omit point name to use the current directory's name instead.

* List all warp points (stored in `~/.warprc` by default):

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

Use `wd clean --force` to not be prompted with confirmation.

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

`wd` comes with a small test suite, run with [shunit2](https://github.com/kward/shunit2). This can be used to confirm that things are working as they should on your setup, or to demonstrate an issue.

To run, simply `cd` into the `test` directory and run the `tests.sh`.

```zsh
cd ./test
./tests.sh
```

## Maintainers

Following @mfaerevaag stepping away from active maintainership of this repository, the following users now are also maintainers of the repo:

* @alpha-tango-kilo

* @MattLewin

Anyone else contributing is greatly appreciated and will be mentioned in the release notes!

---

Credit to [altschuler](https://github.com/altschuler) for an awesome idea.
>>>>>>> 4d9e5ce9a7d8db3c3aadcae81580a5c3ff5a0e8b

Hope you enjoy!
