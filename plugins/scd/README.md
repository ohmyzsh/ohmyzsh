# scd - smart change of directory

Define `scd` shell function for changing to any directory with
a few keystrokes.

`scd` keeps history of the visited directories, which serves as an index of
the known paths.  The directory index is updated after every `cd` command in
the shell and can be also filled manually by running `scd -a`.  To switch to
some directory, `scd` needs few fragments of the desired path to match with
the index.  A selection menu is displayed in case of several matches, with a
preference given to recently visited paths.  `scd` can create permanent
directory aliases, which appear as named directories in zsh session.

## INSTALLATION NOTES

Besides oh-my-zsh, `scd` can be used with *bash*, *dash* or *tcsh*
shells and is also available as Vim plugin
[scd.vim](https://github.com/pavoljuhas/scd.vim) and
[IPython](https://ipython.org) extension.  For installation details, see
https://github.com/pavoljuhas/smart-change-directory.

## SYNOPSIS

```sh
scd [options] [pattern1 pattern2 ...]
```

## PATTERNS

Patterns may use all zsh [glob operators](
http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators)
available with *extendedglob* option.  Specified patterns must match
the absolute path and at least one of them must match in the tail.
Several special patterns are also recognized as follows:

<dl><dt>
^PAT</dt><dd>
  PAT must match at the beginning of the path, for example, "^/home"</dd><dt>
PAT$</dt><dd>
  require PAT to match the end of the path, "man$"</dd><dt>
./</dt><dd>
  match only subdirectories of the current directory</dd><dt>
:PAT</dt><dd>
  require PAT to match over the tail component, ":doc", ":re/doc"</dd>
</dl>


## OPTIONS

<dl><dt>
-a, --add</dt><dd>
  add current or specified directories to the directory index.</dd><dt>

--unindex</dt><dd>
  remove current or specified directories from the index.</dd><dt>

-r, --recursive</dt><dd>
  apply options <em>--add</em> or <em>--unindex</em> recursively.</dd><dt>

--alias=ALIAS</dt><dd>
  create alias for the current or specified directory and save it to
  <em>~/.scdalias.zsh</em>.</dd><dt>

--unalias</dt><dd>
  remove ALIAS definition for the current or specified directory from
  <em>~/.scdalias.zsh</em>.  Use "OLD" to purge aliases to non-existent
  directories.</dd><dt>

-A, --all</dt><dd>
  display all directories even those excluded by patterns in
  <em>~/.scdignore</em>.  Disregard the unique matching for a
  directory alias and filtering of less likely paths.</dd><dt>

-p, --push</dt><dd>
  use "pushd" to change to the target directory.</dd><dt>

--list</dt><dd>
  show matching directories and exit.</dd><dt>

-v, --verbose</dt><dd>
  display directory rank in the selection menu.</dd><dt>

-h, --help</dt><dd>
  display this options summary and exit.</dd>
</dl>


## Examples

```sh
# Index recursively some paths for the very first run
scd -ar ~/Documents/

# Change to a directory path matching "doc"
scd doc

# Change to a path matching all of "a", "b" and "c"
scd a b c

# Change to a directory path that ends with "ts"
scd "ts$"

# Show selection menu and ranking of 20 most likely directories
scd -v

# Alias current directory as "xray"
scd --alias=xray

# Jump to a previously defined aliased directory
scd xray
```

## FILES

<dl><dt>
~/.scdhistory</dt><dd>
    time-stamped index of visited directories.</dd><dt>

~/.scdalias.zsh</dt><dd>
    scd-generated definitions of directory aliases.</dd><dt>

~/.scdignore</dt><dd>
    <a href="http://zsh.sourceforge.net/Doc/Release/Expansion.html#Glob-Operators">
    glob patterns</a> for paths to be ignored in the scd search, for example,
    <code>/mnt/backup/*</code>.  The patterns are specified one per line
    and are matched assuming the <em>extendedglob</em> zsh option.  Lines
    starting with "#" are skipped as comments.  The .scdignore patterns
    are not applied in the <em>--all</em> mode.</dd>
</dl>


## ENVIRONMENT

<dl><dt>
SCD_HISTFILE</dt><dd>
    path to the scd index file (by default ~/.scdhistory).</dd><dt>

SCD_HISTSIZE</dt><dd>
    maximum number of entries in the index (5000).  Index is trimmed when it
    exceeds <em>SCD_HISTSIZE</em> by more than 20%.</dd><dt>

SCD_MENUSIZE</dt><dd>
    maximum number of items for directory selection menu (20).</dd><dt>

SCD_MEANLIFE</dt><dd>
    mean lifetime in seconds for exponential decay of directory
    likelihood (86400).</dd><dt>

SCD_THRESHOLD</dt><dd>
    threshold for cumulative directory likelihood.  Directories with
    a lower likelihood compared to the best match are excluded (0.005).
    </dd><dt>

SCD_SCRIPT</dt><dd>
    command script file where scd writes the final <code>cd</code>
    command.  This variable must be defined when scd runs in its own
    process rather than as a shell function.  It is up to the
    scd caller to use the output in <em>SCD_SCRIPT</em>.</dd>
</dl>
