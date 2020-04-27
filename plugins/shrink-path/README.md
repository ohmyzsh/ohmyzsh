# A plugin to shrink directory paths for brevity and pretty-printing


## Examples

For this directory tree:
```
    /home/
      me/
        f o o/     # The prefix f is ambiguous between "f o o" and "f i g".
          bar/
            quux/
          biz/     # The prefix b is ambiguous between bar and biz.
        f i g/
          baz/
```
here are the results of calling `shrink_path <option> /home/me/foo/bar/quux`:
```
    Option        Result
    <none>        /h/m/f o/ba/q
    -l|--last     /h/m/f o/ba/q
    -s|--short    /h/m/f/b/q
    -t|--tilde    ~/f o/ba/q
    -f|--fish     ~/f/b/quux
    -g|--glob     /h*/m*/f o*/ba*/q*
    -3            /hom/me/f o/bar/quu
    -e '$' -3     /hom$/me/f o$/bar/quu$
    -q            /h/m/f\ o/ba/q
    -g -q         /h*/m*/f\ o*/ba*/q*
```


## Usage

For a fish-style working directory in your command prompt, add the following to
your theme or zshrc:

```
    setopt prompt_subst
    PS1='%n@%m $(shrink_path -f)>'
```

The following options are available:

```
    -f, --fish       fish simulation, equivalent to -l -s -t.
    -g, --glob       Add asterisk to allow globbing of shrunk path (equivalent to -e "*")
    -l, --last       Print the last directory's full name.
    -s, --short      Truncate directory names to the number of characters given by -. Without
                     -s, names are truncated without making them ambiguous.
    -t, --tilde      Substitute ~ for the home directory.
    -T, --nameddirs  Substitute named directories as well.
    -#               Truncate each directly to at least this many characters inclusive of the
                     ellipsis character(s) (defaulting to 1).
    -e SYMBOL        Postfix symbol(s) to indicate that a directory name had been truncated.
    -q, --quote      Quote special characters in the shrunk path
```

The long options can also be set via zstyle, like
```
    zstyle :prompt:shrink_path fish yes
```

Note: Directory names containing two or more consecutive spaces are not yet
supported.


## License

Copyright (C) 2008 by Daniel Friesel <derf@xxxxxxxxxxxxxxxxxx>
Copyright (C) 2018-2020 by Pavel N. Krivitsky

License: WTFPL <http://www.wtfpl.net>

Ref: https://www.zsh.org/mla/workers/2009/msg00415.html
     https://www.zsh.org/mla/workers/2009/msg00419.html


## Misc

Keywords: prompt directory truncate shrink collapse fish
