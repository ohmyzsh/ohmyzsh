# A plugin to shrink directory paths for brevity and pretty-printing


## Examples

For this directory tree:
```
    /home/
      me/
        foo/
          bar/
            quux/
          biz/     # The prefix b is ambiguous between bar and biz.
```
here are the results of calling `shrink_path <option> /home/me/foo/bar/quux`:
```
    Option        Result
    <none>        /h/m/f/ba/q
    -l|--last     /h/m/f/ba/quux
    -s|--short    /h/m/f/b/q
    -t|--tilde    ~/f/ba/q
    -f|--fish     ~/f/b/quux
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
    -l, --last       Print the last directory's full name.
    -s, --short      Truncate directory names to the first character. Without
                     -s, names are truncated without making them ambiguous.
    -t, --tilde      Substitute ~ for the home directory.
    -T, --nameddirs  Substitute named directories as well.
```

The long options can also be set via zstyle, like
```
    zstyle :prompt:shrink_path fish yes
```

Note: Directory names containing two or more consecutive spaces are not yet
supported.


## License

Copyright (C) 2008 by Daniel Friesel <derf@xxxxxxxxxxxxxxxxxx>

License: WTFPL <http://www.wtfpl.net>

Ref: https://www.zsh.org/mla/workers/2009/msg00415.html
     https://www.zsh.org/mla/workers/2009/msg00419.html


## Misc

Keywords: prompt directory truncate shrink collapse fish
