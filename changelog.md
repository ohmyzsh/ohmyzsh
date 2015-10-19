up to 9a3c7d19609ca8c426a54b252b8509faf63b0bd5


# Changes in version 0.3.0


## Added highlighting of:

- suffix aliases:

        alias -s png=display
        foo.png

- prefix redirections:

        <foo.txt cat

- redirection operators:

        echo > foo.txt

- arithmetic evaluations:

        (( 42 ))

- $'' strings, including \x/\octal/\u/\U escapes

        : $'foo\u0040bar'

- multiline strings:

        % echo "line 1
        line 2"

- string literals that haven't been finished:

        % echo "Hello, world

- command words that involve tilde expansion:

        % ~/bin/foo


## Fixed highlighting of:

- quoted command words:

        % \ls

- backslash escapes in "" strings:

        % echo "\x41"

- noglob after command separator:

        % :; noglob echo *

- glob after command separator, when the first command starts with 'noglob':

        % noglob true; echo *

- the region (vi visual mode / set-mark-command) (issue #165)

- redirection and command separators that would be highlighted as `path_approx`

        % echo foo;‸
        % echo <‸

    (where `‸` represents the cursor location)

- escaped globbing (outside quotes)

        % echo \*


## Other changes:

- implemented compatibility with zsh's paste highlighting (issue #175)

- `$?` propagated correctly to wrapped widgets


## Developer-visible changes:

- added makefile with `install` and `test` targets

- set `warn_create_global` internally




# Version 0.2.1

(Start of changelog.)

