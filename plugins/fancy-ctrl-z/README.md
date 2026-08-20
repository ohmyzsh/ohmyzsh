# fancy-ctrl-z

Allows pressing <kbd>Ctrl</kbd>-<kbd>Z</kbd> is an empty prompt to bring to the
foreground the only suspended job, or, if there are more than one such jobs, to
switch between the two most recently suspended ones.

To use it, add `fancy-ctrl-z` to the `plugins` array in your `.zshrc` file:

```zsh
plugins=(... fancy-ctrl-z)
```

## Motivation

I frequently need to execute random commands in my shell.
To achieve it, I often pause Vim by pressing <kbd>Ctrl</kbd>-<kbd>Z</kbd>, type
a command and then would use `fg`<kbd>↵ Enter</kbd> to switch back to Vim.
Having to type in the `fg` part really hurt me.
I just wanted to hit <kbd>Ctrl</kbd>-<kbd>Z</kbd> once again to get back to Vim.
I could not find a solution, so I developed one on my own that works wonderfully
with Zsh.

Switching between the last two suspended jobs is motivated by both TV remotes
that had such feature, and tools like `cd -` and `git checkout -` that switch
between the current and the second most recent state (directory, branch, etc.).
Sometimes, you have your Vim where code is changed, and another longer-running
process (e.g., a `tail` on some logs, or a Python interpreter) where you want
to test or observe your changes.
There is no point in time where you would "have the editor open" and "have the
program open" together, and the workflow clearly mandates always switching
back and forth between the two.
That's why the original version of _fancy-ctrl-z_ was extended with this "even
fancier" behaviour, because the original version would've opened Vim back again
and again.

## Credits

- Original idea by [@sheerun](https://github.com/sheerun), http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity
- Added to OMZ by [@mbologna](https://github.com/mbologna)
- Two-job switching added by [@Whisperity](https://github.com/Whisperity)
