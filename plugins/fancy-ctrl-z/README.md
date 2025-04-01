# fancy-ctrl-z

Allows pressing Ctrl-Z again to switch back to the most recently backgrounded
job. If there are precisely two backgrounded jobs, Ctrl-Z will toggle between
them, bringing the other one back.

To use it, add `fancy-ctrl-z` to the `plugins` array in your `.zshrc` file:

```zsh
plugins=(... fancy-ctrl-z)
```

## Motivation

I frequently need to execute random commands in my shell. To achieve it I pause
Vim by pressing Ctrl-Z, type command and press fg<Enter> to switch back to Vim.
The fg part really hurts me. I just wanted to hit Ctrl-Z once again to get back
to Vim. I could not find a solution, so I developed one on my own that
works wonderfully with ZSH.

Source: http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/

Credits:
- original idea by [@sheerun](https://github.com/sheerun)
- added to OMZ by [@mbologna](https://github.com/mbologna)
- two-job switching added by [@Whisperity](https://github.com/Whisperity)
