up to 952a97dbc99a54bd86141b7a57625e748941a937 + 0.4.1




# Changes in version 0.4.1

## Fixes:

- Arguments to widgets were not properly dash-escaped.  Only matters for widgets
  that take arguments (i.e., that are invoked as `zle ${widget} -- ${args}`).
  (282c7134e8ac, reverts c808d2187a73)


# Changes in version 0.4.0


## Added highlighting of:

- incomplete sudo commands
  (a3047a912100, 2f05620b19ae)

        sudo;
        sudo -u;

- command words following reserved words
  (#207, #222, b397b12ac139 et seq, 6fbd2aa9579b et seq, 8b4adbd991b0)

        if ls; then ls; else ls; fi
        repeat 10 do ls; done

    (The `ls` are now highlighted as a command.)

- comments (when `INTERACTIVE_COMMENTS` is set)
  (#163, #167, 693de99a9030)

        echo Hello # comment

- closing brackets of arithmetic expansion, subshells, and blocks
  (#226, a59f442d2d34, et seq)

        (( foo ))
        ( foo )
        { foo }

- command names enabled by the `PATH_DIRS` option
  (#228, 96ee5116b182)

        # When ~/bin/foo/bar exists, is executable, ~/bin is in $PATH,
        # and 'setopt PATH_DIRS' is in effect
        foo/bar

- parameter expansions with braces inside double quotes
  (#186, 6e3720f39d84)

        echo "${foo}"

- parameter expansions in command word
  (#101, 4fcfb15913a2)

        x=/bin/ls
        $x -l

- the command separators '|&', '&!', '&|'

        view file.pdf &!  ls


## Fixed highlighting of:

- precommand modifiers at non-command-word position
  (#209, 2c9f8c8c95fa)

        ls command foo

- sudo commands with infix redirections
  (#221, be006aded590, 86e924970911)

        sudo -u >/tmp/foo.out user ls

- subshells; anonymous functions
  (#166, #194, 0d1bfbcbfa67, 9e178f9f3948)

        (true)
        () { true }

- parameter assignment statements with no command
  (#205, 01d7eeb3c713)

        A=1;

    (The semicolon used to be highlighted as a mistake)

- cursor highlighter: Remove the cursor highlighting when accepting a line.
  (#109, 4f0c293fdef0)


## Removed features:

- Removed highlighting of approximate paths (`path_approx`).
  (#187, 98aee7f8b9a3)


## Other changes:

- main highlighter refactored to use states rather than booleans.
  (2080a441ac49, et seq)

- Fix initialization when sourcing `zsh-syntax-highlighting.zsh` via a symlink
  (083c47b00707)

- docs: Add screenshot.
  (57624bb9f64b)

- widgets wrapping: Don't add '--' when invoking widgets.
  (c808d2187a73) [_reverted in 0.4.1_]

- Refresh highlighting upon `accept-*` widgets (`accept-line` et al).
  (59fbdda64c21)

- Stop leaking match/mbegin/mend to global scope (thanks to upstream
  `WARN_CREATE_GLOBAL` improvements).
  (d3deffbf46a4)

- 'make install': Permit setting `$(SHARE_DIR)` from the environment.
  (e1078a8b4cf1)

- driver: Tolerate KSH_ARRAYS being set in the calling context.
  (#162, 8f19af6b319d)

- 'make install': Install documentation fully and properly.
  (#219, b1619c001390, et seq)

- docs: Improve 'main' highlighter's documentation.
  (00de155063f5, 7d4252f5f596)

- docs: Moved to a new docs/ tree; assorted minor updates
  (c575f8f37567, 5b34c23cfad5, et seq)

- docs: Split README.md into INSTALL.md
  (0b3183f6cb9a)

- driver: Report `$ZSH_HIGHLIGHT_REVISION` when running from git
  (84734ba95026)


## Developer-visible changes:

- Test harness converted to [TAP](http://testanything.org/tap-specification.html) format
  (d99aa58aaaef, et seq)

- Run each test in a separate subprocess, isolating them from each other
  (d99aa58aaaef, et seq)

- Fix test failure with nonexisting $HOME
  (#216, b2ac98b98150)

- Test output is now colorized.
  (4d3da30f8b72, 6fe07c096109)

- Document `make install`
  (a18a7427fd2c)

- tests: Allow specifying the zsh binary to use.
  (557bb7e0c6a0)

- tests: Add 'make perf' target
  (4513eaea71d7)

- tests: Run each test in a sandbox directory
  (c01533920245)


# Changes in version 0.3.0


## Added highlighting of:

- suffix aliases (requires zsh 5.1.1 or newer):

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

- don't leak $REPLY into global scope


## Developer-visible changes:

- added makefile with `install` and `test` targets

- set `warn_create_global` internally

- document release process




# Version 0.2.1

(Start of changelog.)

