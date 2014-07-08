## wd

**Maintainer:** [mfaerevaag](https://github.com/mfaerevaag)

`wd` (warp directory) lets you jump to custom directories in zsh, without using cd. Why? Because cd seems ineffecient when the folder is frequently visited or has a long path. [Source](https://github.com/mfaerevaag/wd)

### Usage

 * Add warp point to current working directory:

        wd add test

    If a warp point with the same name exists, use `add!` to overwrite it.

 * From an other directory, warp to test with:

        wd test

 * You can warp back to previous directory, and so on, with the puncticulation syntax:

        wd ..
        wd ...

    This is a wrapper for the zsh `dirs` function.

 * Remove warp point test point:

        wd rm test

 * List warp points to current directory (stored in `~/.warprc`):

        wd show

 * List all warp points (stored in `~/.warprc`):

        wd ls

 * Print usage with no opts or the `help` argument.
