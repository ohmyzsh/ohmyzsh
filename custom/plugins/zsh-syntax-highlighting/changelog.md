# Changes in version 0.6.0

This is a stable release, featuring bugfixes and minor improvements.


## Performance improvements:

(none)


## Added highlighting of:

- The `isearch` and `suffix` [`$zle_highlight` settings][zshzle-Character-Highlighting].
  (79e4d3d12405, 15db71abd0cc, b56ee542d619; requires zsh 5.3 for `$ISEARCHMATCH_ACTIVE` / `$SUFFIX_ACTIVE` support)

[zshzle-Character-Highlighting]: http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting

- Possible history expansions in double-quoted strings.
  (76ea9e1df316)

- Mismatched `if`/`then`/`elif`/`else`/`fi`.
  (73cb83270262)


## Fixed highlighting of:

- A comment line followed by a non-comment line.
  (#385, 9396ad5c5f9c)

- An unquoted `$*` (expands to the positional parameters).
  (237f89ad629f)

- history-incremental-pattern-search-backward under zsh 5.3.1.
  (#407, #415, 462779629a0c)


## API changes (for highlighter authors):

(none)


## Developer-visible changes:

- tests: Set the `ALIAS_FUNC_DEF` option for zsh 5.4 compatibility.
  (9523d6d49cb3)


## Other changes:

- docs: Added before/after screenshots.
  (cd9ec14a65ec..b7e277106b49)

- docs: Link Fedora package.
  (3d74aa47e4a7, 5feed23962df)

- docs: Link FreeBSD port.
  (626c034c68d7)

- docs: Link OpenSUSE Build Service packages
  (#419, dea1fedc7358)

- Prevent user-defined aliases from taking effect in z-sy-h's own code.
  (#390, 2dce602727d7, 8d5afe47f774; and #392, #395, b8fa1b9dc954)

- docs: Update zplug installation instructions.
  (#399, 4f49c4a35f17)

- Improve "unhandled ZLE widget 'foo'" error message.
  (#409, be083d7f3710)

- Fix printing of "failed loading highlighters" error message.
  (#426, ad522a091429)


# Changes in version 0.5.0


## Performance improvements:

We thank Sebastian Gniazdowski and "m0viefreak" for significant contributions
in this area.

- Optimize string operations in the `main` (default) highlighter.
  (#372/3cb58fd7d7b9, 02229ebd6328, ef4bfe5bcc14, #372/c6b6513ac0d6, #374/15461e7d21c3)

- Command word highlighting:  Use the `zsh/parameter` module to avoid forks.
  Memoize (cache) the results.
  (#298, 3ce01076b521, 2f18ba64e397, 12b879caf7a6; #320, 3b67e656bff5)

- Avoid forks in the driver and in the `root` highlighter.
  (b9112aec798a, 38c8fbea2dd2)


## Added highlighting of:

- `pkexec` (a precommand).
  (#248, 4f3910cbbaa5)

- Aliases that cannot be defined normally nor invoked normally (highlighted as an error).
  (#263 (in part), 28932316cca6)

- Path separators (`/`) — the default behaviour remains to highlight path separators
  and path components the same way.
  (#136, #260, 6cd39e7c70d3, 9a934d291e7c, f3d3aaa00cc4)

- Assignments to individual positional arguments (`42=foo` to assign to `$42`).
  (f4036a09cee3)

- Linewise region (the `visual-line-mode` widget, bound to `V` in zsh's `vi` keymap).
  (#267, a7a7f8b42280, ee07588cfd9b)

- Command-lines recalled by `isearch` mode; requires zsh≥5.3.
  (#261 (in part); #257; 4ad311ec0a68)

- Command-lines whilst the `IGNORE_BRACES` or `IGNORE_CLOSE_BRACES` option is in effect.
  (a8a6384356af, 02807f1826a5)

- Mismatched parentheses and braces (in the `main` highlighter).
  (51b9d79c3bb6, 2fabf7ca64b7, a4196eda5e6f, and others)

- Mismatched `do`/`done` keywords.
  (b2733a64da93)

- Mismatched `foreach`/`end` keywords.
  (#96, 2bb8f0703d8f)

- In Bourne-style function definitions, when the `MULTI_FUNC_DEF` option is set
  (which is the default), highlight the first word in the function body as
  a command word: `f() { g "$@" }`.
  (6f91850a01e1)

- `always` blocks.
  (#335, e5782e4ddfb6)

- Command substitutions inside double quotes, `"$(echo foo)"`.
  (#139 (in part), c3913e0d8ead)

- Non-alphabetic parameters inside double quotes (`"$$"`, `"$#"`, `"$*"`, `"$@"`, `"$?"`, `"$-"`).
  (4afe670f7a1b, 44ef6e38e5a7)

- Command words from future versions of zsh (forward compatibly).
  This also adds an `arg0` style that all other command word styles fall back to.
  (b4537a972eed, bccc3dc26943)

- Escaped history expansions inside double quotes: `: "\!"`
  (28d7056a7a06, et seq)


## Fixed highlighting of:

- Command separator tokens in syntactically-invalid positions.
  (09c4114eb980)

- Redirections with a file descriptor number at command word.
  (#238 (in part), 73ee7c1f6c4a)

- The `select` prompt, `$PS3`.
  (#268, 451665cb2a8b)

- Values of variables in `vared`.
  (e500ca246286)

- `!` as an argument (neither a history expansion nor a reserved word).
  (4c23a2fd1b90)

- "division by zero" error under the `brackets` highlighter when `$ZSH_HIGHLIGHT_STYLES` is empty.
  (f73f3d53d3a6)

- Process substitutions, `<(pwd)` and `>(wc -l)`.
  (#302, 6889ff6bd2ad, bfabffbf975c, fc9c892a3f15)

- The non-`SHORT_LOOPS` form of `repeat` loops: `repeat 42; do true; done`.
  (#290, 4832f18c50a5, ef68f50c048f, 6362c757b6f7)

- Broken symlinks (are now highlighted as files).
  (#342, 95f7206a9373, 53083da8215e)

- Lines accepted from `isearch` mode.
  (#284; #257, #259, #288; 5bae6219008b, a8fe22d42251)

- Work around upstream bug that triggered when the command word was a relative
  path, that when interpreted relative to a $PATH directory denoted a command;
  the effect of that upstream bug was that the relative path was cached as
  a "valid external command name".
  (#354, #355, 51614ca2c994, fdaeec45146b, 7d38d07255e4;
  upstream fix slated to be released in 5.3 (workers/39104))

- After accepting a line with the cursor on a bracket, the matching bracket
  of the bracket under the cursor no longer remains highlighted (with the
  `brackets` highlighter).
  (4c4baede519a)

- The first word on a new line within an array assignment or initialization is no
  longer considered a command position.
  (8bf423d16d46)

- Subshells that end at command position, `(A=42)`, `(true;)`.
  (#231, 7fb6f9979121; #344, 4fc35362ee5a)

- Command word after array assignment, `a=(lorem ipsum) pwd`.
  (#330, 7fb6f9979121)


## API changes (for highlighter authors):

- New interface `_zsh_highlight_add_highlight`.
  (341a3ae1f015, c346f6eb6fb6)

- tests: Specify the style key, not its value, in test expectations.
  (a830613467af, fd061b5730bf, eaa4335c3441, among others)

- Module author documentation improvements.
  (#306 (in part), 217669270418, 0ff354b44b6e, 80148f6c8402, 364f206a547f, and others)

- The driver no longer defines a `_zsh_highlight_${highlighter}_highlighter_cache`
  variable, which is in the highlighters' namespace.
  (3e59ab41b6b8, 80148f6c8402, f91a7b885e7d)

- Rename highlighter entry points.  The old names remain supported for
  backwards compatibility.
  (a3d5dfcbdae9, c793e0dceab1)

- tests: Add the "NONE" expectation.
  (4da9889d1545, 13018f3dd735, d37c55c788cd)

- tests: consider a test that writes to stderr to have failed.
  (#291, 1082067f9315)


## Developer-visible changes:

- Add `make quiet-test`.
  (9b64ad750f35)

- test harness: Better quote replaceables in error messages.
  (30d8f92df225)

- test harness: Fix exit code for XPASS.
  (bb8d325c0cbd)

- Create [HACKING.md](HACKING.md).
  (cef49752fd0e)

- tests: Emit a description for PASS test points.
  (6aa57d60aa64, f0bae44b76dd)

- tests: Create a script that generates a test file.
  (8013dc3b8db6, et seq; `tests/generate.zsh`)


## Other changes:

- Under zsh≤5.2, widgets whose names start with a `_` are no longer excluded
  from highlighting.
  (ed33d2cb1388; reverts part of 186d80054a40 which was for #65)

- Under zsh≤5.2, widgets implemented by a function named after the widget are
  no longer excluded from highlighting.
  (487b122c480d; reverts part of 776453cb5b69)

- Under zsh≤5.2, shell-unsafe widget names can now be wrapped.
  (#278, 6a634fac9fb9, et seq)

- Correct some test expectations.
  (78290e043bc5)

- `zsh-syntax-highlighting.plugin.zsh`: Convert from symlink to plain file
  for msys2 compatibility.
  (#292, d4f8edc9f3ad)

- Document installation under some plugin managers.
  (e635f766bef9, 9cab566f539b)

- Don't leak the `PATH_DIRS` option.
  (7b82b88a7166)

- Don't require the `FUNCTION_ARGZERO` option to be set.
  (#338, 750aebc553f2)

- Under zsh≤5.2, support binding incomplete/nonexistent widgets.
  (9e569bb0fe04, part of #288)

- Make the driver reentrant, fixing possibility of infinite recursion
  under zsh≤5.2 under interaction with theoretical third-party code.
  (#305, d711563fe1bf, 295d62ec888d, f3242cbd6aba)

- Fix warnings when `WARN_CREATE_GLOBAL` is set prior to sourcing zsh-syntax-highlighting.
  (z-sy-h already sets `WARN_CREATE_GLOBAL` internally.)
  (da60234fb236)

- Warn only once, rather than once per keypress, when a highlighter is unavailable.
  (0a9b347483ae)


# Changes in version 0.4.1

## Fixes:

- Arguments to widgets were not properly dash-escaped.  Only matters for widgets
  that take arguments (i.e., that are invoked as `zle ${widget} -- ${args}`).
  (282c7134e8ac, reverts c808d2187a73)


# Changes in version 0.4.0


## Added highlighting of:

- incomplete sudo commands
  (a3047a912100, 2f05620b19ae)

    ```zsh
    sudo;
    sudo -u;
    ```

- command words following reserved words
  (#207, #222, b397b12ac139 et seq, 6fbd2aa9579b et seq, 8b4adbd991b0)

    ```zsh
    if ls; then ls; else ls; fi
    repeat 10 do ls; done
    ```

    (The `ls` are now highlighted as a command.)

- comments (when `INTERACTIVE_COMMENTS` is set)
  (#163, #167, 693de99a9030)

    ```zsh
    echo Hello # comment
    ```

- closing brackets of arithmetic expansion, subshells, and blocks
  (#226, a59f442d2d34, et seq)

    ```zsh
    (( foo ))
    ( foo )
    { foo }
    ```

- command names enabled by the `PATH_DIRS` option
  (#228, 96ee5116b182)

    ```zsh
    # When ~/bin/foo/bar exists, is executable, ~/bin is in $PATH,
    # and 'setopt PATH_DIRS' is in effect
    foo/bar
    ```

- parameter expansions with braces inside double quotes
  (#186, 6e3720f39d84)

    ```zsh
    echo "${foo}"
    ```

- parameter expansions in command word
  (#101, 4fcfb15913a2)

    ```zsh
    x=/bin/ls
    $x -l
    ```

- the command separators '\|&', '&!', '&\|'

    ```zsh
    view file.pdf &!  ls
    ```


## Fixed highlighting of:

- precommand modifiers at non-command-word position
  (#209, 2c9f8c8c95fa)

    ```zsh
    ls command foo
    ```

- sudo commands with infix redirections
  (#221, be006aded590, 86e924970911)

    ```zsh
    sudo -u >/tmp/foo.out user ls
    ```

- subshells; anonymous functions
  (#166, #194, 0d1bfbcbfa67, 9e178f9f3948)

    ```zsh
    (true)
    () { true }
    ```

- parameter assignment statements with no command
  (#205, 01d7eeb3c713)

    ```zsh
    A=1;
    ```

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

    ```zsh
    alias -s png=display
    foo.png
    ```

- prefix redirections:

    ```zsh
    <foo.txt cat
    ```

- redirection operators:

    ```zsh
    echo > foo.txt
    ```

- arithmetic evaluations:

    ```zsh
    (( 42 ))
    ```

- $'' strings, including \x/\octal/\u/\U escapes

    ```zsh
    : $'foo\u0040bar'
    ```

- multiline strings:

    ```zsh
    % echo "line 1
    line 2"
    ```

- string literals that haven't been finished:

    ```zsh
    % echo "Hello, world
    ```
- command words that involve tilde expansion:

    ```zsh
    % ~/bin/foo
    ```

## Fixed highlighting of:

- quoted command words:

    ```zsh
    % \ls
    ```

- backslash escapes in "" strings:

    ```zsh
    % echo "\x41"
    ```

- noglob after command separator:

    ```zsh
    % :; noglob echo *
    ```

- glob after command separator, when the first command starts with 'noglob':

    ```zsh
    % noglob true; echo *
    ```

- the region (vi visual mode / set-mark-command) (issue #165)

- redirection and command separators that would be highlighted as `path_approx`

    ```zsh
    % echo foo;‸
    % echo <‸
    ```

    (where `‸` represents the cursor location)

- escaped globbing (outside quotes)

    ```zsh
    % echo \*
    ```


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

