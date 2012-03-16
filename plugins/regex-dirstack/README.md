## Regex Matching in the Directory Stack for ZSH ##

Adds `ss` and `csd` to the list of directory manipulation functions.  Zsh (or at
least the one I'm using) is mainting the directory stack for me all the time,
but I don't like how it looks when you type type `dirs -v` and I think the whole
`+n` and `-n` thing is just annoying.  I also don't know why the current
directory is shown.  The current directory is the current directory, so I'm not
interested in it.

So I've simplified it to look "better" (IMO) with `ss` and the `csd` function
will accept a regular expression.

Usage:

    # show stack
    > ss
    1) ~
    2) /tmp
    3) /tmp/this/has a/space in it
    4) /tmp/src/main/scala/package/name/here
    5) /tmp/src/test/scala/package/name/here

    # change to stacked directory
    > csd 4
    /tmp/src/main/scala/package/name/here
    >

    # change to stacked directory by regex
    > csd test
    /tmp/src/test/scala/package/name/here
    >

    # change to stacked directory by more interesting regex
    > csd src.*main
    /tmp/src/main/scala/package/name/here
    >
