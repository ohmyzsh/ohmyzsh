## wd

**Maintainer:** [mfaerevaag](https://github.com/mfaerevaag)

`wd` (*warp directory*) lets you jump to custom directories in zsh, without using `cd`. Why? Because `cd` seems ineffecient when the folder is frequently visited or has a long path. [Source](https://github.com/mfaerevaag/wd)

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

 * Remove warp point test point:

        $ wd rm foo

 * List all warp points (stored in `~/.warprc`):

        $ wd ls

 * List warp points to current directory

        $ wd show

 * Print usage with no opts or the `help` argument.
