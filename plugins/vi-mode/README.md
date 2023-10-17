# vi-mode plugin

This plugin increase `vi-like` zsh functionality.

To use it, add `vi-mode` to the plugins array in your zshrc file:

```zsh
plugins=(... vi-mode)
```

## Settings

- `VI_MODE_RESET_PROMPT_ON_MODE_CHANGE`: controls whether the prompt is redrawn when
  switching to a different input mode. If this is unset, the mode indicator will not
  be updated when changing to a different mode.
  Set it to `true` to enable it. For example:

  ```zsh
  VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
  ```

  The default value is unset, unless `vi_mode_prompt_info` is used, in which case it'll
  automatically be set to `true`.

- `VI_MODE_SET_CURSOR`: controls whether the cursor style is changed when switching
  to a different input mode. Set it to `true` to enable it (default: unset):

  ```zsh
  VI_MODE_SET_CURSOR=true
  ```

  See [Cursor Styles](#cursor-styles) for controlling how the cursor looks in different modes

- `MODE_INDICATOR`: controls the string displayed when the shell is in normal mode.
  See [Mode indicators](#mode-indicators) for details.

- `INSERT_MODE_INDICATOR`: controls the string displayed when the shell is in insert mode.
  See [Mode indicators](#mode-indicators) for details.

## Mode indicators

*Normal mode* is indicated with a red `<<<` mark at the right prompt, when it
hasn't been defined by theme, *Insert mode* is not displayed by default.

You can change these indicators by setting the `MODE_INDICATOR` (*Normal mode*) and
`INSERT_MODE_INDICATORS` (*Insert mode*) variables.
This settings support Prompt Expansion sequences. For example:

```zsh
MODE_INDICATOR="%F{white}+%f"
INSERT_MODE_INDICATOR="%F{yellow}+%f"
```

### Adding mode indicators to your prompt

`Vi-mode` by default will add mode indicators to `RPROMPT` **unless** that is defined by 
a preceding plugin.

If `PROMPT` or `RPROMPT` is not defined to your liking, you can add mode info manually. The `vi_mode_prompt_info` function is available to insert mode indicator information.

Here are some examples:

```bash
source $ZSH/oh-my-zsh.sh

PROMPT="$PROMPT\$(vi_mode_prompt_info)"
RPROMPT="\$(vi_mode_prompt_info)$RPROMPT"
```

Note the `\$` here, which importantly prevents interpolation at the time of defining, but allows it to be executed for each prompt update event.

## Cursor Styles

You can control the cursor style used in each active vim mode by changing the values of the following variables.

```zsh
# defaults
VI_MODE_CURSOR_NORMAL=2
VI_MODE_CURSOR_VISUAL=6
VI_MODE_CURSOR_INSERT=6
VI_MODE_CURSOR_OPPEND=0
```

- 0, 1 - Blinking block
- 2 - Solid block
- 3 - Blinking underline
- 4 - Solid underline
- 5 - Blinking line
- 6 - Solid line

## Key bindings

Use `ESC` or `CTRL-[` to enter `Normal mode`.

NOTE: some of these key bindings are set by zsh by default when using a vi-mode keymap.

### History

- `ctrl-p` : Previous command in history
- `ctrl-n` : Next command in history
- `/`      : Search backward in history
- `n`      : Repeat the last `/`

### Vim edition

- `vv`     : Edit current command line in Vim

NOTE: this used to be bound to `v`. That is now the default (`visual-mode`).

### Movement

- `$`   : To the end of the line
- `^`   : To the first non-blank character of the line
- `0`   : To the first character of the line
- `w`   : [count] words forward
- `W`   : [count] WORDS forward
- `e`   : Forward to the end of word [count] inclusive
- `E`   : Forward to the end of WORD [count] inclusive
- `b`   : [count] words backward
- `B`   : [count] WORDS backward
- `t{char}`   : Till before [count]'th occurrence of {char} to the right
- `T{char}`   : Till before [count]'th occurrence of {char} to the left
- `f{char}`   : To [count]'th occurrence of {char} to the right
- `F{char}`   : To [count]'th occurrence of {char} to the left
- `;`   : Repeat latest f, t, F or T [count] times
- `,`   : Repeat latest f, t, F or T in opposite direction

### Insertion

- `i`   : Insert text before the cursor
- `I`   : Insert text before the first character in the line
- `a`   : Append text after the cursor
- `A`   : Append text at the end of the line
- `o`   : Insert new command line below the current one
- `O`   : Insert new command line above the current one

### Delete and Insert

- `ctrl-h`      : While in *Insert mode*: delete character before the cursor
- `ctrl-w`      : While in *Insert mode*: delete word before the cursor
- `d{motion}`   : Delete text that {motion} moves over
- `dd`          : Delete line
- `D`           : Delete characters under the cursor until the end of the line
- `c{motion}`   : Delete {motion} text and start insert
- `cc`          : Delete line and start insert
- `C`           : Delete to the end of the line and start insert
- `P`           : Insert the contents of the clipboard before the cursor
- `p`           : Insert the contents of the clipboard after the cursor
- `r{char}`     : Replace the character under the cursor with {char}
- `R`           : Enter replace mode: Each character replaces existing one
- `x`           : Delete `count` characters under and after the cursor
- `X`           : Delete `count` characters before the cursor

NOTE: delete/kill commands (`dd`, `D`, `c{motion}`, `C`, `x`,`X`) and yank commands
(`y`, `Y`) will copy to the clipboard. Contents can then be put back using paste commands
(`P`, `p`).

## Known issues

### Low `$KEYTIMEOUT`

A low `$KEYTIMEOUT` value (< 15) means that key bindings that need multiple characters,
like `vv`, will be very difficult to trigger. `$KEYTIMEOUT` controls the number of
milliseconds that must pass before a key press is read and the appropriate key binding
is triggered. For multi-character key bindings, the key presses need to happen before
the timeout is reached, so on low timeouts the key press happens too slow, and therefore
another key binding is triggered.

We recommend either setting `$KEYTIMEOUT` to a higher value, or remapping the key bindings
that you want to trigger to a keyboard sequence. For example:

```zsh
bindkey -M vicmd 'V' edit-command-line # this remaps `vv` to `V` (but overrides `visual-mode`)
```
