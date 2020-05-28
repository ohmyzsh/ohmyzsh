wd
==

[![Build Status](https://travis-ci.org/mfaerevaag/wd.png?branch=master)](https://travis-ci.org/mfaerevaag/wd)

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`. Why? Because `cd` seems inefficient when the folder is frequently visited or has a long path.

![tty.gif](https://raw.githubusercontent.com/mfaerevaag/wd/master/tty.gif)

*NEWS*: If you are not using zsh, check out the c-port, [wd-c](https://github.com/mfaerevaag/wd-c), which works with all shells using wrapper functions.

### Setup

### oh-my-zsh

`wd` comes bundled with [oh-my-zshell](https://github.com/ohmyzsh/ohmyzsh)!

Just add the plugin in your `~/.zshrc` file:

    plugins=(... wd)


#### Automatic

Run either in terminal:

 * `curl -L https://github.com/mfaerevaag/wd/raw/master/install.sh | sh`

 * `wget --no-check-certificate https://github.com/mfaerevaag/wd/raw/master/install.sh -O - | sh`

##### Arch ([AUR](https://aur.archlinux.org/))

    # yaourt -S zsh-plugin-wd-git


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

If you're NOT using [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh) and you want to utilize the zsh-completion feature, you will also need to add the path to your `wd` installation (`~/bin/wd` if you used the automatic installer) to your `fpath`. E.g. in your `~/.zshrc`:

    fpath=(~/path/to/wd $fpath)

Also, you may have to force a rebuild of `zcompdump` by running:

    $ rm -f ~/.zcompdump; compinit



### Usage

 * Add warp point to current working directory:

        $ wd add foo

    If a warp point with the same name exists, use `add!` to overwrite it.

    Note, a warp point cannot contain colons, or only consist of only spaces and dots. The first will conflict in how `wd` stores the warp points, and the second will conflict with other features, as below.

    You can omit point name to use the current directory's name instead.

 * From an other directory (not necessarily), warp to `foo` with:

        $ wd foo

 * You can warp back to previous directory, and so on, with this dot syntax:

        $ wd ..
        $ wd ...

    This is a wrapper for the zsh `dirs` function.
    (You might need `setopt AUTO_PUSHD` in your `.zshrc` if you hare not using [oh-my-zshell](https://github.com/ohmyzsh/ohmyzsh)).

 * Remove warp point test point:

        $ wd rm foo

    You can omit point name to use the current directory's name instead.

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

If you have issues, feedback or improvements, don't hesitate to report it or submit a pull-request. In the case of an issue, we would much appreciate if you would include a failing test in `test/tests.sh`. For an explanation on how to run the tests, read the section "Testing" in this README.

Credit to [altschuler](https://github.com/altschuler) for an awesome idea.

Hope you enjoy!
