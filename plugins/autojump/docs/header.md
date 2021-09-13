NAME
----

autojump - a faster way to navigate your filesystem

DESCRIPTION
-----------

autojump is a faster way to navigate your filesystem. It works by maintaining a
database of the directories you use the most from the command line.

*Directories must be visited first before they can be jumped to.*

USAGE
-----

`j` is a convenience wrapper function around `autojump`. Any option that can
be used with `autojump` can be used with `j` and vice versa.

- Jump To A Directory That Contains `foo`:

        j foo

- Jump To A Child Directory:

    Sometimes it's convenient to jump to a child directory (sub-directory of
    current directory) rather than typing out the full name.

        jc bar

- Open File Manager To Directories (instead of jumping):

    Instead of jumping to a directory, you can open a file explorer window (Mac
    Finder, Windows Explorer, GNOME Nautilus, etc.) to the directory instead.

        jo music

    Opening a file manager to a child directory is also supported:

        jco images

- Using Multiple Arguments:

    Let's assume the following database:

        30   /home/user/mail/inbox
        10   /home/user/work/inbox

    `j in` would jump into /home/user/mail/inbox as the higher weighted
    entry. However you can pass multiple arguments to autojump to prefer
    a different entry. In the above example, `j w in` would then change
    directory to /home/user/work/inbox.

For more options refer to help:

    autojump --help
