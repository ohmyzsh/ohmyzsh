# emotty plugin

This plugin returns an emoji for the current $TTY number so it can be used
in a prompt.

To use it, add emotty to the plugins array in your zshrc file:
```
plugins=(... emotty)
```

**NOTE:** it requires the [emoji plugin](https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/emoji).

## Usage

The function `emotty` displays an emoji from the current character set (default: `emoji`), based
on the number associated to the `$TTY`.

There are different sets of emoji characters available, to choose a different
set, set `$emotty_set` to the name of the set you would like to use, e.g.:
```
emotty_set=nature
```

### Character Sets

- emoji
- loral
- love
- nature
- stellar
- zodiac

Use the `display_emotty` function to list the emojis in the current character set, or
the character set passed as the first argument. For example:

```
$ display_emotty zodiac
<list of all the emojis in the zodiac character set>
```
