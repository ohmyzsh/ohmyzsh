zsh-syntax-highlighting [![Build Status][build-status-image]][build-status]
=======================

**[Fish shell][fish]-like syntax highlighting for [Zsh][zsh].**

*Requirements: zsh 4.3.11+.*

[fish]: https://fishshell.com/
[zsh]: https://www.zsh.org/

This package provides syntax highlighting for the shell zsh.  It enables
highlighting of commands whilst they are typed at a zsh prompt into an
interactive terminal.  This helps in reviewing commands before running
them, particularly in catching syntax errors.

Some examples:

Before: [![Screenshot #1.1](images/before1-smaller.png)](images/before1.png)
<br/>
After:&nbsp; [![Screenshot #1.2](images/after1-smaller.png)](images/after1.png)

Before: [![Screenshot #2.1](images/before2-smaller.png)](images/before2.png)
<br/>
After:&nbsp; [![Screenshot #2.2](images/after2-smaller.png)](images/after2.png)

Before: [![Screenshot #3.1](images/before3-smaller.png)](images/before3.png)
<br/>
After:&nbsp; [![Screenshot #3.2](images/after3-smaller.png)](images/after3.png)

Before: [![Screenshot #4.1](images/before4-smaller.png)](images/before4-smaller.png)
<br/>
After:&nbsp; [![Screenshot #4.2](images/after4-smaller.png)](images/after4-smaller.png)



How to install
--------------

See [INSTALL.md](INSTALL.md).


FAQ
---

### Why must `zsh-syntax-highlighting.zsh` be sourced at the end of the `.zshrc` file?

zsh-syntax-highlighting works by hooking into the Zsh Line Editor (ZLE) and
computing syntax highlighting for the command-line buffer as it stands at the
time z-sy-h's hook is invoked.

In zsh 5.2 and older,
`zsh-syntax-highlighting.zsh` hooks into ZLE by wrapping ZLE widgets.  It must
be sourced after all custom widgets have been created (i.e., after all `zle -N`
calls and after running `compinit`) in order to be able to wrap all of them.
Widgets created after z-sy-h is sourced will work, but will not update the
syntax highlighting.

In zsh newer than 5.8 (not including 5.8 itself),
zsh-syntax-highlighting uses the `add-zle-hook-widget` facility to install
a `zle-line-pre-redraw` hook.  Hooks are run in order of registration,
therefore, z-sy-h must be sourced (and register its hook) after anything else
that adds hooks that modify the command-line buffer.

### Does syntax highlighting work during incremental history search?

Highlighting the command line during an incremental history search (by default bound to
to <kbd>Ctrl+R</kbd> in zsh's emacs keymap) requires zsh 5.4 or newer.

Under zsh versions older than 5.4, the zsh-default [underlining][zshzle-Character-Highlighting]
of the matched portion of the buffer remains available, but zsh-syntax-highlighting's
additional highlighting is unavailable.  (Those versions of zsh do not provide
enough information to allow computing the highlighting correctly.)

See issues [#288][i288] and [#415][i415] for details.

[zshzle-Character-Highlighting]: https://zsh.sourceforge.io/Doc/Release/Zsh-Line-Editor.html#Character-Highlighting
[i288]: https://github.com/zsh-users/zsh-syntax-highlighting/pull/288
[i415]: https://github.com/zsh-users/zsh-syntax-highlighting/pull/415

### How are new releases announced?

There is currently no "push" announcements channel.  However, the following
alternatives exist:

- GitHub's RSS feed of releases: https://github.com/zsh-users/zsh-syntax-highlighting/releases.atom
- An anitya entry: https://release-monitoring.org/project/7552/


How to tweak
------------

Syntax highlighting is done by pluggable highlighter scripts.  See the
[documentation on highlighters](docs/highlighters.md) for details and
configuration settings.

[build-status]: https://github.com/zsh-users/zsh-syntax-highlighting/actions
[build-status-image]: https://github.com/zsh-users/zsh-syntax-highlighting/workflows/Tests/badge.svg
