# color and bgcolor ANSI escape code helper functions

Two functions with completions help to simplify shell color output with `echo -e`.

```sh
echo -e "$(color 016 'this colored') $(bgcolor 016\;1 'colored background')"
```
