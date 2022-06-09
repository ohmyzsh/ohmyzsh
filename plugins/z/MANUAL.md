# Zsh-z

Zsh-z is a command line tool that allows you to jump quickly to directories that you have visited frequently in the past, or recently -- but most often a combination of the two (a concept known as ["frecency"](https://en.wikipedia.org/wiki/Frecency)). It works by keeping track of when you go to directories and how much time you spend in them. It is then in the position to guess where you want to go when you type a partial string, e.g., `z src` might take you to `~/src/zsh`. `z zsh` might also get you there, and `z c/z` might prove to be even more specific -- it all depends on your habits and how much time you have been using Zsh-z to build up a database. After using Zsh-z for a little while, you will get to where you want to be by typing considerably less than you would need if you were using `cd`.

Zsh-z is a native Zsh port of [rupa/z](https://github.com/rupa/z), a tool written for `bash` and Zsh that uses embedded `awk` scripts to do the heavy lifting. It was quite possibly my most used command line tool for a couple of years. I decided to translate it, `awk` parts and all, into pure Zsh script, to see if by eliminating calls to external tools (`awk`, `sort`, `date`, `sed`, `mv`, `rm`, and `chown`) and reducing forking through subshells I could make it faster. The performance increase is impressive, particularly on systems where forking is slow, such as Cygwin, MSYS2, and WSL. I have found that, in those environments, switching directories using Zsh-z can be over 100% faster than it is using `rupa/z`.

There is a noteworthy stability increase as well. Race conditions have always been a problem with `rupa/z`, and users of that utility will occasionally lose their `.z` databases. By having Zsh-z only use Zsh (`rupa/z` uses a hybrid shell code that works on `bash` as well), I have been able to implement a `zsh/system`-based file-locking mechanism similar to [the one @mafredri once proposed for `rupa/z`](https://github.com/rupa/z/pull/199). It is now nearly impossible to crash the database, even through extreme testing.

There are other, smaller improvements which I try to document in [Improvements and Fixes](#improvements-and-fixes). These include the new default behavior of sorting your tab completions by frecency rather than just letting Zsh sort the raw results alphabetically (a behavior which can be restored if you like it -- [see below](#settings)).

Zsh-z is a drop-in replacement for `rupa/z` and will, by default, use the same database (`~/.z`), so you can go on using `rupa/z` when you launch `bash`.

## Table of Contents
- [News](#news)
- [Installation](#installation)
- [Command Line Options](#command-line-options)
- [Settings](#settings)
- [Case Sensitivity](#case-sensitivity)
- [`ZSHZ_UNCOMMON`](#zshz_uncommon)
- [Making `--add` work for you](#making---add-work-for-you)
- [Other Improvements and Fixes](#other-improvements-and-fixes)
- [Migrating from Other Tools](#migrating-from-other-tools)
- [`COMPLETE_ALIASES`](#complete_aliases)
- [Known Bugs](#known-bugs)

## News

<details>
    <summary>Here are the latest features and updates.</summary>

- June 29, 2022
    + Zsh-z is less likely to leave temporary files sitting around (props @mafredri).
- June 27, 2022
    + A bug was fixed which was preventing paths with spaces in them from being updated ([#61](https://github.com/agkozak/zsh-z/issues/61)).
    + If writing to the temporary database file fails, the database will not be clobbered (props @mafredri).
- December 19, 2021
    + ZSH-z will now display tildes for `HOME` during completion when `ZSHZ_TILDE=1` has been set.
- November 11, 2021
    + A bug was fixed which was preventing ranks from being incremented.
    + `--add` has been made to work with relative paths and has been documented for the user.
- October 14, 2021
    + Completions were being sorted alphabetically, rather than by rank; this error has been fixed.
- September 25, 2021
    + Orthographical change: "Zsh," not "ZSH."
- September 23, 2021
    + `z -xR` will now remove a directory *and its subdirectories* from the database.
    + `z -x` and `z -xR` can now take an argument; without one, `PWD` is assumed.
- September 7, 2021
    + Fixed the unload function so that it removes the `$ZSHZ_CMD` alias (default: `z`).
- August 27, 2021
    + Using `print -v ... -f` instead of `print -v` to work around longstanding bug in Zsh involving `print -v` and multibyte strings.
- August 13, 2021
    + Fixed the explanation string printed during completion so that it may be formatted with `zstyle`.
    + Zsh-z now declares `ZSHZ_EXCLUDE_DIRS` as an array with unique elements so that you do not have to.
- July 29, 2021
    + Temporarily disabling use of `print -v`, which seems to be mangling CJK multibyte strings.
- July 27, 2021
    + Internal escaping of path names now works with older versions of ZSH.
    + Zsh-z now detects and discards any incomplete or incorrectly formattted database entries.
- July 10, 2021
    + Setting `ZSHZ_TRAILING_SLASH=1` makes it so that a search pattern ending in `/` can match the end of a path; e.g. `z foo/` can match `/path/to/foo`.
- June 25, 2021
    + Setting `ZSHZ_TILDE=1` displays the `HOME` directory as `~`.
- May 7, 2021
    + Setting `ZSHZ_ECHO=1` will cause Zsh-z to display the new path when you change directories.
    + Better escaping of path names to deal paths containing the characters ``\`()[]``.
- February 15, 2021
    + Ranks are displayed the way `rupa/z` now displays them, i.e. as large integers. This should help Zsh-z to integrate with other tools.
- January 31, 2021
    + Zsh-z is now efficient enough that, on MSYS2 and Cygwin, it is faster to run it in the foreground than it is to fork a subshell for it.
    + `_zshz_precmd` simply returns if `PWD` is `HOME` or in `ZSH_EXCLUDE_DIRS`, rather than waiting for `zshz` to do that.
- January 17, 2021
    + Made sure that the `PUSHD_IGNORE_DUPS` option is respected.
- January 14, 2021
    + The `z -h` help text now breaks at spaces.
    + `z -l` was not working for Zsh version < 5.
- January 11, 2021
    + Major refactoring of the code.
    + `z -lr` and `z -lt` work as expected.
    + `EXTENDED_GLOB` has been disabled within the plugin to accomodate old-fashioned Windows directories with names such as `Progra~1`.
    + Removed `zshelldoc` documentation.
- January 6, 2021
    + I have corrected the frecency routine so that it matches `rupa/z`'s math, but for the present, Zsh-z will continue to display ranks as 1/10000th of what they are in `rupa/z` -- [they had to multiply theirs by 10000](https://github.com/rupa/z/commit/f1f113d9bae9effaef6b1e15853b5eeb445e0712) to work around `bash`'s inadequacies at dealing with decimal fractions.
- January 5, 2021
    + If you try `z foo`, and `foo` is not in the database but `${PWD}/foo` is a valid directory, Zsh-z will `cd` to it.
- December 22, 2020
    + `ZSHZ_CASE`: when set to `ignore`, pattern matching is case-insensitive; when set to `smart`, patterns are matched case-insensitively when they are all lowercase and case-sensitively when they have uppercase characters in them (a behavior very much like Vim's `smartcase` setting).
    + `ZSHZ_KEEP_DIRS` is an array of directory names that should not be removed from the database, even if they are not currently available (useful when a drive is not always mounted).
    + Symlinked datafiles were having their symlinks overwritten; this bug has been fixed.

</details>

## Installation

### General observations

This script can be installed simply by downloading it and sourcing it from your `.zshrc`:

    source /path/to/zsh-z.plugin.zsh

For tab completion to work, you will want to have loaded `compinit`. The frameworks handle this themselves. If you are not using a framework, put

    autoload -U compinit && compinit

in your .zshrc somewhere below where you source `zsh-z.plugin.zsh`.

If you add

    zstyle ':completion:*' menu select

to your `.zshrc`, your completion menus will look very nice. This `zstyle` invocation should work with any of the frameworks below as well.

### For [antigen](https://github.com/zsh-users/antigen) users

Add the line

    antigen bundle agkozak/zsh-z

to your `.zshrc`, somewhere above the line that says `antigen apply`.

### For [oh-my-zsh](http://ohmyz.sh/) users

Execute the following command:

    git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z

and add `zsh-z` to the line of your `.zshrc` that specifies `plugins=()`, e.g., `plugins=( git zsh-z )`.

### For [prezto](https://github.com/sorin-ionescu/prezto) users

Execute the following command:

    git clone https://github.com/agkozak/zsh-z.git ~/.zprezto-contrib/zsh-z

Then edit your `~/.zpreztorc` file. Make sure the line that says

    zstyle ':prezto:load' pmodule-dirs $HOME/.zprezto-contrib

is uncommented. Then find the section that specifies which modules are to be loaded; it should look something like this:

    zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'spectrum' \
        'utility' \
        'completion' \
        'prompt'

Add a backslash to the end of the last line add `'zsh-z'` to the list, e.g.,

    zstyle ':prezto:load' pmodule \
        'environment' \
        'terminal' \
        'editor' \
        'history' \
        'directory' \
        'spectrum' \
        'utility' \
        'completion' \
        'prompt' \
        'zsh-z'

Then relaunch `zsh`.

### For [zcomet](https://github.com/agkozak/zcomet) users
        
Simply add

    zcomet load agkozak/zsh-z

to your `.zshrc` (below where you source `zcomet.zsh` and above where you run `zcomet compinit`).

### For [zgen](https://github.com/tarjoilija/zgen) users

Add the line

    zgen load agkozak/zsh-z

somewhere above the line that says `zgen save`. Then run

    zgen reset
    zsh

to refresh your init script.

### For [Zim](https://github.com/zimfw/zimfw)

Add the following line to your `.zimrc`:

    zmodule https://github.com/agkozak/zsh-z

Then run

    zimfw install

and restart your shell.

### For [Zinit](https://github.com/zdharma-continuum/zinit) users

Add the line

    zinit load agkozak/zsh-z

to your `.zshrc`.

`zsh-z` supports `zinit`'s `unload` feature; just run `zinit unload agkozak/zshz` to restore the shell to its state before `zsh-z` was loaded.

### For [Znap](https://github.com/marlonrichert/zsh-snap) users

Add the line

    znap source agkozak/zsh-z

somewhere below the line where you `source` Znap itself.

### For [zplug](https://github.com/zplug/zplug) users

Add the line

    zplug "agkozak/zsh-z"

somewhere above the line that says `zplug load`. Then run

    zplug install
    zplug load

to install `zsh-z`.

## Command Line Options

- `--add` Add a directory to the database
- `-c`    Only match subdirectories of the current directory
- `-e`    Echo the best match without going to it
- `-h`    Display help
- `-l`    List all matches without going to them
- `-r`    Match by rank (i.e. how much time you spend in directories)
- `-t`    Time -- match by how recently you have been to directories
- `-x`    Remove a directory (by default, the current directory) from the database
- `-xR`   Remove a directory (by default, the current directory) and its subdirectories from the database

# Settings

Zsh-z has environment variables (they all begin with `ZSHZ_`) that change its behavior if you set them; you can also keep your old ones if you have been using `rupa/z` (they begin with `_Z_`).

* `ZSHZ_CMD` changes the command name (default: `z`)
* `ZSHZ_COMPLETION` can be `'frecent'` (default) or `'legacy'`, depending on whether you want your completion results sorted according to frecency or simply sorted alphabetically
* `ZSHZ_DATA` changes the database file (default: `~/.z`)
* `ZSHZ_ECHO` displays the new path name when changing directories (default: `0`)
* `ZSHZ_EXCLUDE_DIRS` is an array of directories to keep out of the database (default: empty)
* `ZSHZ_KEEP_DIRS` is an array of directories that should not be removed from the database, even if they are not currently available (useful when a drive is not always mounted) (default: empty)
* `ZSHZ_MAX_SCORE` is the maximum combined score the database entries can have before they begin to age and potentially drop out of the database (default: 9000)
* `ZSHZ_NO_RESOLVE_SYMLINKS` prevents symlink resolution (default: `0`)
* `ZSHZ_OWNER` allows usage when in `sudo -s` mode (default: empty)
* `ZSHZ_TILDE` displays the name of the `HOME` directory as a `~` (default: `0`)
* `ZSHZ_TRAILING_SLASH` makes it so that a search pattern ending in `/` can match the final element in a path; e.g., `z foo/` can match `/path/to/foo` (default: `0`)
* `ZSHZ_UNCOMMON` changes the logic used to calculate the directory jumped to; [see below](#zshz_uncommon`) (default: `0`)

## Case sensitivity

The default behavior of Zsh-z is to try to find a case-sensitive match. If there is none, then Zsh-z tries to find a case-insensitive match.

Some users prefer simple case-insensitivity; this behavior can be enabled by setting

    ZSHZ_CASE=ignore

If you like Vim's `smartcase` setting, where lowercase patterns are case-insensitive while patterns with any uppercase characters are treated case-sensitively, try setting

    ZSHZ_CASE=smart

## `ZSHZ_UNCOMMON`

A common complaint about the default behavior of `rupa/z` and Zsh-z involves "common prefixes." If you type `z code` and the best matches, in increasing order, are

    /home/me/code/foo
    /home/me/code/bar
    /home/me/code/bat

Zsh-z will see that all possible matches share a common prefix and will send you to that directory -- `/home/me/code` -- which is often a desirable result. But if the possible matches are

    /home/me/.vscode/foo
    /home/me/code/foo
    /home/me/code/bar
    /home/me/code/bat

then there is no common prefix. In this case, `z code` will simply send you to the highest-ranking match, `/home/me/code/bat`.

You may enable an alternate, experimental behavior by setting `ZSHZ_UNCOMMON=1`. If you do that, Zsh-z will not jump to a common prefix, even if one exists. Instead, it chooses the highest-ranking match -- but it drops any subdirectories that do not include the search term. So if you type `z bat` and `/home/me/code/bat` is the best match, that is exactly where you will end up. If, however, you had typed `z code` and the best match was also `/home/me/code/bat`, you would have ended up in `/home/me/code` (because `code` was what you had searched for). This feature is still in development, and feedback is welcome.

## Making `--add` Work for You

Zsh-z internally uses the `--add` option to add paths to its database. @zachriggle pointed out to me that users might want to use `--add` themselves, so I have altered it a little to make it more user-friendly.

A good example might involve a directory tree that has Git repositories within it. The working directories could be added to the Zsh-z database as a batch with

    for i in $(find $PWD -maxdepth 3 -name .git -type d); do
      z --add ${i:h}
    done

(As a Zsh user, I tend to use `**` instead of `find`, but it is good to see how deep your directory trees go before doing that.)


## Other Improvements and Fixes

* `z -x` works, with the help of `chpwd_functions`.
* Zsh-z works on Solaris.
* Zsh-z uses the "new" `zshcompsys` completion system instead of the old `compctl` one.
* There is no error message when the database file has not yet been created.
* There is support for special characters (e.g., `[`) in directory names.
* If `z -l` only returns one match, a common root is not printed.
* Exit status codes increasingly make sense.
* Completions work with options `-c`, `-r`, and `-t`.
* If `~/foo` and `~/foob` are matches, `~/foo` is *not* the common root. Only a common parent directory can be a common root.
* `z -x` and the new, recursive `z -xR` can take an argument so that you can remove directories other than `PWD` from the database.

## Migrating from Other Tools

Zsh-z's database format is identical to that of `rupa/z`. You may switch freely between the two tools (I still use `rupa/z` for `bash`). `fasd` also uses that database format, but it stores it by default in `~/.fasd`, so you will have to `cp ~/.fasd ~/.z` if you want to use your old directory history.

If you are coming to Zsh-z (or even to the original `rupa/z`, for that matter) from `autojump`, try using my [`jumpstart-z`](https://github.com/agkozak/jumpstart-z/blob/master/jumpstart-z) tool to convert your old database to the Zsh-z format, or simply run

    awk -F "\t" '{printf("%s|%0.f|%s\n", $2, $1, '"$(date +%s)"')}' < /path/to/autojump.txt > ~/.z

## `COMPLETE_ALIASES`

`z`, or any alternative you set up using `$ZSH_CMD` or `$_Z_CMD`, is an alias. `setopt COMPLETE_ALIASES` divorces the tab completion for aliases from the underlying commands they invoke, so if you enable `COMPLETE_ALIASES`, tab completion for Zsh-z will be broken. You can get it working again, however, by adding under

    setopt COMPLETE_ALIASES

the line

    compdef _zshz ${ZSHZ_CMD:-${_Z_CMD:-z}}

That will re-bind `z` or the command of your choice to the underlying Zsh-z function.

## Known Bugs
It is possible to run a completion on a string with spaces in it, e.g., `z us bi<TAB>` might take you to `/usr/local/bin`. This works, but as things stand, after the completion the command line reads

    z us /usr/local/bin.

You get where you want to go, but the detritus on the command line is annoying. This is also a problem in `rupa/z`, but I am keen on eventually eliminating this glitch. Advice is welcome.
